//
//  XMMAudioManager.h
//  XamoomSDK
//
//  Created by Raphael Seher on 18.01.18.
//  Copyright © 2018 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMMMusicPlayer.h"
#import "XMMMediaFile.h"

@interface XMMAudioManager : NSObject <XMMPlaybackDelegate>

@property (nonatomic, strong) XMMMusicPlayer *musicPlayer;
@property (nonatomic, strong) NSNumber *seekTimeForControlCenter;

+ (id)sharedInstance;

- (XMMMediaFile *)createMediaFileForPosition:(int)position url:(NSURL *)url title:(NSString *)title artist:(NSString *)artist;

- (XMMMediaFile *)mediaFileForPosition:(int)position;

- (void)resetMediaFiles;

@end
