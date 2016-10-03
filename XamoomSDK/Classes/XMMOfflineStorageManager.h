//
//  XMMOfflineStorageManager.h
//  XamoomSDK
//
//  Created by Raphael Seher on 29/09/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface XMMOfflineStorageManager : NSObject

@property NSManagedObjectContext *managedObjectContext;

- (NSManagedObject *)saveEntity:(id)entity;

@end
