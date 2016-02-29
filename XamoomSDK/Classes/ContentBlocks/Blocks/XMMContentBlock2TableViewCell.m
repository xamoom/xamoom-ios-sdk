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

#import "XMMContentBlock2TableViewCell.h"

@interface XMMContentBlock2TableViewCell()

@property (strong, nonatomic) NSString* videoUrl;
@property (nonatomic) float screenWidth;
@property (nonatomic) UIImage *playImage;

@end

@implementation XMMContentBlock2TableViewCell

- (void)awakeFromNib {
  // Initialization code
  self.videoPlayer = nil;
  self.playImage = [UIImage imageNamed:@"videoPlay"];
}

- (void)prepareForReuse {
  self.videoPlayer = nil;
  self.titleLabel.text = nil;
}

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style {
  self.titleLabel.textColor = [UIColor colorWithHexString:style.foregroundFontColor];
  self.titleLabel.text = block.title;
  
  self.playIconImageView.image = self.playImage;
  [self determineVideoFromURLString:block.videoUrl];
}

- (void)determineVideoFromURLString:(NSString*)videoURLString {
  NSString *youtubeVideoID = [self youtubeVideoIdFromURL:videoURLString];
  
  if (youtubeVideoID != nil) {
    [self showYoutube];
    [self.youtubePlayerView loadWithVideoId:youtubeVideoID];
  } else if ([videoURLString containsString:@"vimeo"]) {
    [self hideYoutube];
    [self vimeoFromURLString:videoURLString];
  } else {
    [self hideYoutube];
    [self videoPlayerWithURL:[NSURL URLWithString:videoURLString]];
    [self thumbnailFromUrl:[NSURL URLWithString:videoURLString] completion:^(UIImage *image) {
      self.thumbnailImageView.image = image;
    }];
  }
}

- (NSString*)youtubeVideoIdFromURL:(NSString*)videoUrl {
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

- (void)vimeoFromURLString:(NSString *)URLString {
  [[YTVimeoExtractor sharedExtractor]fetchVideoWithVimeoURL:URLString withReferer:@"https://www.xamoom.com" completionHandler:^(YTVimeoVideo * _Nullable video, NSError * _Nullable error) {
    if (video) {
      NSString *highQualityURLString = [[video streamURLs] objectForKey:@(YTVimeoVideoQualityHD720)];
      self.videoPlayer = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:highQualityURLString]];
      [self.thumbnailImageView sd_setImageWithURL:[[video thumbnailURLs] objectForKey:@(YTVimeoVideoThumbnailQualityMedium)]];
    }
  }];
}

- (void)videoPlayerWithURL:(NSURL *)videoUrl {
  self.videoPlayer = [[AVPlayer alloc] initWithURL:videoUrl];
}

- (void)thumbnailFromUrl:(NSURL *)videoUrl completion:(void (^)(UIImage* image))completion {
  dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:[AVAsset assetWithURL:videoUrl]];
    CMTime time = CMTimeMake(1, 1);
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    dispatch_async( dispatch_get_main_queue(), ^{
      completion(thumbnail);
    });
  });
}

- (void)openVideo {
  if (self.videoPlayer) {
    AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
    playerViewController.player = self.videoPlayer;
    
    [self.window.rootViewController presentViewController:playerViewController animated:YES completion:^{
      [playerViewController.player play];
    }];
  }
}

- (void)hideYoutube {
  self.youtubePlayerView.hidden = YES;
  self.playIconImageView.hidden = NO;
  self.thumbnailImageView.hidden = NO;
}

- (void)showYoutube {
  self.youtubePlayerView.hidden = NO;
  self.playIconImageView.hidden = YES;
  self.thumbnailImageView.hidden = YES;
}

@end
