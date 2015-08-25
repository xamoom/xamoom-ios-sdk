//
//  YoutubeBlockTableViewCell.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 09/04/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "YoutubeBlockTableViewCell.h"

@implementation YoutubeBlockTableViewCell

- (void)awakeFromNib {
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)initVideoWithUrl:(NSString*)videoUrl andWidth:(float)width {
  NSString* youtubeVideoId = [self youtubeVideoIdFromUrl:videoUrl];
  if (youtubeVideoId != nil) {
    
    //load video inside playerView
    [self.playerView loadWithVideoId:youtubeVideoId];
  } else {
    NSLog(@"HTML Video found!");
    
    //testing
    self.videoPlayer = [[MPMoviePlayerController alloc] initWithContentURL: [NSURL URLWithString:videoUrl]];
    self.videoPlayer.shouldAutoplay = NO;
    [self.videoPlayer prepareToPlay];
    [self.videoPlayer.view setFrame: CGRectMake(0, 0, width, 201)];
    [self.playerView addSubview: self.videoPlayer.view];
  }
}

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

@end
