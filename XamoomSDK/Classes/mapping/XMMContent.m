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

#import "XMMContent.h"
#import "XMMCDContent.h"

@implementation XMMContent

+ (NSString *)resourceName {
  return @"contents";
}

static JSONAPIResourceDescriptor *__descriptor = nil;

+ (JSONAPIResourceDescriptor *)descriptor {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    __descriptor = [[JSONAPIResourceDescriptor alloc] initWithClass:[self class] forLinkedType:@"contents"];
    
    [__descriptor setIdProperty:@"ID"];
    [__descriptor addProperty:@"title" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"display-name"]];
    [__descriptor addProperty:@"contentDescription" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"description"]];
    [__descriptor addProperty:@"imagePublicUrl" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"cover-image-url"]];
    [__descriptor addProperty:@"language"];
    [__descriptor addProperty:@"category"];
    [__descriptor addProperty:@"tags"];
    [__descriptor hasOne:[XMMSystem class] withName:@"system"];
    [__descriptor hasOne:[XMMSpot class] withName:@"spot"];
    [__descriptor hasMany:[XMMContentBlock class] withName:@"contentBlocks" withJsonName:@"blocks"];
  });
  
  return __descriptor;
}

- (instancetype)initWithCoreDataObject:(id<XMMCDResource>)object {
  self = [self init];
  if (self && object != nil) {
    XMMCDContent *savedContent = (XMMCDContent *)object;
    self.ID = savedContent.jsonID;
    self.title = savedContent.title;
    self.imagePublicUrl = savedContent.imagePublicUrl;
    self.contentDescription = savedContent.contentDescription;
    self.language = savedContent.language;
    self.category = [savedContent.category intValue];
    self.tags = savedContent.tags;
    
    if (savedContent.contentBlocks != nil) {
      NSMutableArray *blocks = [[NSMutableArray alloc] init];
      for (XMMCDContentBlock *block in savedContent.contentBlocks) {
        [blocks addObject:[[XMMContentBlock alloc] initWithCoreDataObject:block]];
      }
      self.contentBlocks = blocks;
    }
    
    if (savedContent.spot != nil) {
      self.spot = [[XMMSpot alloc] initWithCoreDataObject:savedContent.spot];
    }
    if (savedContent.system != nil) {
      self.system = [[XMMSystem alloc] initWithCoreDataObject:savedContent.system];
    }
    
  }
  return self;
}

@end
