//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMEnduserApi.h"
#import "XMMPushDevice.h"
#import "XMMSimpleStorage.h"
#import <dispatch/dispatch.h>

NSString * const kApiProdURLString = @"https://api.xamoom.net/";
NSString * const kApiDevBaseURLString = @"https://xamoom-dev.appspot.com/";
NSString * const kHTTPContentType = @"application/vnd.api+json";
NSString * const kHTTPUserAgent = @"XamoomSDK iOS";
NSString * const kEphemeralIdKey = @"com.xamoom.EphemeralId";
NSString * const kAuthorizationKey = @"com.xamoom.AuthorizationId";
NSString * const kEphemeralIdHttpHeaderName = @"X-Ephemeral-Id";
NSString * const kAuthorization = @"Authorization";
NSString * const kReasonHttpHeaderName = @"X-Reason";
NSString * const kLastPushRegisterKey = @"com.xamoom.last-push-register";


@interface XMMEnduserApi () <XMMRestClientDelegate>

@property (nonatomic, strong) NSString *ephemeralId;
@property (nonatomic, strong) NSString *authorizationId;

@end

#pragma mark - XMMEnduserApi

/**
 * Shared instance.
 */
static XMMEnduserApi *sharedInstance;

@implementation XMMEnduserApi : NSObject

@synthesize pushSound = _pushSound;

#pragma mark - shared instance

+ (instancetype)sharedInstanceWithKey:(NSString *)apikey {
  NSAssert(apikey != nil, @"apikey is nil. Please use an apikey");
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] initWithApiKey:apikey];
  });
  return sharedInstance;
}

+ (instancetype)sharedInstance {
  NSAssert(sharedInstance != nil, @"SharedInstance is nil. Use sharedInstanceWithKey:apikey or saveSharedInstance:instance");
  return sharedInstance;
}

+ (void)saveSharedInstance:(XMMEnduserApi *)instance {
  sharedInstance = instance;
}

#pragma mark - init

- (instancetype)initWithApiKey:(NSString *)apikey {
  return [self initWithApiKey:apikey isProduction:true];
}

- (instancetype)initWithApiKey:(NSString *)apikey isProduction:(BOOL)isProduction {
  self = [super init];
  self.systemLanguage = [self systemLanguageWithoutRegionCode];
  self.language = self.systemLanguage;
  self.offlineApi = [[XMMOfflineApi alloc] init];
  [XMMOfflineStorageManager sharedInstance];
  
  NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
  [config setHTTPAdditionalHeaders:@{@"Content-Type":kHTTPContentType,
                                     @"User-Agent":[self customUserAgentFrom:@""],
                                     @"APIKEY":apikey,}];
  
  NSString *apiUrl = @"";
  if (isProduction) {
    apiUrl = kApiProdURLString;
  } else {
    apiUrl = kApiDevBaseURLString;
  }
  
  self.restClient = [[XMMRestClient alloc] initWithBaseUrl:[NSURL URLWithString: apiUrl]
                                                   session:[NSURLSession sessionWithConfiguration:config]];
  self.restClient.delegate = self;
  [self setupResources];
  self.pushSound = YES;
  return self;
}

- (instancetype)initWithRestClient:(XMMRestClient *)restClient {
  self = [super init];
  self.systemLanguage = [self systemLanguageWithoutRegionCode];
  self.language = self.systemLanguage;
  self.offlineApi = [[XMMOfflineApi alloc] init];
  [XMMOfflineStorageManager sharedInstance];
  
  self.restClient = restClient;
  self.restClient.delegate = self;
  [self setupResources];
  return self;
}

- (NSString *)systemLanguageWithoutRegionCode {
  NSString *preferredLanguage = [NSLocale preferredLanguages][0];
  return [preferredLanguage substringWithRange:NSMakeRange(0, 2)];
}

- (void)setupResources {
  [JSONAPIResourceDescriptor addResource:[XMMSystem class]];
  [JSONAPIResourceDescriptor addResource:[XMMSystemSettings class]];
  [JSONAPIResourceDescriptor addResource:[XMMStyle class]];
  [JSONAPIResourceDescriptor addResource:[XMMMenu class]];
  [JSONAPIResourceDescriptor addResource:[XMMContent class]];
  [JSONAPIResourceDescriptor addResource:[XMMContentBlock class]];
  [JSONAPIResourceDescriptor addResource:[XMMSpot class]];
  [JSONAPIResourceDescriptor addResource:[XMMMarker class]];
  [JSONAPIResourceDescriptor addResource:[XMMPushDevice class]];
}

#pragma mark - public methods

#pragma mark content calls

- (NSURLSessionDataTask *)contentWithID:(NSString *)contentID password:(NSString *_Nullable)password completion:(void(^)(XMMContent *content, NSError *error, BOOL passwordRequired))completion {
  return [self contentWithID:contentID options:0 reason:0 password:password completion:completion];
}

- (NSURLSessionDataTask *)contentWithID:(NSString *)contentID options:(XMMContentOptions)options password:(NSString *_Nullable)password completion:(void (^)(XMMContent *content, NSError *error, BOOL passwordRequired))completion {
  return [self contentWithID:contentID options:options reason:0 password:password completion:completion];
}

