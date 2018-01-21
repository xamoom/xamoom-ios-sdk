//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMMusicPlayer.h"

@interface XMMMusicPlayer ()

@end

@implementation XMMMusicPlayer

#pragma mark - Initialization

- (id)init {
  if (self = [super init]) {
    _audioPlayer = [[AVPlayer alloc] init];
    [self registerObservers];
  }
  return self;
}

- (id)initWith:(AVPlayer *)audioPlayer {
  if (self = [super init]) {
    _audioPlayer = audioPlayer;
    [self registerObservers];
  }
  return self;
}

- (void)registerObservers {
  [_audioPlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
  
  XMMMusicPlayer * __weak weakSelf = self;
  [_audioPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 60) queue:nil usingBlock:^(CMTime time) {
    [weakSelf.delegate updatePlaybackPosition:weakSelf.audioPlayer.currentTime];
  }];
}

void (^periodicTimeObserver)(CMTime) = ^void(CMTime time) {
};

- (void)prepareWith:(NSURL *)url {
  NSLog(@"XMMMusicPlayer - prepare ");
  AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
  NSArray *keys = [NSArray arrayWithObject:@"playable"];
  AVPlayerItem *item = [[AVPlayerItem alloc] initWithAsset:asset automaticallyLoadedAssetKeys:keys];
  [_audioPlayer replaceCurrentItemWithPlayerItem:item];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
  if (object == _audioPlayer && [keyPath isEqualToString:@"status"]) {
    if (_audioPlayer.status == AVPlayerStatusFailed) {
      NSLog(@"XMMMusicPlayer - AVPlayer Failed");
    } else if (_audioPlayer.status == AVPlayerStatusReadyToPlay) {
      NSLog(@"XMMMusicPlayer - AVPlayerStatusReadyToPlay");
      [_delegate didLoadAsset:_audioPlayer.currentItem.asset];
    } else if (_audioPlayer.status == AVPlayerItemStatusUnknown) {
      NSLog(@"XMMMusicPlayer - AVPlayer Unknown");
    }
  }
}

#pragma mark - Audioplayer Controls

- (void)play {
  [self.audioPlayer play];
}

- (void)pause {
  [self.audioPlayer pause];
}

- (void)forward:(long)time {
  CMTime newTime = CMTimeAdd(self.audioPlayer.currentTime, CMTimeMake(30, self.audioPlayer.currentTime.timescale));
  [self.audioPlayer seekToTime:newTime];
}

- (void)backward:(long)time {
  CMTime newTime = CMTimeSubtract(self.audioPlayer.currentTime, CMTimeMake(30, self.audioPlayer.currentTime.timescale));
  [self.audioPlayer seekToTime:newTime];
}

@end
