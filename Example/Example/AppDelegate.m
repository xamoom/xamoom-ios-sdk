//
//  AppDelegate.m
//  Example
//
//  Created by Raphael Seher on 14/01/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"
#import <XamoomSDK/XMMPushManager.h>

@interface AppDelegate () <XMMPushNotificationDelegate>

@property (strong, nonatomic) XMMEnduserApi *api;
@property (strong, nonatomic) XMMPushManager *pushManager;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.
  
  self.pushManager = [[XMMPushManager alloc] init];
  self.pushManager.delegate = self;

  [self setupApi];
  
  
  [XMMContentBlock1TableViewCell appearance].audioPlayerBackgroundColor = UIColor.blueColor;
  [XMMContentBlock1TableViewCell appearance].audioPlayerProgressBarBackgroundColor = UIColor.darkGrayColor;
  [XMMContentBlock1TableViewCell appearance].audioPlayerProgressBarColor = UIColor.lightGrayColor;
  [XMMContentBlock1TableViewCell appearance].audioPlayerTintColor = UIColor.whiteColor;
  
  [XMMContentBlock4TableViewCell appearance].facebookColor = UIColor.brownColor;
  [XMMContentBlock4TableViewCell appearance].facebookTintColor = UIColor.blueColor;
  [XMMContentBlock4TableViewCell appearance].fallbackColor = UIColor.greenColor;
  [XMMContentBlock4TableViewCell appearance].fallbackTintColor = UIColor.blueColor;
  [XMMContentBlock4TableViewCell appearance].webColor = UIColor.brownColor;
  [XMMContentBlock4TableViewCell appearance].webTintColor = UIColor.blueColor;
  [XMMContentBlock4TableViewCell appearance].mailColor = UIColor.brownColor;
  [XMMContentBlock4TableViewCell appearance].mailTintColor = UIColor.blueColor;
  [XMMContentBlock4TableViewCell appearance].wikipediaColor = UIColor.brownColor;
  [XMMContentBlock4TableViewCell appearance].wikipediaTintColor = UIColor.blueColor;
  [XMMContentBlock4TableViewCell appearance].itunesColor = UIColor.brownColor;
  [XMMContentBlock4TableViewCell appearance].itunesTintColor = UIColor.blueColor;
  [XMMContentBlock4TableViewCell appearance].appleColor = UIColor.brownColor;
  [XMMContentBlock4TableViewCell appearance].appleTintColor = UIColor.blueColor;
  [XMMContentBlock4TableViewCell appearance].twitterColor = UIColor.brownColor;
  [XMMContentBlock4TableViewCell appearance].twitterTintColor = UIColor.blueColor;
  [XMMContentBlock4TableViewCell appearance].shopColor = UIColor.brownColor;
  [XMMContentBlock4TableViewCell appearance].shopTintColor = UIColor.blueColor;
  [XMMContentBlock4TableViewCell appearance].linkedInColor = UIColor.brownColor;
  [XMMContentBlock4TableViewCell appearance].linkedInTintColor = UIColor.blueColor;
  [XMMContentBlock4TableViewCell appearance].flickrColor = UIColor.brownColor;
  [XMMContentBlock4TableViewCell appearance].flickrTintColor = UIColor.blueColor;
  [XMMContentBlock4TableViewCell appearance].soundcloudColor = UIColor.brownColor;
  [XMMContentBlock4TableViewCell appearance].soundcloudTintColor = UIColor.blueColor;
  [XMMContentBlock4TableViewCell appearance].youtubeColor = UIColor.brownColor;
  [XMMContentBlock4TableViewCell appearance].youtubeTintColor = UIColor.blueColor;
  [XMMContentBlock4TableViewCell appearance].googleColor = UIColor.brownColor;
  [XMMContentBlock4TableViewCell appearance].googleTintColor = UIColor.blueColor;
  [XMMContentBlock4TableViewCell appearance].spotifyColor = UIColor.brownColor;
  [XMMContentBlock4TableViewCell appearance].spotifyTintColor = UIColor.blueColor;
  [XMMContentBlock4TableViewCell appearance].navigationColor = UIColor.brownColor;
  [XMMContentBlock4TableViewCell appearance].navigationTintColor = UIColor.blueColor;
  [XMMContentBlock4TableViewCell appearance].androidColor = UIColor.brownColor;
  [XMMContentBlock4TableViewCell appearance].androidTintColor = UIColor.blueColor;
  [XMMContentBlock4TableViewCell appearance].windowsColor = UIColor.brownColor;
  [XMMContentBlock4TableViewCell appearance].windowsTintColor = UIColor.blueColor;
  [XMMContentBlock4TableViewCell appearance].instagramColor = UIColor.brownColor;
  [XMMContentBlock4TableViewCell appearance].instagramTintColor = UIColor.blueColor;
  [XMMContentBlock4TableViewCell appearance].phoneColor = UIColor.brownColor;
  [XMMContentBlock4TableViewCell appearance].phoneTintColor = UIColor.blueColor;
  
  [XMMContentBlock5TableViewCell appearance].ebookTintColor = UIColor.blueColor;
  [XMMContentBlock5TableViewCell appearance].ebookColor = UIColor.brownColor;

  
  UINavigationController *nav = (UINavigationController *) self.window.rootViewController;
  ViewController *vc = (ViewController *)nav.topViewController;
  vc.api = self.api;
  
  return YES;
}

- (void)setupApi {
  // Do any additional setup after loading the view, typically from a nib.
  NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"TestingIDs" ofType:@"plist"];
  NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
  NSString *apikey = [dict objectForKey:@"APIKEY"];
  NSString *devkey = [dict objectForKey:@"X-DEVKEY"];
  
  NSDictionary *httpHeaders = @{@"Content-Type":@"application/vnd.api+json",
                                @"User-Agent":@"XamoomSDK iOS | SDK Example | dev",
                                @"APIKEY":apikey,
                                @"X-DEVKEY":devkey};
  
  NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
  [config setHTTPAdditionalHeaders:httpHeaders];
  XMMRestClient *restClient = [[XMMRestClient alloc] initWithBaseUrl:[NSURL URLWithString:@"https://xamoom-cloud-dev.appspot.com/_api/v2/consumer/"] session:[NSURLSession sessionWithConfiguration:config]];
  
  self.api = [[XMMEnduserApi alloc] initWithRestClient:restClient];
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// system push notification registration success callback, delegate to pushManager
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  [self.pushManager handlePushRegistration:deviceToken];
}

// system push notification registration error callback, delegate to pushManager
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  [self.pushManager handlePushRegistrationFailure:error];
}

// system push notifications callback, delegate to pushManager
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  [self.pushManager handlePushReceived:userInfo];
  completionHandler(UIBackgroundFetchResultNoData);
}

- (void)didClickPushNotification:(NSString *)contentId {
  NSLog(@"Did click notification: %@", contentId);
  
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  DetailViewController *vc = (DetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
  vc.api = self.api;
  vc.contentID = contentId;
  UINavigationController *navigationController = (UINavigationController *) self.window.rootViewController;
  [navigationController showViewController:vc sender:nil];
}

@end