- (NSURLSessionDataTask *)contentWithID:(NSString *)contentID
                                options:(XMMContentOptions)options
                                 reason:(XMMContentReason)reason
                               password:(NSString *_Nullable)password
                             completion:(void (^)(XMMContent *, NSError *, BOOL passwordRequired))completion {
  if (self.isOffline) {
    [self.offlineApi contentWithID:contentID completion:completion];
    return nil;
  }
  
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language];
  if (options > 0) {
    params = [XMMParamHelper addContentOptionsToParams:params options:options];
  }
  
  NSMutableDictionary *headers = [self httpHeadersWithEphemeralId];
  headers = [self addHeaderForReason:headers
                              reason:reason];
  
  if (password != nil) {
    NSUserDefaults *userDefaults = [self getUserDefaults];
    int passwordEnters = [userDefaults integerForKey:contentID];
    passwordEnters = passwordEnters + 1;
    [userDefaults setInteger:passwordEnters forKey:contentID];
    [userDefaults synchronize];
    [headers setValue:password forKey:@"X-Password"];
  }
  
  NSUserDefaults *userDefaults = [self getUserDefaults];
  
  return [self.restClient fetchResource:[XMMContent class]
                                     id:contentID
                             parameters:params
                                headers:headers
                             completion:^(JSONAPI *result, NSError *error) {
                               
                               if (error && completion) {
                                 
                                 NSString *errorCodeString = [error.userInfo objectForKey:@"code"];
                                 NSString *errorStatusString = [error.userInfo objectForKey:@"status"];
                                 
                                 int errorCode = [errorCodeString intValue];
                                 int errorStatus = [errorStatusString intValue];
                                 
                                 if (errorCode == 92 && errorStatus == 401) {
                                   
                                   if ([self shouldShowPasswordForContentId:contentID password:password error:error completion:completion]) {
                                     completion(nil, error, YES);
                                     return;
                                   }
                                   
                                   return;
                                 } else if (errorCode == 93 && errorStatus == 404) {
                                   [self contentsWithTags:@[@"x-forbidden"] pageSize:10 cursor:nil sort:nil completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *e) {
                                     
                                     if (e) {
                                       completion(nil, e, NO);
                                       return;
                                     }
                                     
                                     if (contents.firstObject != nil) {
                                       completion(contents.firstObject, nil, NO);
                                       return;
                                     } else {
                                       completion(nil, error, NO);
                                       return;
                                     }
                                   }];
                                   
                                   return;
                                 } else {
                                   [userDefaults setInteger:0 forKey:contentID];
                                   [userDefaults synchronize];
                                   completion(nil, error, NO);
                                   return;
                                 }
                               }
                               
                               XMMContent *content = result.resource;
                               
                               if (completion) {
                                 [userDefaults setInteger:0 forKey:contentID];
                                 [userDefaults synchronize];
                                 completion(content, error, NO);
                               }
                             }];
}

- (NSURLSessionDataTask *)contentWithLocationIdentifier:(NSString *)locationIdentifier password:(NSString *_Nullable)password completion:(void (^)(XMMContent *content, NSError *error, BOOL passwordRequired))completion {
  return [self contentWithLocationIdentifier:locationIdentifier
                                     options:0
                                    password:password
                                  completion:completion];
}

- (NSURLSessionDataTask *)contentWithLocationIdentifier:(NSString *)locationIdentifier options:(XMMContentOptions)options password:(NSString *_Nullable)password completion:(void (^)(XMMContent *content, NSError *error, BOOL passwordRequired))completion {
  return [self contentWithLocationIdentifier:locationIdentifier
                                     options:options
                                  conditions:nil
                                    password:password
                                  completion:completion];
}

- (NSURLSessionDataTask *)contentWithLocationIdentifier:(NSString *)locationIdentifier options:(XMMContentOptions)options conditions:(NSDictionary *)conditions password:(NSString *_Nullable)password completion:(void (^)(XMMContent *, NSError *, BOOL passwordRequired))completion {
  return [self contentWithLocationIdentifier:locationIdentifier
                                     options:options
                                  conditions:conditions
                                      reason:0
                                    password:password
                                  completion:completion];
}

