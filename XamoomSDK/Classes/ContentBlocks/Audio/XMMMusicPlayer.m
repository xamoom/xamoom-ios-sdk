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
    [_audioPlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
  }
  return self;
}

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
      [_audioPlayer play];
    } else if (_audioPlayer.status == AVPlayerItemStatusUnknown) {
      NSLog(@"XMMMusicPlayer - AVPlayer Unknown");
    }
  }
}

/*
- (void)initAudioPlayerWithUrlString:(NSString*)mediaUrlString {

  //init avplayer with URL
  NSURL *mediaURL = [NSURL URLWithString:mediaUrlString];
  
  AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:mediaURL options:nil];
  NSArray *keys = [NSArray arrayWithObject:@"playable"];
  
  [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^() {
    self.audioPlayer = [[AVPlayer alloc] initWithPlayerItem:[[AVPlayerItem alloc] initWithAsset:asset automaticallyLoadedAssetKeys:keys]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.delegate didLoadAsset:asset];
    });
    
    //addPeriodicTimeObserver for remainingTime and progressBar
    __block XMMMusicPlayer *weakSelf = self;
    [self.audioPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 60) queue:NULL usingBlock:^(CMTime time) {
      if (!time.value) {
        return;
      } else {
        CGFloat songDuration = CMTimeGetSeconds([weakSelf.audioPlayer.currentItem duration]);
        CGFloat currentSongTime = CMTimeGetSeconds([weakSelf.audioPlayer currentTime]);
        CGFloat remainingSongTime = songDuration - currentSongTime;
        
        if (remainingSongTime <= 0) {
          if ([weakSelf.delegate respondsToSelector:@selector(finishedPlayback)]) {
            [weakSelf.delegate finishedPlayback];
            [weakSelf reset];
            
            if ([weakSelf.delegate respondsToSelector:@selector(didUpdateRemainingSongTime:)]) {
              NSString *timeString = [NSString stringWithFormat:@"%d:%02d", (int)songDuration / 60, (int)songDuration %60];
              [weakSelf.delegate performSelector:@selector(didUpdateRemainingSongTime:)
                                      withObject:timeString];
            }
            
            return;
          }
        }
        
        if (!isnan(songDuration)) {
          weakSelf.lineProgress = currentSongTime / songDuration;
          weakSelf.remainingSongTime = [NSString stringWithFormat:@"%d:%02d", (int)remainingSongTime / 60, (int)remainingSongTime %60];
          
          //notify delegate with remainingSongTime
          if ([weakSelf.delegate respondsToSelector:@selector(didUpdateRemainingSongTime:)]) {
            [weakSelf.delegate performSelector:@selector(didUpdateRemainingSongTime:) withObject:weakSelf.remainingSongTime];
          }
        }
      }
    }];
  }];
}
*/

- (void)reset {
  [self.audioPlayer seekToTime:kCMTimeZero];
}

#pragma mark - Audioplayer Controls

- (void)play {
  [self.audioPlayer play];
}

- (void)pause {
  [self.audioPlayer pause];
}

- (void)forward {
  CMTime newTime = CMTimeMakeWithSeconds(CMTimeGetSeconds(self.audioPlayer.currentTime) + 30,
                        self.audioPlayer.currentTime.timescale);
  
  if (CMTimeCompare(newTime, self.audioPlayer.currentItem.duration) >= 0) {
    [self.delegate finishedPlayback];
    [self.audioPlayer seekToTime:newTime];
    [self.audioPlayer pause];
  } else {
    [self.audioPlayer seekToTime:newTime];
  }
}

- (void)backward {
  CMTime newTime = CMTimeMakeWithSeconds(CMTimeGetSeconds(self.audioPlayer.currentTime) - 30,
                                         self.audioPlayer.currentTime.timescale);
  [self.audioPlayer seekToTime:newTime];
}

@end
