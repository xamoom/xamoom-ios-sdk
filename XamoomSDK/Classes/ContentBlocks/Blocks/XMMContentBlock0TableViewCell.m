//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMContentBlock0TableViewCell.h"

@interface XMMContentBlock0TableViewCell()
@end

@implementation XMMContentBlock0TableViewCell

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
  
  self.copyrightLabel.text = nil;
  self.titleLabel.text = nil;
  if (style.foregroundFontColor != nil) {
    self.titleLabel.textColor = [UIColor colorWithHexString:style.foregroundFontColor];
  }
  if (style.highlightFontColor != nil) {
    [self.contentTextView setLinkTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:style.highlightFontColor], }];
  }
  
  if (block.title != nil && ![block.title isEqualToString:@""]) {
    self.titleLabel.hidden = NO;
    self.titleLabel.text = block.title;
  }
  
  [self displayContent:block.text style:style];
  
  if (block.copyright != nil && ![block.copyright isEqualToString:@""]) {
    self.copyrightLabel.hidden = NO;
    self.copyrightLabel.text = block.copyright;
    [self.copyrightLabel sizeToFit];
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
    
    self.contentTextView.attributedText = [self attributedStringFromHTML:text
                                                                fontSize:[XMMContentBlock0TableViewCell fontSize]
                                                               fontColor:color];
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
  self.contentTextViewTopConstraint.constant = 0;
}

- (NSMutableAttributedString*)attributedStringFromHTML:(NSString*)html fontSize:(int)fontSize fontColor:(UIColor *)color {
  NSError *err = nil;
  
  NSString *style = [NSString stringWithFormat:@"<style>body{font-family: \"Helvetica Neue Light\", \"Helvetica Neue\", Helvetica, Arial, \"Lucida Grande\", sans-serif; font-size:%d; margin:0 !important;} p:last-child{text-align:right;}, p:last-of-type{margin:0px !important;} </style>", fontSize];
  
  html = [html stringByReplacingOccurrencesOfString:@"<p></p>" withString:@""];
  html = [html stringByReplacingOccurrencesOfString:@"</ul>" withString:@"</ul><br>"];
  html = [html stringByReplacingOccurrencesOfString:@"</p>" withString:@"</p><br>"];
  html = [NSString stringWithFormat:@"%@%@", style, html];
  
  if ([[html substringFromIndex:[html length] - 12] isEqualToString:@"<br></p><br>"]) {
    html = [html substringToIndex:[html length] - 12];
    html = [html stringByAppendingString:@"</p>"];
  } else if ([[html substringFromIndex:[html length] - 4] isEqualToString:@"<br>"] ) {
    html = [html substringToIndex:[html length] - 4];
    html = [html stringByAppendingString:@"</p>"];
  } else if ([[html substringFromIndex:[html length] - 8] isEqualToString:@"</p><br>"] || [[html substringFromIndex:[html length] - 8] isEqualToString:@"<br></p>"]) {
    html = [html substringToIndex:[html length] - 8];
    html = [html stringByAppendingString:@"</p>"];
  }
  
  html = [html stringByReplacingOccurrencesOfString:@"</p></p>" withString:@"</p>"];
  //html = [html stringByReplacingOccurrencesOfString:@"</p><br><p>" withString:@""];
  
  NSMutableAttributedString *attributedString =
  [[NSMutableAttributedString alloc] initWithData: [html dataUsingEncoding:NSUTF8StringEncoding]
                                          options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                      NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                               documentAttributes: nil
                                            error: &err];
  
  if(err) {
    NSLog(@"Unable to parse label text: %@", err);
  }
  
  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  [paragraphStyle setBaseWritingDirection:NSWritingDirectionNatural];

  if ([html containsString:@"<ul><li>"]) {
    [paragraphStyle addTabStop:[[NSTextTab alloc] initWithTextAlignment:NSTextAlignmentLeft location:10 options:nil]];
    [paragraphStyle setDefaultTabInterval:10];
    //[paragraphStyle setHeadIndent:29];
  }
  
  [attributedString addAttribute:NSParagraphStyleAttributeName
                           value:paragraphStyle
                           range:NSMakeRange(0, [attributedString length])];
  
  if (color != nil) {
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:color
                             range:NSMakeRange(0, attributedString.length)];
  }
  
  NSString *last = [attributedString.string substringFromIndex:[attributedString.string length] - 1];
  if ([last isEqualToString:@"\n"]) {
    [attributedString deleteCharactersInRange:NSMakeRange([attributedString.string length] - 1, 1)];
  }
  
  return attributedString;
}

@end