- (NSURLSessionDataTask *)contentWithLocationIdentifier:(NSString *)locationIdentifier
                                                options:(XMMContentOptions)options
                                             conditions:(NSDictionary *)conditions
                                                 reason:(XMMContentReason)reason
                                               password:(NSString *_Nullable)password
                                             completion:(void (^)(XMMContent *,
                                                                  NSError *, BOOL passwordRequired))completion {
  if (self.isOffline) {
    [self.offlineApi contentWithLocationIdentifier:locationIdentifier completion:completion];
    return nil;
  }
  NSMutableDictionary *mutableConditions = nil;
  if (conditions == nil) {
    mutableConditions = [[NSMutableDictionary alloc] init];
  } else {
    mutableConditions = [conditions mutableCopy];
  }
  
  [mutableConditions setObject:[[NSDate alloc] init] forKey:@"x-datetime"];
  conditions = mutableConditions;
  
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language locationIdentifier:locationIdentifier];
  params = [XMMParamHelper addContentOptionsToParams:params options:options];
  params = [XMMParamHelper addConditionsToParams:params conditions:conditions];
  
  NSMutableDictionary *headers = [self httpHeadersWithEphemeralId];
  headers = [self addHeaderForReason:headers
                              reason:reason];
  if (password != nil) {
    NSUserDefaults *userDefaults = [self getUserDefaults];
    int passwordEnters = [userDefaults integerForKey:locationIdentifier];
    passwordEnters = passwordEnters + 1;
    [userDefaults setInteger:passwordEnters forKey:locationIdentifier];
    [userDefaults synchronize];
    [headers setValue:password forKey:@"X-Password"];
  }
  
  NSUserDefaults *userDefaults = [self getUserDefaults];
  
  return [self.restClient fetchResource:[XMMContent class]
                             parameters:params
                                headers:headers
                             completion:^(JSONAPI *result, NSError *error) {
                               if (error && completion) {
                                 
                                 NSString *errorCodeString = [error.userInfo objectForKey:@"code"];
                                 NSString *errorStatusString = [error.userInfo objectForKey:@"status"];
                                 
                                 int errorCode = [errorCodeString intValue];
                                 int errorStatus = [errorStatusString intValue];
                                 
                                 if (errorCode == 92 && errorStatus == 401) {
                                   
                                   if ([self shouldShowPasswordForLocId:locationIdentifier password: password error:error completion:completion]) {
                                     completion(nil, error, YES);
                                     return;
                                   }
                                 } else {
                                   [userDefaults setInteger:0 forKey:locationIdentifier];
                                   [userDefaults synchronize];
                                   completion(nil, error, NO);
                                   return;
                                 }
                               }
                               
                               XMMContent *content = result.resource;
                               
                               if (completion) {
                                 [userDefaults setInteger:0 forKey:locationIdentifier];
                                 [userDefaults synchronize];
                                 completion(content, error, NO);
                               }
                             }];
}

- (NSURLSessionDataTask *)contentWithBeaconMajor:(NSNumber *)major minor:(NSNumber *)minor completion:(void (^)(XMMContent *content, NSError *error, BOOL passwordRequired))completion {
  return [self contentWithLocationIdentifier:[NSString stringWithFormat:@"%@|%@", major, minor] password:nil completion:completion];
}

- (NSURLSessionDataTask *)contentWithBeaconMajor:(NSNumber *)major minor:(NSNumber *)minor options:(XMMContentOptions)options completion:(void (^)(XMMContent *content, NSError *error, BOOL passwordRequired))completion {
  return [self contentWithLocationIdentifier:[NSString stringWithFormat:@"%@|%@", major, minor] options:options  password:nil completion:completion];
}

- (NSURLSessionDataTask *)contentWithBeaconMajor:(NSNumber *)major minor:(NSNumber *)minor options:(XMMContentOptions)options conditions:(NSDictionary *)conditions completion:(void (^)(XMMContent *, NSError *, BOOL passwordRequired))completion {
  return [self contentWithLocationIdentifier:[NSString stringWithFormat:@"%@|%@", major, minor] options:options conditions:conditions password:nil completion:completion];
}

- (NSURLSessionDataTask *)contentWithBeaconMajor:(NSNumber *)major minor:(NSNumber *)minor options:(XMMContentOptions)options conditions:(NSDictionary *)conditions reason:(XMMContentReason)reason completion:(void (^)(XMMContent *, NSError *, BOOL passwordRequired))completion {
  return [self contentWithLocationIdentifier:[NSString stringWithFormat:@"%@|%@", major, minor]
                                     options:options
                                  conditions:conditions
                                      reason:reason
                                    password:nil
                                  completion:completion];
}

#pragma mark contents calls

- (NSURLSessionDataTask *)contentsWithLocation:(CLLocation *)location pageSize:(int)pageSize cursor:(NSString *)cursor sort:(XMMContentSortOptions)sortOptions completion:(void (^)(NSArray *contents, bool hasMore, NSString *cursor, NSError *error))completion {
  
  if (self.isOffline) {
    [self.offlineApi contentsWithLocation:location pageSize:pageSize cursor:cursor sort:sortOptions completion:completion];
    return nil;
  }
  
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language location:location];
  params = [XMMParamHelper addPagingToParams:params pageSize:pageSize cursor:cursor];
  params = [XMMParamHelper addContentSortOptionsToParams:params options:sortOptions];
  
  return [self.restClient fetchResource:[XMMContent class]
                             parameters:params
                                headers:[self httpHeadersWithEphemeralId]
                             completion:^(JSONAPI *result, NSError *error) {
                               if (error && completion) {
                                 completion(nil, NO, nil, error);
                                 return;
                               }
                               
                               NSString *hasMoreValue = [result.meta objectForKey:@"has-more"];
                               bool hasMore = [hasMoreValue boolValue];
                               NSString *cursor = [result.meta objectForKey:@"cursor"];
                               
                               if (completion) {
                                 completion(result.resources, hasMore, cursor, error);
                               }
                             }];
}

- (NSURLSessionDataTask *)contentsWithTags:(NSArray *)tags pageSize:(int)pageSize cursor:(NSString *)cursor sort:(XMMContentSortOptions)sortOptions completion:(void (^)(NSArray *contents, bool hasMore, NSString *cursor, NSError *error))completion {
  return [self contentsWithTags:tags pageSize:pageSize cursor:cursor sort:sortOptions filter:nil completion:completion];
}

