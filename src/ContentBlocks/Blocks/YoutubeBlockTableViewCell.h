//
//  YoutubeBlockTableViewCell.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 09/04/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "YTPlayerView.h"

@interface YoutubeBlockTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet YTPlayerView *playerView;
@property (nonatomic, strong) MPMoviePlayerController *videoPlayer;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *playIconImageView;

- (void)initVideoWithUrl:(NSString*)videoUrl andWidth:(float)width;

@end
