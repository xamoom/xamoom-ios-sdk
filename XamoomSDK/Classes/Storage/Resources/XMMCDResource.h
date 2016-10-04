//
//  XMMCDResource.h
//  XamoomSDK
//
//  Created by Raphael Seher on 03/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XMMCDResource <NSObject>

+ (NSString *)coreDataEntityName;

+ (instancetype)insertNewObjectFrom:(id)entity;

@end