- (NSURLSessionDataTask *)contentsWithTags:(NSArray *)tags pageSize:(int)pageSize cursor:(NSString *)cursor sort:(XMMContentSortOptions)sortOptions filter:(XMMFilter *)filter completion:(void (^)(NSArray *contents, bool hasMore, NSString *cursor, NSError *error))completion {
  
  XMMFilter *filters = [XMMFilter makeWithBuilder:^(XMMFilterBuilder *builder) {
    builder.tags = tags;
    
    builder.name = filter.name;
    builder.fromDate = filter.fromDate;
    builder.toDate = filter.toDate;
    builder.relatedSpotID = filter.relatedSpotID;
  }];
  
  if (self.isOffline) {
    [self.offlineApi contentsWithTags:tags pageSize:pageSize cursor:cursor sort:sortOptions filter:filter completion:completion];
    return nil;
  }
  
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language];
  params = [XMMParamHelper addFiltersToParams:params filters:filters];
  params = [XMMParamHelper addPagingToParams:params pageSize:pageSize cursor:cursor];
  params = [XMMParamHelper addContentSortOptionsToParams:params options:sortOptions];
  
  return [self.restClient fetchResource:[XMMContent class]
                             parameters:params
                                headers:[self httpHeadersWithEphemeralId]
                             completion:^(JSONAPI *result, NSError *error) {
                               if (error && completion) {
                                 completion(nil, NO, nil, error);
                                 return;
                               }
                               
                               NSString *hasMoreValue = [result.meta objectForKey:@"has-more"];
                               bool hasMore = [hasMoreValue boolValue];
                               NSString *cursor = [result.meta objectForKey:@"cursor"];
                               
                               if (completion) {
                                 completion(result.resources, hasMore, cursor, error);
                               }
                             }];
}

- (NSURLSessionDataTask *)contentsWithName:(NSString *)name pageSize:(int)pageSize cursor:(NSString *)cursor sort:(XMMContentSortOptions)sortOptions completion:(void (^)(NSArray *contents, bool hasMore, NSString *cursor, NSError *error))completion {
  return [self contentsWithName:name pageSize:pageSize cursor:cursor sort:sortOptions filter:nil completion:completion];
}

- (NSURLSessionDataTask *)contentsWithName:(NSString *)name pageSize:(int)pageSize cursor:(NSString *)cursor sort:(XMMContentSortOptions)sortOptions filter:(XMMFilter *)filter completion:(void (^)(NSArray *contents, bool hasMore, NSString *cursor, NSError *error))completion {
  XMMFilter *filters = [XMMFilter makeWithBuilder:^(XMMFilterBuilder *builder) {
    builder.name = name;
    
    builder.tags = filter.tags;
    builder.fromDate = filter.fromDate;
    builder.toDate = filter.toDate;
    builder.relatedSpotID = filter.relatedSpotID;
  }];
  
  if (self.isOffline) {
    [self.offlineApi contentsWithName:name pageSize:pageSize cursor:cursor sort:sortOptions filter:filter completion:completion];
    return nil;
  }
  
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language];
  params = [XMMParamHelper addFiltersToParams:params filters:filters];
  params = [XMMParamHelper addPagingToParams:params pageSize:pageSize cursor:cursor];
  params = [XMMParamHelper addContentSortOptionsToParams:params options:sortOptions];
  
  return [self.restClient fetchResource:[XMMContent class]
                             parameters:params
                                headers:[self httpHeadersWithEphemeralId]
                             completion:^(JSONAPI *result, NSError *error) {
                               if (error && completion) {
                                 completion(nil, NO, nil, error);
                                 return;
                               }
                               
                               NSString *hasMoreValue = [result.meta objectForKey:@"has-more"];
                               bool hasMore = [hasMoreValue boolValue];
                               NSString *cursor = [result.meta objectForKey:@"cursor"];
                               
                               if (completion) {
                                 completion(result.resources, hasMore, cursor, error);
                               }
                             }];
}

- (NSURLSessionDataTask *)contentsFrom:(NSDate *)fromDate to:(NSDate *)toDate relatedSpot:(NSString *)relatedSpotID pageSize:(int)pageSize cursor:(NSString *)cursor sort:(XMMContentSortOptions)sortOptions completion:(void (^)(NSArray *contents, bool hasMore, NSString *cursor, NSError *error))completion {
  
  XMMFilter *filters = [XMMFilter makeWithBuilder:^(XMMFilterBuilder *builder) {
    builder.fromDate = fromDate;
    builder.toDate = toDate;
    builder.relatedSpotID = relatedSpotID;
  }];
  
  if (self.isOffline) {
    [self.offlineApi contentsFrom:fromDate to:toDate pageSize:pageSize cursor:cursor sort:sortOptions filter:filters completion:completion];
    return nil;
  }
  
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language];
  
  params = [XMMParamHelper addPagingToParams:params pageSize:pageSize cursor:cursor];
  params = [XMMParamHelper addFiltersToParams:params filters:filters];
  params = [XMMParamHelper addContentSortOptionsToParams:params options:sortOptions];
  
  return [self.restClient fetchResource:[XMMContent class]
                             parameters:params
                                headers:[self httpHeadersWithEphemeralId]
                             completion:^(JSONAPI *result, NSError *error) {
                               if (error && completion) {
                                 completion(nil, NO, nil, error);
                                 return;
                               }
                               
                               NSString *hasMoreValue = [result.meta objectForKey:@"has-more"];
                               bool hasMore = [hasMoreValue boolValue];
                               NSString *cursor = [result.meta objectForKey:@"cursor"];
                               
                               if (completion) {
                                 completion(result.resources, hasMore, cursor, error);
                               }
                             }];
}

