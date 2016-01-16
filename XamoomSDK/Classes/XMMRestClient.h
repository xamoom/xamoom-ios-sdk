//
//  XMMRestClient.h
//  XamoomSDK
//
//  Created by Raphael Seher on 15/01/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMMQuery.h"

@interface XMMRestClient : NSObject

@property (strong, nonatomic) XMMQuery *query;

- (instancetype)initWithBaseUrl:(NSString *)baseUrl;

- (void)fetchResource;

@end
