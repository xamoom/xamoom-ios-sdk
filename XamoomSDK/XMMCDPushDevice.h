//
//  XMMCDPushDevice.h
//  XamoomSDK
//
//  Created by Thomas Krainz-Mischitz on 28.06.18.
//

#import <Foundation/Foundation.h>
#import "XMMOfflineStorageManager.h"
#import "XMMCDResource.h"

@interface XMMCDPushDevice  : NSManagedObject <XMMCDResource>

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *spotDescription;
@property (nonatomic, copy) NSString *image;
@property (nonatomic) NSNumber *category;
@property (nonatomic) NSMutableDictionary *locationDictionary;
@property (nonatomic) NSArray *tags;

@end