- (NSURLSessionDataTask *_Nullable)contentRecommendationsWithCompletion:(void (^_Nullable)(NSArray * _Nullable contents, bool hasMore, NSString * _Nullable cursor, NSError * _Nullable error))completion {
  if (self.isOffline) {
    NSLog(@"Content Recommendations not available when offline");
    completion(nil, false, nil, [[NSError alloc]
                                 initWithDomain:@"com.xamoom"
                                 code:0
                                 userInfo:@{@"detail":@"Content Recommendations not available when offline",}]);
    return nil;
  }
  
  if ([self getEphemeralId] == nil) {
    NSLog(@"Content Recommendations not available without ephemeral id, please first call backend another way.");
    completion(nil, false, nil, [[NSError alloc]
                                 initWithDomain:@"com.xamoom"
                                 code:0
                                 userInfo:@{@"detail":@"Content Recommendations not available without ephemeral id, please first call backend another way",}]);
    return nil;
  }
  
  if ([self getAuthorizationId] == nil) {
    NSLog(@"Content Recommendations not available without authorization id, please first call backend another way.");
    completion(nil, false, nil, [[NSError alloc]
                                 initWithDomain:@"com.xamoom"
                                 code:0
                                 userInfo:@{@"detail":@"Content Recommendations not available without authorization id, please first call backend another way",}]);
    return nil;
  }
  
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language];
  params = [XMMParamHelper addRecommendationsToParams:params];
  
  NSMutableDictionary *headers = [self httpHeadersWithEphemeralId];
  
  return [self.restClient fetchResource:[XMMContent class]
                             parameters:params
                                headers:headers
                             completion:^(JSONAPI *result, NSError *error) {
                               if (error && completion) {
                                 completion(nil, NO, nil, error);
                                 return;
                               }
                               
                               NSString *hasMoreValue = [result.meta objectForKey:@"has-more"];
                               bool hasMore = [hasMoreValue boolValue];
                               NSString *cursor = [result.meta objectForKey:@"cursor"];
                               
                               if (completion) {
                                 completion(result.resources, hasMore, cursor, error);
                               }
                             }];
}

#pragma mark spot calls

- (NSURLSessionDataTask *)spotWithID:(NSString *)spotID completion:(void (^)(XMMSpot *, NSError *))completion {
  return [self spotWithID:spotID options:XMMSpotOptionsNone completion:completion];
}

- (NSURLSessionDataTask *)spotWithID:(NSString *)spotID options:(XMMSpotOptions)options completion:(void(^)(XMMSpot *spot, NSError *error))completion {
  
  if (self.isOffline) {
    [self.offlineApi spotWithID:spotID completion:completion];
  }
  
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language];
  params = [XMMParamHelper addSpotOptionsToParams:params options:options];
  
  return [self.restClient fetchResource:[XMMSpot class]
                                     id:spotID
                             parameters:params
                                headers:[self httpHeadersWithEphemeralId]
                             completion:^(JSONAPI *result, NSError *error) {
                               if (error && completion) {
                                 completion(nil, error);
                                 return;
                               }
                               
                               XMMSpot *spot = result.resource;
                               
                               if (completion) {
                                 completion(spot, error);
                               }
                             }];
}

#pragma mark spots calls

- (NSURLSessionDataTask *)spotsWithLocation:(CLLocation *)location radius:(int)radius options:(XMMSpotOptions)options sort:(XMMSpotSortOptions)sortOptions completion:(void (^)(NSArray *spots, bool hasMore, NSString *cursor, NSError *error))completion {
  return [self spotsWithLocation:location radius:radius options:options sort:sortOptions pageSize:0 cursor:nil completion:completion];
}

- (NSURLSessionDataTask *)spotsWithLocation:(CLLocation *)location radius:(int)radius options:(XMMSpotOptions)options sort:(XMMSpotSortOptions)sortOptions pageSize:(int)pageSize cursor:(NSString *)cursor completion:(void (^)(NSArray *spots, bool hasMore, NSString *cursor, NSError *error))completion {
  
  if (self.isOffline) {
    [self.offlineApi spotsWithLocation:location radius:radius pageSize:pageSize cursor:cursor completion:completion];
    return nil;
  }
  
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language location:location radius:radius];
  params = [XMMParamHelper addPagingToParams:params pageSize:pageSize cursor:cursor];
  params = [XMMParamHelper addSpotOptionsToParams:params options:options];
  params = [XMMParamHelper addSpotSortOptionsToParams:params options:sortOptions];
  
  return [self.restClient fetchResource:[XMMSpot class]
                             parameters:params
                                headers:[self httpHeadersWithEphemeralId]
                             completion:^(JSONAPI *result, NSError *error) {
                               if (error && completion) {
                                 completion(nil, false, nil, error);
                                 return;
                               }
                               
                               NSString *hasMoreValue = [result.meta objectForKey:@"has-more"];
                               bool hasMore = [hasMoreValue boolValue];
                               NSString *cursor = [result.meta objectForKey:@"cursor"];
                               
                               if (completion) {
                                 completion(result.resources, hasMore, cursor, error);
                               }
                             }];
}

