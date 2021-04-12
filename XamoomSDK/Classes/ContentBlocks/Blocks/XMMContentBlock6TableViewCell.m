//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMContentBlock6TableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface XMMContentBlock6TableViewCell()

@property (nonatomic) BOOL offline;
@property (nonatomic, weak) NSURLSessionDataTask *dataTask;

@end

@implementation XMMContentBlock6TableViewCell

static NSString *language;

- (void)awakeFromNib {
  // Initialization code
  [[XMMContentBlockListsCache sharedInstance] removeCache];
  self.fileManager = [[XMMOfflineFileManager alloc] init];
  self.contentID = nil;
  self.contentImageView.image = nil;
  self.contentTitleLabel.text = nil;
  self.contentExcerptLabel.text = nil;
  
  [super awakeFromNib];
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.contentID = nil;
  self.contentImageView.image = nil;
  self.contentTitleLabel.text = nil;
  self.contentExcerptLabel.text = nil;
  
  if (self.dataTask != nil && self.dataTask.state == NSURLSessionTaskStateRunning) {
    [self.dataTask cancel];
  }
  [self.loadingIndicator stopAnimating];
}

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style api:(XMMEnduserApi *)api offline:(BOOL)offline {
  self.offline = offline;
  if (style.foregroundFontColor != nil) {
    self.contentTitleLabel.textColor = [UIColor colorWithHexString:style.foregroundFontColor];
    self.contentExcerptLabel.textColor = [UIColor colorWithHexString:style.foregroundFontColor];
  }
  
  //set content
  self.contentID = block.contentID;
  
  //init contentBlock
  [self downloadContentBlock:api];
}

- (void)downloadContentBlock:(XMMEnduserApi *)api {
  XMMContent *cachedContent = [[XMMContentBlockListsCache sharedInstance] cachedContent:self.contentID];
    
  if(cachedContent == nil) {
      [self.loadingIndicator startAnimating];
      self.dataTask = [api contentWithID:self.contentID
                                 options:XMMContentOptionsPreview
                                  reason:XMMContentReasonLinkedContent
                                password:nil
                              completion:^(XMMContent *content, NSError *error, BOOL passwordRequired) {
        if (error) {
          return;
        }
        
        [self.loadingIndicator stopAnimating];
        
        [[XMMContentBlockListsCache sharedInstance] saveContent:content key:content.ID];
        [[XMMContentBlocksCache sharedInstance] saveContent:content key:content.ID];
        [self showBlockData:content];
      }];
  } else {
      [self showBlockData:cachedContent];
  }
  
}

- (void)showBlockData:(XMMContent *)content {
  self.content = content;
  
  //set title and excerpt
  self.contentTitleLabel.text = self.content.title;
  self.contentExcerptLabel.text = self.content.contentDescription;
  [self.contentExcerptLabel sizeToFit];
  
  if (self.content.imagePublicUrl == nil) {
    [self setNoImageConstraints];
  } else {
    self.contentImageWidthConstraint.constant = 80;
    self.contentTitleLeadingConstraint.constant = 8;
    if (self.offline) {
      NSURL *offlineURL = [self.fileManager urlForSavedData:self.content.imagePublicUrl];
      [self.contentImageView sd_setImageWithURL:offlineURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
          [self setNoImageConstraints];
        }
      }]; 
    } else {
      [self.contentImageView sd_setImageWithURL: [NSURL URLWithString: self.content.imagePublicUrl]];
    }
  }
}

- (void)setNoImageConstraints {
  self.contentImageWidthConstraint.constant = 0;
  self.contentTitleLeadingConstraint.constant = 0;
}

@end
