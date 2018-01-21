//
//  XMMAudioManager.m
//  XamoomSDK
//
//  Created by Raphael Seher on 18.01.18.
//  Copyright © 2018 xamoom GmbH. All rights reserved.
//

#import "XMMAudioManager.h"

@interface XMMAudioManager() <XMMPlaybackDelegate>

@property (nonatomic, strong) NSMutableDictionary *mediaFiles;
@property (nonatomic, strong) XMMMediaFile *currentMediaFile;

@end

@implementation XMMAudioManager

+ (id)sharedInstance {
  static XMMAudioManager *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });
  
  return sharedInstance;
}

- (id)init {
  if (self = [super init]) {
    _musicPlayer = [[XMMMusicPlayer alloc] init];
    _mediaFiles = [[NSMutableDictionary alloc] init];
  }
  return self;
}

- (XMMMediaFile *)createMediaFileForPosition:(int)position url:(NSURL *)url title:(NSString *)title artist:(NSString *)artist {
  XMMMediaFile *mediaFile = [self mediaFileForPosition:position];
  
  if (mediaFile == nil ||
      ![mediaFile.url.absoluteString isEqualToString:url.absoluteString]) {
    mediaFile = [[XMMMediaFile alloc] initWithPlaybackDelegate:self position:position url:url title:title artist:artist album:nil];
  }
  
  [_mediaFiles setValue:mediaFile forKey:[@(position) stringValue]];
  
  return mediaFile;
}

- (XMMMediaFile *)mediaFileForPosition:(int)position {
  return [_mediaFiles objectForKey:[@(position) stringValue]];
}

- (void)playFileAt:(int)position {
  XMMMediaFile *mediaFile = [_mediaFiles objectForKey:[@(position) stringValue]];
  if (_currentMediaFile != nil) {
    [self pauseFileAt:_currentMediaFile.position];
  }
  
  _currentMediaFile = mediaFile;
  [_musicPlayer prepareWith:_currentMediaFile.url];
}

- (void)pauseFileAt:(int)position {
  if (_currentMediaFile == nil) {
    return;
  }
  
  [_musicPlayer pause];
}

- (void)stopFileAt:(int)position {
  
}

- (void)seekForwardFileAt:(int)position time:(long)seekTime {
  
}

- (void)seekBackwardFileAt:(int)position time:(long)seekTime {
  
}

@end