- (NSURLSessionDataTask *)spotsWithTags:(NSArray *)tags options:(XMMSpotOptions)options sort:(XMMSpotSortOptions)sortOptions completion:(void (^)(NSArray *spots, bool hasMore, NSString *cursor, NSError *error))completion {
  return [self spotsWithTags:tags pageSize:100 cursor:nil options:options sort:sortOptions completion:completion];
}

- (NSURLSessionDataTask *)spotsWithTags:(NSArray *)tags pageSize:(int)pageSize cursor:(NSString *)cursor options:(XMMSpotOptions)options sort:(XMMSpotSortOptions)sortOptions completion:(void (^)(NSArray *spots, bool hasMore, NSString *cursor, NSError *error))completion {
  
  if (self.isOffline) {
    [self.offlineApi spotsWithTags:tags pageSize:pageSize cursor:cursor sort:sortOptions completion:completion];
    return nil;
  }
  
  XMMFilter *filters = [XMMFilter makeWithBuilder:^(XMMFilterBuilder *builder) {
    builder.tags = tags;
  }];
  
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language];
  params = [XMMParamHelper addFiltersToParams:params filters:filters];
  params = [XMMParamHelper addPagingToParams:params pageSize:pageSize cursor:cursor];
  params = [XMMParamHelper addSpotOptionsToParams:params options:options];
  params = [XMMParamHelper addSpotSortOptionsToParams:params options:sortOptions];
  
  return [self.restClient fetchResource:[XMMSpot class]
                             parameters:params
                                headers:[self httpHeadersWithEphemeralId]
                             completion:^(JSONAPI *result, NSError *error) {
                               if (error && completion) {
                                 completion(nil, false, nil, error);
                                 return;
                               }
                               
                               NSString *hasMoreValue = [result.meta objectForKey:@"has-more"];
                               bool hasMore = [hasMoreValue boolValue];
                               NSString *cursor = [result.meta objectForKey:@"cursor"];
                               
                               if (completion) {
                                 completion(result.resources, hasMore, cursor, error);
                               }
                             }];
}

- (NSURLSessionDataTask *)spotsWithName:(NSString *)name pageSize:(int)pageSize cursor:(NSString *)cursor options:(XMMSpotOptions)options sort:(XMMSpotSortOptions)sortOptions completion:(void (^)(NSArray *spots, bool hasMore, NSString *cursor, NSError *error))completion {
  if (self.isOffline) {
    [self.offlineApi spotsWithName:name pageSize:pageSize cursor:cursor sort:sortOptions completion:completion];
    return nil;
  }
  
  XMMFilter *filters = [XMMFilter makeWithBuilder:^(XMMFilterBuilder *builder) {
    builder.name = name;
  }];
  
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language];
  params = [XMMParamHelper addFiltersToParams:params filters:filters];
  params = [XMMParamHelper addPagingToParams:params pageSize:pageSize cursor:cursor];
  params = [XMMParamHelper addSpotOptionsToParams:params options:options];
  params = [XMMParamHelper addSpotSortOptionsToParams:params options:sortOptions];
  
  return [self.restClient fetchResource:[XMMSpot class]
                             parameters:params
                                headers:[self httpHeadersWithEphemeralId]
                             completion:^(JSONAPI *result, NSError *error) {
                               if (error && completion) {
                                 completion(nil, false, nil, error);
                                 return;
                               }
                               
                               NSString *hasMoreValue = [result.meta objectForKey:@"has-more"];
                               bool hasMore = [hasMoreValue boolValue];
                               NSString *cursor = [result.meta objectForKey:@"cursor"];
                               
                               if (completion) {
                                 completion(result.resources, hasMore, cursor, error);
                               }
                             }];
}

#pragma mark system calls

- (NSURLSessionDataTask *)systemWithCompletion:(void (^)(XMMSystem *system, NSError *error))completion {
  if (self.isOffline) {
    [self.offlineApi systemWithCompletion:completion];
    return nil;
  }
  
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language];
  return [self.restClient fetchResource:[XMMSystem class]
                             parameters:params
                                headers:[self httpHeadersWithEphemeralId]
                             completion:^(JSONAPI *result, NSError *error) {
                               if (error && completion) {
                                 completion(nil, error);
                                 return;
                               }
                               
                               XMMSystem *system = result.resource;
                               
                               if (completion) {
                                 completion(system, error);
                               }
                             }];
}

- (NSURLSessionDataTask *)systemSettingsWithID:(NSString *)settingsID completion:(void (^)(XMMSystemSettings *settings, NSError *error))completion {
  if (self.isOffline) {
    [self.offlineApi systemSettingsWithID:settingsID completion:completion];
    return nil;
  }
  
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language];
  
  return [self.restClient fetchResource:[XMMSystemSettings class]
                                     id:settingsID
                             parameters:params
                                headers:[self httpHeadersWithEphemeralId]
                             completion:^(JSONAPI *result, NSError *error) {
                               if (error && completion) {
                                 completion(nil, error);
                                 return;
                               }
                               
                               XMMSystemSettings *settings = result.resource;
                               
                               if (completion) {
                                 completion(settings, error);
                               }
                             }];
}

- (NSURLSessionDataTask *)styleWithID:(NSString *)styleID completion:(void (^)(XMMStyle *style, NSError *error))completion {
  if (self.isOffline) {
    [self.offlineApi styleWithID:styleID completion:completion];
    return nil;
  }
  
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language];
  
  return [self.restClient fetchResource:[XMMStyle class]
                                     id:styleID
                             parameters:params
                                headers:[self httpHeadersWithEphemeralId]
                             completion:^(JSONAPI *result, NSError *error) {
                               if (error && completion) {
                                 completion(nil, error);
                                 return;
                               }
                               
                               XMMStyle *style = result.resource;
                               
                               if (completion) {
                                 completion(style, error);
                               }
                             }];
}

