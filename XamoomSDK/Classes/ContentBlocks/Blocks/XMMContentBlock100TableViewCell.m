//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMContentBlock100TableViewCell.h"

@interface XMMContentBlock100TableViewCell()
@property (nonatomic) NSString *locationTitle;
@end

@implementation XMMContentBlock100TableViewCell

static int contentFontSize;
static UIColor *contentLinkColor;

- (void)awakeFromNib {
  // Initialization code
  self.titleLabel.text = @"";
  self.contentTextView.text = @"";
  [super awakeFromNib];
}

+ (int)fontSize {
  return contentFontSize;
}

+ (void)setFontSize:(int)fontSize {
  contentFontSize = fontSize;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.titleLabel.text = @"";
  self.contentTextView.text = @"";
}

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style offline:(BOOL)offline {

  if (style.foregroundFontColor != nil) {
    self.titleLabel.textColor = [UIColor colorWithHexString:style.foregroundFontColor];
  }
  
  if (style.highlightFontColor != nil) {
    [self.contentTextView setLinkTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:style.highlightFontColor], }];
  }
  
  [self displayEvent];
  [self displayTitle:block.title block:block];
  [self displayContent:block.text style:style];
}

- (void)displayEvent {
  if (!self.relatedSpot) {
    _eventLocationLabel.frame = CGRectZero;
    _eventDateLabel.frame = CGRectZero;
    _eventTimeImageView.frame = CGRectZero;
    _eventLocationImageView.frame = CGRectZero;
  } else {
    UIColor *testTimeColor = [UIColor orangeColor];
    UIColor *testLocationColor = [UIColor darkGrayColor];
    
    [_eventTimeImageView setImage:[self coloredImageWithColor:testTimeColor image:_eventTimeImageView.image]];
    [_eventLocationImageView setImage:[self coloredImageWithColor:testLocationColor image:_eventLocationImageView.image]];
    [_eventLocationLabel setTextColor:testLocationColor];
    [_eventDateLabel setTextColor:testTimeColor];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [NSLocale currentLocale];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:@"E d MMM HH:mm"];
    NSString *eventDateString = [NSString stringWithFormat:@"%@ -\n%@", [dateFormatter stringFromDate:self.eventStartDate], [dateFormatter stringFromDate:self.eventEndDate]];
    
    [_eventLocationLabel setText:self.relatedSpot.name];
    [_eventDateLabel setText:eventDateString];
  }
}

- (void)displayTitle:(NSString *)title block:(XMMContentBlock *)block {
  if(title != nil && ![title isEqualToString:@""]) {
    self.contentTextViewTopConstraint.constant = 8;
    self.titleLabel.text = title;
  } else {
    self.contentTextViewTopConstraint.constant = 0;
  }
}

- (void)displayContent:(NSString *)text style:(XMMStyle *)style {
  if (text != nil && ![text isEqualToString:@""]) {
    [self resetTextViewInsets:self.contentTextView];
    
    UIColor *color = [UIColor colorWithHexString:style.foregroundFontColor];
    if (color == nil) {
      color = _contentTextView.textColor;
    }
    
    self.contentTextView.attributedText = [self attributedStringFromHTML:text fontSize:[XMMContentBlock100TableViewCell fontSize] fontColor:color];
    [self.contentTextView sizeToFit];
  } else {
    [self disappearTextView:self.contentTextView];
  }
}

- (void)resetTextViewInsets:(UITextView *)textView {
  textView.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);
}

- (void)disappearTextView:(UITextView *)textView {
  [textView setFont:[UIFont systemFontOfSize:0.0f]];
  textView.textContainerInset = UIEdgeInsetsMake(0, -5, -20, -5);;
}

- (NSMutableAttributedString*)attributedStringFromHTML:(NSString*)html fontSize:(int)fontSize fontColor:(UIColor *)color {
  NSError *err = nil;
  
  NSString *style = [NSString stringWithFormat:@"<style>body{font-family: -apple-system, \"Helvetica Neue Light\", \"Helvetica Neue\", Helvetica, Arial, \"Lucida Grande\", sans-serif; font-size:%d; margin:0 !important;} p:last-child, p:last-of-type{margin:0px !important;} </style>", fontSize];
  
  html = [html stringByReplacingOccurrencesOfString:@"<br></p>" withString:@"</p>"];
  html = [html stringByReplacingOccurrencesOfString:@"<p></p>" withString:@""];
  html = [NSString stringWithFormat:@"%@%@", style, html];
  
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData: [html dataUsingEncoding:NSUTF8StringEncoding]
                                                                                        options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                                    NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding),
                                                                                                    }
                                                                             documentAttributes: nil
                                                                                          error: &err];
  if(err) {
    NSLog(@"Unable to parse label text: %@", err);
  }
  
  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  [paragraphStyle setBaseWritingDirection:NSWritingDirectionNatural];
  
  // set alignment from contentTextView
  [paragraphStyle setAlignment:_contentTextView.textAlignment];
  [attributedString addAttribute:NSParagraphStyleAttributeName
                           value:paragraphStyle
                           range:NSMakeRange(0, [attributedString length])];
  if (color != nil) {
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:color
                             range:NSMakeRange(0, attributedString.length)];
  }
  return attributedString;
}

- (UIImage*)coloredImageWithColor:(UIColor *)color image:(UIImage *)image {
  CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextClipToMask(context, rect, image.CGImage);
  CGContextSetFillColorWithColor(context, [color CGColor]);
  CGContextFillRect(context, rect);
  UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return img;
}

@end
