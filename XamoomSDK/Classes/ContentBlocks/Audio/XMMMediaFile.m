//
//  MediaFile.m
//  XamoomSDK
//
//  Created by Raphael Seher on 18.01.18.
//  Copyright © 2018 xamoom GmbH. All rights reserved.
//

#import "XMMMediaFile.h"

@implementation XMMMediaFile

- (id)initWithPlaybackDelegate:(id<XMMPlaybackDelegate>)playbackDelegate position:(int)position url:(NSURL *)url title:(NSString *)title artist:(NSString *)artist album:(NSString *)album {
  if (self = [super init]) {
    _playbackDelegate = playbackDelegate;
    _position = position;
    _url = url;
    _title = title;
    _artist = artist;
    _album = album;
  }
  return self;
}

- (void)start {
  [_playbackDelegate playFileAt:_position];
}

- (void)pause {
  [_playbackDelegate pauseFileAt:_position];
}

- (void)stop {
  [_playbackDelegate stopFileAt:_position];
}

- (void)seekForward:(long)seekTime {
  [_playbackDelegate seekForwardFileAt:_position time:seekTime];
}

- (void)seekBackward:(long)seekTime {
  [_playbackDelegate seekBackwardFileAt:_position time:seekTime];
}

- (void)didStart {
  [_delegate didStart];
}

- (void)didPause {
  [_delegate didPause];
}

- (void)didStop {
  [_delegate didStop];
}

- (void)didUpdatePlaybackPosition:(long)playbackPosition {
  _playbackPosition = playbackPosition;
  [_delegate didUpdatePlaybackPosition:playbackPosition];
}

@end