- (NSURLSessionDataTask *)menuWithID:(NSString *)menuID completion:(void (^)(XMMMenu *menu, NSError *error))completion {
  if (self.isOffline) {
    [self.offlineApi menuWithID:menuID completion:completion];
    return nil;
  }
  
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language];
  
  return [self.restClient fetchResource:[XMMMenu class]
                                     id:menuID
                             parameters:params
                                headers:[self httpHeadersWithEphemeralId]
                             completion:^(JSONAPI *result, NSError *error) {
                               if (error && completion) {
                                 completion(nil, error);
                                 return;
                               }
                               
                               XMMMenu *menu = result.resource;
                               
                               if (completion) {
                                 completion(menu, error);
                               }
                             }];
}

- (NSURLSessionDataTask *)pushDevice {
  
  double lastPush = [[self getUserDefaults] doubleForKey:kLastPushRegisterKey];
  
  if (lastPush != 0.0 && lastPush > [[NSDate date] timeIntervalSince1970] - 30.0) {
    return nil;
  }
  
  XMMSimpleStorage *storage = [XMMSimpleStorage new];
  NSDictionary *location = [storage getLocation];
  NSString *token = [storage getUserToken];
  NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
  NSString *appId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
  NSString *sdkVersion = @"3.11.1";
  
  if (location != nil && token != nil && version != nil && appId != nil) {
    XMMPushDevice *device = [[XMMPushDevice alloc] init];
    device.uid = token;
    device.location = location;
    device.appId = appId;
    device.appVersion = version;
    device.sdkVersion = sdkVersion;
    
    NSString *pushLog = self.pushSound ? @"Push Device sound: YES" : @"Push Device sound: No";
    NSLog(pushLog);
    
    device.sound = self.pushSound;
    
    double now = [[NSDate date] timeIntervalSince1970];
    NSUserDefaults *userDefaults = [self getUserDefaults];
    [userDefaults setDouble:now forKey:kLastPushRegisterKey];
    [userDefaults synchronize];
    
    NSLog(@"Device Pushed");
    return [self.restClient postPushDevice:[XMMPushDevice class] id:device.uid parameters:nil headers:[self httpHeadersWithEphemeralId] pushDevice:device completion:^(JSONAPI *result, NSError *error) {
      
      if (error) {
        NSError *e = error;
        [userDefaults setDouble:0.0 forKey:kLastPushRegisterKey];
        [userDefaults synchronize];
      }
    }];
  }
  
  return nil;
}

#pragma mark - XMMRestClientDelegate

- (void)gotEphemeralId:(NSString *)ephemeralId {
  if ([self getEphemeralId] == nil ||
      ![[self getEphemeralId] isEqualToString:ephemeralId]) {
    _ephemeralId = ephemeralId;
    NSUserDefaults *userDefaults = [self getUserDefaults];
    [userDefaults setObject:ephemeralId forKey:kEphemeralIdKey];
    [userDefaults synchronize];
  }
}

- (void)gotAuthorizationId:(NSString *)authorizationId {
  if ([self getAuthorizationId] == nil ||
      ![[self getAuthorizationId] isEqualToString:authorizationId]) {
    _authorizationId = authorizationId;
    NSUserDefaults *userDefaults = [self getUserDefaults];
    [userDefaults setObject:authorizationId forKey:kAuthorizationKey];
    [userDefaults synchronize];
  }
}

#pragma mark - EphemeralId

- (NSMutableDictionary *)addHeaderForReason:(NSMutableDictionary *)headers
                                     reason:(XMMContentReason)reason {
  if (reason > 0) {
    [headers setValue:[NSString stringWithFormat:@"%ld", (long)reason]
               forKey:kReasonHttpHeaderName];
  }
  return headers;
}

- (NSMutableDictionary *)httpHeadersWithEphemeralId {
  NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
  _ephemeralId = [self getEphemeralId];
  if (_ephemeralId != nil) {
    NSLog(@"Ephemeral ID");
    NSLog(_ephemeralId);
    [headers setObject:_ephemeralId forKey:kEphemeralIdHttpHeaderName];
  }
  
  _authorizationId = [self getAuthorizationId];
  if (_authorizationId != nil) {
    NSLog(@"Authirization ID");
    NSLog(_authorizationId);
    [headers setObject:_authorizationId forKey:kAuthorization];
  }
  
  return headers;
}

- (NSString *)getEphemeralId {
  if (_ephemeralId != nil) {
    return _ephemeralId;
  }
  
  _ephemeralId = [[self getUserDefaults] objectForKey:kEphemeralIdKey];
  return _ephemeralId;
}

- (NSString *)getAuthorizationId {
  if (_authorizationId != nil) {
    return _authorizationId;
  }
  
  _authorizationId = [[self getUserDefaults] objectForKey:kAuthorizationKey];
  return _authorizationId;
}

- (NSUserDefaults *)getUserDefaults {
  if (_userDefaults == nil) {
    _userDefaults = [NSUserDefaults standardUserDefaults];
  }
  return _userDefaults;
}

