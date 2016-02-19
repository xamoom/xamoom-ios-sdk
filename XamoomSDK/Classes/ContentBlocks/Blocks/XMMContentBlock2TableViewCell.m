//
// Copyright 2015 by xamoom GmbH <apps@xamoom.com>
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

#import "XMMContentBlock2TableViewCell.h"

@interface XMMContentBlock2TableViewCell()

@property (strong, nonatomic) NSString* videoUrl;
@property (nonatomic) float screenWidth;
@property (nonatomic) UITapGestureRecognizer *tappedVideoViewRecognize;

@end

@implementation XMMContentBlock2TableViewCell

- (void)awakeFromNib {
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style {
  self.titleLabel.textColor = [UIColor colorWithHexString:style.foregroundFontColor];
  
  if(block.title != nil && ![block.title isEqualToString:@""])
    self.titleLabel.text = block.title;
  
  [self initVideoWithUrl:block.videoUrl];
}

- (void)initVideoWithUrl:(NSString*)videoUrl {
  self.videoPlayer = nil;
  self.tappedVideoViewRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedVideoView:)];
  [self.thumbnailImageView addGestureRecognizer:self.tappedVideoViewRecognize];

  NSString* youtubeVideoId = [self youtubeVideoIdFromUrl:videoUrl];

  if (youtubeVideoId != nil) {
    //load video inside playerView
    self.youtubePlayerView.hidden = NO;
    self.playIconImageView.hidden = YES;
    self.thumbnailImageView.hidden = YES;
    [self.youtubePlayerView loadWithVideoId:youtubeVideoId];
  } else {
    self.youtubePlayerView.hidden = YES;
    self.playIconImageView.hidden = NO;
    self.thumbnailImageView.hidden = NO;
    self.videoUrl = videoUrl;

    [self initVideoPlayerWithUrl:[NSURL URLWithString:videoUrl]];
  }
}

/**
 *  Returns the videoId from a youtubeUrl.
 *
 *  @param videoUrl youtube url.
 *
 *  @return String videoId
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

- (void)initVideoPlayerWithUrl:(NSURL *)videoUrl {
  self.videoPlayer = [[AVPlayer alloc] initWithURL:videoUrl];

}

- (void)tappedVideoView:(UITapGestureRecognizer*)sender {
  AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
  playerViewController.player = self.videoPlayer;
  
  [self.window.rootViewController presentViewController:playerViewController animated:YES completion:^{
    //
  }];
}

@end
