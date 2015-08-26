//
//  YoutubeBlockTableViewCell.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 09/04/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "YoutubeBlockTableViewCell.h"

@interface YoutubeBlockTableViewCell()

@property NSString* videoUrl;
@property float screenWidth;

@end

@implementation YoutubeBlockTableViewCell

- (void)awakeFromNib {
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

- (void)initVideoWithUrl:(NSString*)videoUrl andWidth:(float)width {
  self.playIconImageView.hidden = YES;
  NSString* youtubeVideoId = [self youtubeVideoIdFromUrl:videoUrl];
  
  if (youtubeVideoId != nil) {
    
    //load video inside playerView
    [self.playerView loadWithVideoId:youtubeVideoId];
  } else {
    self.playIconImageView.hidden = NO;
    
    self.videoUrl = videoUrl;
    self.screenWidth = width;
    
    [self initVideoPlayer];
  }
}


/**
 *  <#Description#>
 *
 *  @param videoUrl <#videoUrl description#>
 *
 *  @return <#return value description#>
 */
- (NSString*)youtubeVideoIdFromUrl:(NSString*)videoUrl {
  //get the youtube videoId from the string
  NSString *regexString = @"((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)";
  NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                          options:NSRegularExpressionCaseInsensitive
                                                                            error:nil];
  NSArray *array = [regExp matchesInString:videoUrl options:0 range:NSMakeRange(0,videoUrl.length)];
  
  if(array.count == 1) {
    NSTextCheckingResult *result = array.firstObject;
    return [videoUrl substringWithRange:result.range];;
  } else {
    return nil;
  }
}

/**
 *  <#Description#>
 */
- (void)initVideoPlayer {
  UITapGestureRecognizer *tappedVideoView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedVideoView:)];
  [self.playerView addGestureRecognizer:tappedVideoView];
  
  self.videoPlayer = [[MPMoviePlayerController alloc] initWithContentURL: [NSURL URLWithString:self.videoUrl]];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(didReceiveImage:)
                                               name:MPMoviePlayerThumbnailImageRequestDidFinishNotification
                                             object:self.videoPlayer];
  
  NSArray *timeArray = [[NSArray alloc] initWithObjects:[NSNumber numberWithDouble:0.0], nil];
  [self.videoPlayer requestThumbnailImagesAtTimes:timeArray timeOption:MPMovieTimeOptionNearestKeyFrame];
}

/**
 *  <#Description#>
 *
 *  @param sender <#sender description#>
 */
- (void)tappedVideoView:(UITapGestureRecognizer*)sender {
  self.videoPlayer.shouldAutoplay = YES;
  [self.videoPlayer prepareToPlay];
  [self.videoPlayer.view setFrame: CGRectMake(0, 0, self.screenWidth, 201)];
  [self.playerView addSubview: self.videoPlayer.view];
  [self.videoPlayer setFullscreen:YES animated:YES];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(handleMoviePlayerFinish:)
                                               name:MPMoviePlayerWillExitFullscreenNotification
                                             object:nil];
}

/**
 *  <#Description#>
 *
 *  @param aNotification <#aNotification description#>
 */
- (void)handleMoviePlayerFinish:(NSNotification*)notification{
  NSDictionary *notificationUserInfo = [notification userInfo];
  NSNumber *resultValue = [notificationUserInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
  MPMovieFinishReason reason = [resultValue intValue];
  if (reason == MPMovieFinishReasonPlaybackError)
  {
    NSError *mediaPlayerError = [notificationUserInfo objectForKey:@"error"];
    if (mediaPlayerError)
    {
      NSLog(@"playback failed with error description: %@", [mediaPlayerError localizedDescription]);
    }
    else
    {
      NSLog(@"playback failed without any given reason");
    }
  }
  
  [self.videoPlayer.view removeFromSuperview];
  [[NSNotificationCenter defaultCenter] removeObserver:MPMoviePlayerPlaybackDidFinishNotification];
}

/**
 *  Description
 *
 *  @param notification <#notification description#>
 */
- (void)didReceiveImage:(NSNotification*)notification {
  NSDictionary *userInfo = [notification userInfo];
  UIImage *image = [userInfo valueForKey:MPMoviePlayerThumbnailImageKey];
  
  UIImageView *thumbnailImageView = [[UIImageView alloc]initWithImage: image];
  [thumbnailImageView setFrame: CGRectMake(0, 0, self.screenWidth, 201)];
  
  [self.playerView addSubview: thumbnailImageView];
}

@end