#pragma mark - Helper

- (NSString *)customUserAgentFrom:(NSString *)appName {
  NSBundle *bundle = [NSBundle bundleForClass:[XMMEnduserApi class]];
  NSURL *url = [bundle URLForResource:@"XamoomSDK" withExtension:@"bundle"];
  NSBundle *nibBundle;
  if (url) {
    nibBundle = [NSBundle bundleWithURL:url];
  } else {
    nibBundle = bundle;
  }
  NSDictionary *infoDict = [nibBundle infoDictionary];
  NSString *sdkVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
  
  if (appName == nil) {
    appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
  }
  NSData *asciiStringData = [appName dataUsingEncoding:NSASCIIStringEncoding
                                  allowLossyConversion:YES];
  appName = [[NSString alloc] initWithData:asciiStringData
                                  encoding:NSASCIIStringEncoding];
  NSString *customUserAgent = [NSString stringWithFormat:@"%@|%@|%@",
                               kHTTPUserAgent,
                               appName,
                               sdkVersion];
  return customUserAgent;
}

-(void)setPushSound:(BOOL)s {
  NSUserDefaults *userDefaults = [self getUserDefaults];
  [userDefaults setBool:s forKey:@"pushSound"];
  [userDefaults synchronize];
  
  [self pushDevice];
}

-(BOOL)pushSound {
  NSUserDefaults *userDefaults = [self getUserDefaults];
  BOOL sound = [userDefaults boolForKey:@"pushSound"];
  return sound;
}

- (BOOL)shouldShowPasswordForContentId:(NSString *)contentID password:(NSString *)password error:(NSError *)error completion:(void (^)(XMMContent *, NSError *, BOOL passwordRequired))completion {
  NSString *nextPasswordKey = [NSString stringWithFormat:@"next_%@", contentID];
  
  NSUserDefaults *userDefaults = [self getUserDefaults];
  int passwordEnters = [userDefaults integerForKey:contentID];
  
  NSDate *lastDate = [userDefaults objectForKey:nextPasswordKey];
  
  if (lastDate != nil) {
    NSDate *now = [[NSDate alloc] init];
    NSDate *earliestOpenDate = [lastDate dateByAddingTimeInterval:15 * 60];
    
    if ([earliestOpenDate compare:now] == NSOrderedDescending) {
      [self contentsWithTags:@[@"x-forbidden"] pageSize:10 cursor:nil sort:nil completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *e) {
        
        if (e) {
          completion(nil, e, NO);
          return;
        }
        
        if (contents.firstObject != nil) {
          completion(contents.firstObject, nil, NO);
          return;
        } else {
          completion(nil, error, NO);
          return;
        }
      }];
      
      return NO;
    }
  }
  
  if (passwordEnters < 3) {
    return YES;
  } else {
    
    NSDate *now = [[NSDate alloc] init];
    [userDefaults setObject:now forKey:nextPasswordKey];
    [userDefaults setInteger:0 forKey:contentID];
    [userDefaults synchronize];
    
    [self contentsWithTags:@[@"x-forbidden"] pageSize:10 cursor:nil sort:nil completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *e) {
      
      if (e) {
        completion(nil, e, NO);
        return;
      }
      
      if (contents.firstObject != nil) {
        completion(contents.firstObject, nil, NO);
        return;
      } else {
        completion(nil, error, NO);
        return;
      }
    }];
    
    return NO;
  }
}

- (BOOL)shouldShowPasswordForLocId:(NSString *)locationIdentifier password:(NSString *)password error:(NSError *)error completion:(void (^)(XMMContent *, NSError *, BOOL passwordRequired))completion{
  NSString *nextPasswordKey = [NSString stringWithFormat:@"next_%@", locationIdentifier];
  
  NSUserDefaults *userDefaults = [self getUserDefaults];
  int passwordEnters = [userDefaults integerForKey:locationIdentifier];
  
  NSDate *lastDate = [userDefaults objectForKey:nextPasswordKey];
  
  if (lastDate != nil) {
    NSDate *now = [[NSDate alloc] init];
    NSDate *earliestOpenDate = [lastDate dateByAddingTimeInterval:15 * 60];
    
    if ([earliestOpenDate compare:now] == NSOrderedDescending) {
      [self contentsWithTags:@[@"x-forbidden"] pageSize:10 cursor:nil sort:nil completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *e) {
        
        if (e) {
          completion(nil, e, NO);
          return;
        }
        
        if (contents.firstObject != nil) {
          completion(contents.firstObject, nil, NO);
          return;
        } else {
          completion(nil, error, NO);
          return;
        }
      }];
      return NO;
    }
  }
  
  if (passwordEnters < 3) {
    return YES;
  } else {
    
    NSDate *now = [[NSDate alloc] init];
    [userDefaults setObject:now forKey:nextPasswordKey];
    [userDefaults setInteger:0 forKey:locationIdentifier];
    [userDefaults synchronize];
    
    [self contentsWithTags:@[@"x-forbidden"] pageSize:10 cursor:nil sort:nil completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *e) {
      
      if (e) {
        completion(nil, e, NO);
        return;
      }
      
      if (contents.firstObject != nil) {
        completion(contents.firstObject, nil, NO);
        return;
      } else {
        completion(nil, error, NO);
        return;
      }
    }];
    return NO;
  }
}

@end
