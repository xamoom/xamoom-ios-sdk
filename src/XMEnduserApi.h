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
#import <RestKit/RestKit.h>
#import "XMResponseGetById.h"
#import "XMResponseGetByLocationIdentifier.h"
#import "XMResponseGetByLocation.h"
#import "XMResponseGetByLocationItem.h"
#import "XMResponseStyle.h"
#import "XMResponseMenuItem.h"
#import "XMResponseContent.h"
#import "XMResponseContentBlock.h"
#import "XMResponseContentBlockType0.h"
#import "XMResponseContentBlockType1.h"
#import "XMResponseContentBlockType2.h"
#import "XMResponseContentBlockType3.h"
#import "XMResponseContentBlockType4.h"
#import "XMResponseContentBlockType5.h"
#import "XMResponseContentBlockType6.h"
#import "XMResponseContentBlockType7.h"
#import "XMResponseContentBlockType8.h"
#import "XMResponseContentBlockType9.h"

@protocol XMEnderuserApiDelegate <NSObject>

- (void) finishedLoadData;

@end

@interface XMEnduserApi : NSObject

@property (nonatomic, strong) RKMappingResult *apiResult;
@property (nonatomic, assign) id<XMEnderuserApiDelegate> delegate;

- (id)init;

#pragma mark public methods

/**
 Description
 
 @param contentId - The id of the content from xamoom backend.
 @param includeStyle - True or False for returning the style from xamoom backend.
 @param includeMenu - True of False for returning the menu from xamoom backend.
 @param language - The requested language of the content from xamoom backend.
 @return void
 */
- (void) getContentById:(NSString*)contentId includeStyle:(NSString*)style includeMenu:(NSString*)Menu language:(NSString*)language;

/**
 Description
 
 @param contentId - The id of the content from xamoom backend.
 @param includeStyle - True or False for returning the style from xamoom backend.
 @param includeMenu - True of False for returning the menu from xamoom backend.
 @param language - The requested language of the content from xamoom backend.
 @return void
 */
- (void) getContentByLocationIdentifier:(NSString*)locationIdentifier includeStyle:(NSString*)style includeMenu:(NSString*)Menu language:(NSString*)language;

/**
 Description
 
 @param contentId - The id of the content from xamoom backend.
 @param includeStyle - True or False for returning the style from xamoom backend.
 @param includeMenu - True of False for returning the menu from xamoom backend.
 @param language - The requested language of the content from xamoom backend.
 @return void
 */
- (void) getContentByLocation:(NSString*)lat lon:(NSString*)lon language:(NSString*)language;

@end
