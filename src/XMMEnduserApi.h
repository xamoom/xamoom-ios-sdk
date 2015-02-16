/**
 *
 *  Copyright 2015 by Raphael Seher <raphael@xamoom.com>
 *
 * This file is part of some open source application.
 *
 * Some open source application is free software: you can redistribute
 * it and/or modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation, either
 * version 2 of the License, or (at your option) any later version.
 *
 * Some open source application is distributed in the hope that it will
 * be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
 * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with xamoom-ios-sdk. If not, see <http://www.gnu.org/licenses/>.
 *
 */

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <RestKit/RestKit.h>
#import "XMMResponseGetById.h"
#import "XMMResponseGetByLocationIdentifier.h"
#import "XMMResponseGetByLocation.h"
#import "XMMResponseGetByLocationItem.h"
#import "XMMResponseStyle.h"
#import "XMMResponseMenuItem.h"
#import "XMMResponseContent.h"
#import "XMMResponseContentBlock.h"
#import "XMMResponseContentBlockType0.h"
#import "XMMResponseContentBlockType1.h"
#import "XMMResponseContentBlockType2.h"
#import "XMMResponseContentBlockType3.h"
#import "XMMResponseContentBlockType4.h"
#import "XMMResponseContentBlockType5.h"
#import "XMMResponseContentBlockType6.h"
#import "XMMResponseContentBlockType7.h"
#import "XMMResponseContentBlockType8.h"
#import "XMMResponseContentBlockType9.h"

//Core Data
#import "XMMCoreData.h"
#import "XMMCoreDataGetById.h"
#import "XMMCoreDataStyle.h"
#import "XMMCoreDataMenuItem.h"
#import "XMMCoreDataContent.h"
#import "XMMCoreDataContentBlocks.h"
#import "XMMCoreDataContentBlockType0.h"
#import "XMMCoreDataContentBlockType1.h"
#import "XMMCoreDataContentBlockType2.h"
#import "XMMCoreDataContentBlockType3.h"

@protocol XMEnderuserApiDelegate <NSObject>

- (void)finishedLoadData;

@end

@interface XMMEnduserApi : NSObject

@property (nonatomic, strong) RKMappingResult *apiResult;
@property (nonatomic, assign) id<XMEnderuserApiDelegate> delegate;

-(id)init;

#pragma mark public methods

/**
 Description
 
 @param contentId - The id of the content from xamoom backend.
 @param includeStyle - True or False for returning the style from xamoom backend.
 @param includeMenu - True of False for returning the menu from xamoom backend.
 @param language - The requested language of the content from xamoom backend.
 @return void
 */
- (void)getContentById:(NSString*)contentId includeStyle:(NSString*)style includeMenu:(NSString*)Menu language:(NSString*)language;

/**
 Description
 
 @param contentId - The id of the content from xamoom backend.
 @param includeStyle - True or False for returning the style from xamoom backend.
 @param includeMenu - True of False for returning the menu from xamoom backend.
 @param language - The requested language of the content from xamoom backend.
 @return void
 */
- (void)getContentByLocationIdentifier:(NSString*)locationIdentifier includeStyle:(NSString*)style includeMenu:(NSString*)Menu language:(NSString*)language;

/**
 Description
 
 @param contentId - The id of the content from xamoom backend.
 @param includeStyle - True or False for returning the style from xamoom backend.
 @param includeMenu - True of False for returning the menu from xamoom backend.
 @param language - The requested language of the content from xamoom backend.
 @return void
 */
- (void)getContentByLocation:(NSString*)lat lon:(NSString*)lon language:(NSString*)language;

/**
 Description
 
 @param contentId - The id of the content from xamoom backend.
 @param includeStyle - True or False for returning the style from xamoom backend.
 @param includeMenu - True of False for returning the menu from xamoom backend.
 @param language - The requested language of the content from xamoom backend.
 @return void
 */
- (void)initRestkitCoreData;

/**
 Description
 
 @param contentId - The id of the content from xamoom backend.
 @param includeStyle - True or False for returning the style from xamoom backend.
 @param includeMenu - True of False for returning the menu from xamoom backend.
 @param language - The requested language of the content from xamoom backend.
 @return void
 */
- (void)requestData;

@end
