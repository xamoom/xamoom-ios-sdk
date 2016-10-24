//
// Copyright 2016 by xamoom GmbH <apps@xamoom.com>
//
// This file is part of some open source application.
//
// Some open source application is free software: you can redistribute
// it and/or modify it under the terms of the GNU General Public
// License as published by the Free Software Foundation, either
// version 2 of the License, or (at your option) any later version.
//
// Some open source application is distributed in the hope that it will
// be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
// of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with xamoom-ios-sdk. If not, see <http://www.gnu.org/licenses/>.
//

#import "XMMMenuItem.h"
#import "XMMCDMenuItem.h"

@implementation XMMMenuItem

+ (NSString *)resourceName {
  return @"content";
}

static JSONAPIResourceDescriptor *__descriptor = nil;

+ (JSONAPIResourceDescriptor *)descriptor {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    __descriptor = [[JSONAPIResourceDescriptor alloc] initWithClass:[self class] forLinkedType:@"content"];
    
    [__descriptor setIdProperty:@"ID"];
    
    [__descriptor addProperty:@"contentTitle" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"display-name"]];
    [__descriptor addProperty:@"category"];
  });
  
  return __descriptor;
}

- (instancetype)initWithCoreDataObject:(id<XMMCDResource>)object {
  self = [self init];
  if (self && object != nil) {
    XMMCDMenuItem *savedMenu = (XMMCDMenuItem *)object;
    self.ID = savedMenu.jsonID;
    self.contentTitle = savedMenu.contentTitle;
    self.category = [savedMenu.category intValue];
  }
  
  return self;
}

- (id<XMMCDResource>)saveOffline {
  return [XMMCDMenuItem insertNewObjectFrom:self];
}

- (void)deleteOfflineCopy {
  [[XMMOfflineStorageManager sharedInstance] deleteEntity:[XMMCDMenuItem coreDataEntityName] ID:self.ID];
}

@end
