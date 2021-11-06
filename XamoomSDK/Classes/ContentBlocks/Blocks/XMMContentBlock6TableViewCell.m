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
        
        //One more request if content property 'relatedSpot.name' is not set
        XMMSpot *currentRelatedSpot = content.relatedSpot;
        if (currentRelatedSpot != nil && currentRelatedSpot.ID != nil && currentRelatedSpot.name == nil) {
            [api spotWithID:currentRelatedSpot.ID completion:^(XMMSpot *spot, NSError *error) {
                content.relatedSpot = spot;
                [self finishContentLoading:content];
            }];
        } else {
            [self finishContentLoading:content];
        }
      }];
  } else {
      [self showBlockData:cachedContent];
  }
  
}

- (void)finishContentLoading:(XMMContent *)content {
    [self.loadingIndicator stopAnimating];
    [[XMMContentBlockListsCache sharedInstance] saveContent:content key:content.ID];
    [[XMMContentBlocksCache sharedInstance] saveContent:content key:content.ID];
    [self showBlockData:content];
}

- (void)showBlockData:(XMMContent *)content {
  self.content = content;
  
  //set title and excerpt
  self.contentTitleLabel.text = self.content.title;
  self.contentExcerptLabel.text = self.content.contentDescription;
  NSDate *contentFromDate = self.content.fromDate;
  NSString *contentLocationName = self.content.relatedSpot.name;
  //set time and location
  if (contentFromDate != nil || (self.content.relatedSpot != nil && contentLocationName != nil)) {
      //prepare description text to use in 1 line
      NSMutableAttributedString *descText = [[NSMutableAttributedString alloc] initWithString:self.content.contentDescription];
      
      //get label max char in line
      int descTextLength = (int)descText.length;
      
      int maxCharsInLabel = [self maxCharInLine] * 2;
      if (contentFromDate != nil && contentLocationName != nil) {
          maxCharsInLabel = [self maxCharInLine];
      }
      
      if (descTextLength < maxCharsInLabel) {
          maxCharsInLabel = descTextLength;
      }
      
      //substring description text to 1 or 2 lines based on maxCharSiseInLine
      descText = [descText attributedSubstringFromRange:NSMakeRange(0, maxCharsInLabel)];
      
      //configure contentExcerptLabel text
      NSMutableAttributedString *newLine= [[NSMutableAttributedString alloc] initWithString:@"\n"];
      NSMutableAttributedString *descriptionString= [[NSMutableAttributedString alloc] initWithAttributedString:descText];
      
      if (contentFromDate != nil) {
          //prepare event dateTime
          NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
          NSString *lan = [[NSUserDefaults standardUserDefaults] stringForKey:@"language"];
          NSLocale *locale = [NSLocale localeWithLocaleIdentifier:lan];
          [dateFormatter setLocale:locale];
          [dateFormatter setDateFormat:@"E, d MMM, HH:mm"];
          NSString *eventDateString = [dateFormatter stringFromDate:contentFromDate];
          NSString *eventDate = [NSString stringWithFormat:@"%@%@",@" ",eventDateString];
          NSMutableAttributedString *eventDateAtrString= [[NSMutableAttributedString alloc] initWithString:eventDate];
         
          //clock icon
          NSTextAttachment *clockAttachment = [[NSTextAttachment alloc] init];
          clockAttachment.image = [UIImage imageNamed:@"clock"];
          clockAttachment.bounds = CGRectMake(0, 0, clockAttachment.image.size.width * 0.75, clockAttachment.image.size.height * 0.75);
          NSAttributedString *clockAttachmentString = [NSAttributedString attributedStringWithAttachment:clockAttachment];
          
          [descriptionString appendAttributedString:newLine];
          [descriptionString appendAttributedString:clockAttachmentString];
          [descriptionString appendAttributedString:eventDateAtrString];
      }
      
      if (contentLocationName != nil) {
          //location icon
          NSTextAttachment *locationAttachment = [[NSTextAttachment alloc] init];
          locationAttachment.image = [UIImage imageNamed:@"location"];
          locationAttachment.bounds = CGRectMake(0, 0, locationAttachment.image.size.width * 0.75, locationAttachment.image.size.height * 0.75);
          NSAttributedString *locationAttachmentString = [NSAttributedString attributedStringWithAttachment:locationAttachment];
          
          //location text
          NSMutableAttributedString *locationString= [[NSMutableAttributedString alloc] initWithString:@" "];
          [locationString appendAttributedString: [[NSMutableAttributedString alloc] initWithString:contentLocationName]];
          
          
          [descriptionString appendAttributedString:newLine];
          [descriptionString appendAttributedString:locationAttachmentString];
          [descriptionString appendAttributedString:locationString];
      }
      
      self.contentExcerptLabel.attributedText = descriptionString;
  }
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

- (int)maxCharInLine {
    // calculate width for ten symbols
    CGSize expectedLabelSizeForTenChars = [@"Musikevent" sizeWithFont:self.contentExcerptLabel.font
                            constrainedToSize:CGSizeMake(10000, self.contentExcerptLabel.bounds.size.height)
                            lineBreakMode:self.contentExcerptLabel.lineBreakMode];
    float singleCharWidth = expectedLabelSizeForTenChars.width / 10;
    
    int maxCharInLine = (self.contentExcerptLabel.bounds.size.width / singleCharWidth) - 2;
    return maxCharInLine;
}

@end
