//
//  XMMPlaybackDelegate.h
//  XamoomSDK
//
//  Created by Raphael Seher on 19.01.18.
//  Copyright © 2018 xamoom GmbH. All rights reserved.
//

@protocol XMMPlaybackDelegate <NSObject>

- (void)playFileAt:(int)position;
- (void)pauseFileAt:(int)position;
- (void)stopFileAt:(int)position;
- (void)seekForwardFileAt:(int)position time:(long)seekTime;
- (void)seekBackwardFileAt:(int)position time:(long)seekTime;

@end
