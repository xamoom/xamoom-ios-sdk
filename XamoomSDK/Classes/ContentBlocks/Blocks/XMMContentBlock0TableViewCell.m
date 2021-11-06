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
    
      if ([text  isEqual: @"<p></p>"]) {
          [self disappearTextView:self.contentTextView];
      } else {
          self.contentTextView.attributedText = [self attributedStringFromHTML:text
                                                                      fontSize:[XMMContentBlock0TableViewCell fontSize]
                                                                     fontColor:color];
          [self.contentTextView sizeToFit];
      }
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
  
  
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\n{2,}" options:0 error:NULL];
    html = [regex stringByReplacingMatchesInString:html options:0 range:NSMakeRange(0, [html length]) withTemplate:@"\n"];

    NSMutableAttributedString *attributedString =
    [[NSMutableAttributedString alloc] initWithData: [@"" dataUsingEncoding:NSUTF8StringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                        NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                 documentAttributes: nil
                                              error: &err];
    
    
    if([html containsString:@"<ul>"] || [html containsString:@"<ol>"]) {
        NSMutableArray* splitedText = [NSMutableArray new];
        if([html containsString:@"<ul>"] && !([html containsString:@"<ol>"])){
            [splitedText addObjectsFromArray:[self getArrayOfHtmlStrings:html fontSize:fontSize listType:@"<ul>"]];
        } else if ([html containsString:@"<ol>"] && !([html containsString:@"<ul>"])) {
            [splitedText addObjectsFromArray:[self getArrayOfHtmlStrings:html fontSize:fontSize listType:@"<ol>"]];
        } else {
            [splitedText addObjectsFromArray:[self getArrayOfHtmlStrings:html fontSize:fontSize listType:@"<ul>"]];
        }
//        NSArray* splitedText = [self getArrayOfHtmlStrings:html fontSize:fontSize];
        for (NSString *textPart in splitedText){
            NSString *modifiedTextPart = [self getStyledHtmlString:textPart fontSize:fontSize];
                if([modifiedTextPart containsString:@"<ul>"] || [modifiedTextPart containsString:@"<ol>"]) {
                    NSMutableAttributedString *listAttributedString = [[NSMutableAttributedString alloc] initWithData: [modifiedTextPart dataUsingEncoding:NSUTF8StringEncoding]
                           options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                       NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                documentAttributes: nil
                             error: &err];
                
                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                    [paragraphStyle setBaseWritingDirection:NSWritingDirectionNatural];

                    if (@available(iOS 9.0, *)) {
                        [paragraphStyle addTabStop:[[NSTextTab alloc] initWithTextAlignment:NSTextAlignmentLeft location:10 options:nil]];
                    }
                    [paragraphStyle setHeadIndent:28];
                    [paragraphStyle setParagraphSpacing:5];
                    [paragraphStyle setAlignment:NSTextAlignmentNatural];
                
                    [listAttributedString addAttribute:NSParagraphStyleAttributeName
                                         value:paragraphStyle
                                         range:NSMakeRange(0, [listAttributedString length])];
                
                    [attributedString appendAttributedString:listAttributedString];
                    
                
                } else {
                    NSMutableAttributedString *ordinaryAttributedStringNearList = [[NSMutableAttributedString alloc] initWithData: [modifiedTextPart dataUsingEncoding:NSUTF8StringEncoding]
                           options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                       NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                documentAttributes: nil
                             error: &err];
                
                    NSMutableParagraphStyle *ordinaryParagraphStyleNearList = [[NSMutableParagraphStyle alloc] init];
                    [ordinaryParagraphStyleNearList setBaseWritingDirection:NSWritingDirectionNatural];

                    [ordinaryAttributedStringNearList addAttribute:NSParagraphStyleAttributeName
                                         value:ordinaryParagraphStyleNearList
                                         range:NSMakeRange(0, [ordinaryAttributedStringNearList length])];
                
                    [attributedString appendAttributedString:ordinaryAttributedStringNearList];
            }
        }
            
    } else {
       NSString *modifiedTextPartOrdinary = [self getStyledHtmlString:html fontSize:fontSize];
       NSMutableAttributedString *ordinaryAttributedString = [[NSMutableAttributedString alloc] initWithData: [modifiedTextPartOrdinary dataUsingEncoding:NSUTF8StringEncoding]
                   options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                               NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
        documentAttributes: nil
                     error: &err];
        
        NSMutableParagraphStyle *ordinaryParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        [ordinaryParagraphStyle setBaseWritingDirection:NSWritingDirectionNatural];

        [ordinaryAttributedString addAttribute:NSParagraphStyleAttributeName
                                 value:ordinaryParagraphStyle
                                 range:NSMakeRange(0, [ordinaryAttributedString length])];
        
        [attributedString appendAttributedString:ordinaryAttributedString];
    }
    
    


  if(err) {
      NSLog(@"Unable to parse label text: %@", err);
  }
    
  if (color != nil) {
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:color
                             range:NSMakeRange(0, attributedString.length)];
  }
  
    BOOL *isNewLineExist = true;
    
    NSLog(@"%@", attributedString.string);
    if ([attributedString.string  isEqual: @""]) {
        return attributedString;
    }
    while (isNewLineExist) {
        NSString *last = [attributedString.string substringFromIndex:[attributedString.string length] - 1];
        if ([last isEqualToString:@"\n"]) {
          [attributedString deleteCharactersInRange:NSMakeRange([attributedString.string length] - 1, 1)];
        } else {
            isNewLineExist = false;
        }
    }
  
  return attributedString;
}

-(NSString*) getStyledHtmlString: (NSString*)html fontSize:(int)fontSize {
    NSString *style = [NSString stringWithFormat:@"<style>body{font-family: \"Helvetica Neue Light\", \"Helvetica Neue\", Helvetica, Arial, \"Lucida Grande\", sans-serif; font-size:%d; margin:0 !important;} p:last-child{text-align:right;}, p:last-of-type{margin:0px !important;} </style>", fontSize];
    
    html = [html stringByReplacingOccurrencesOfString:@"<p></p>" withString:@""];
//    html = [html stringByReplacingOccurrencesOfString:@"</ul>" withString:@"</ul><br>"];
    html = [html stringByReplacingOccurrencesOfString:@"<br></li>" withString:@"</li>"];
    html = [html stringByReplacingOccurrencesOfString:@"<br></p>" withString:@"</p>"];
    html = [html stringByReplacingOccurrencesOfString:@"</p>" withString:@"</p><br>"];
    html = [html stringByReplacingOccurrencesOfString:@"</p><br><br><p>" withString:@"</p><br><p>"];
    html = [html stringByReplacingOccurrencesOfString:@"</p><p>" withString:@"</p><p>"];
    
    html = [NSString stringWithFormat:@"%@%@", style, html];
    
    if(!([html containsString:@"<ul>"])) {
        if ([[html substringFromIndex:[html length] - 12] isEqualToString:@"<br></p><br>"]) {
            html = [html substringToIndex:[html length] - 12];
            html = [html stringByAppendingString:@"</p>"];
        } else if ([[html substringFromIndex:[html length] - 4] isEqualToString:@"<br>"] ) {
            html = [html substringToIndex:[html length] - 4];
        html = [html stringByAppendingString:@"</p>"];
        } else if ([[html substringFromIndex:[html length] - 8] isEqualToString:@"</p><br>"] ||     [[html substringFromIndex:[html length] - 8] isEqualToString:@"<br></p>"]) {
        html = [html substringToIndex:[html length] - 8];
        html = [html stringByAppendingString:@"</p>"];
        }
    }
    
    html = [html stringByReplacingOccurrencesOfString:@"</p></p>" withString:@"</p>"];
    html = [html stringByReplacingOccurrencesOfString:@"</p><br><br><p>" withString:@"</p><br><p>"];
    html = [html stringByReplacingOccurrencesOfString:@"<br><br>" withString:@"<br>"];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+<p>" options:0 error:NULL];
    html = [regex stringByReplacingMatchesInString:html options:0 range:NSMakeRange(0, [html length]) withTemplate:@"<p>"];
    
    return html;
}

- (NSString *) getEndTag: (NSString *) tag{
    NSMutableString *endTag = [NSMutableString stringWithString:tag];
    [endTag insertString:@"/" atIndex:1];
    return [NSString stringWithString:endTag];
}


- (NSMutableArray *) getArrayOfHtmlStrings: (NSString *) text fontSize: (int)fontSize listType: (NSString *) listType {
    NSMutableArray *result = [NSMutableArray array];
    
    NSString *pattern = [NSString stringWithFormat:@"%@((.|\n|\r)*)%@", listType, [self getEndTag:listType]];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [regex matchesInString:text
    options:0
      range:NSMakeRange(0, [text length])];
    
    
    for(int i = 0; i < [matches count]; i++) {
        NSRange currentMatchRange = [[matches objectAtIndex:i] range];
        int thisListStartIndex = currentMatchRange.location;
        int thisListEndIndex = currentMatchRange.location + currentMatchRange.length;
        NSRange nextMatchRange;
        int nextListStartIndex;
        int nextListEndIndex;
        if(i != ([matches count] -1)) {
            nextMatchRange = [[matches objectAtIndex:i+1] range];
            nextListStartIndex = nextMatchRange.location;
            nextListEndIndex = nextMatchRange.location + nextMatchRange.length;
        }
        
    
        //adding first before <ul> element
        if(i == 0 && thisListStartIndex != 0) {
            NSString *headString = [text substringWithRange:NSMakeRange(0, thisListStartIndex)];
            [result addObject:[self getStyledHtmlString:headString fontSize:fontSize]];
        }
        
        //adding <ul> element
        NSString *listString = [text substringWithRange:NSMakeRange(thisListStartIndex, thisListEndIndex - thisListStartIndex)];
        [result addObject:[self getStyledHtmlString:listString fontSize:fontSize]];
        
        //adding string after <ul> element
        if(i == ([matches count] - 1) && thisListEndIndex != text.length) {
            NSString *tailString = [text substringWithRange:NSMakeRange(thisListEndIndex, text.length - thisListEndIndex)];
            [result addObject:[self getStyledHtmlString:tailString fontSize:fontSize]];
        } else if(i != ([matches count] - 1) && thisListEndIndex != nextListStartIndex) {
            
                NSString *stringAfterListString = [text substringWithRange:NSMakeRange(thisListEndIndex, nextListStartIndex - thisListEndIndex)];
                [result addObject:[self getStyledHtmlString:stringAfterListString fontSize:fontSize]];
        
        }
    }
        
    return result;
    
}

@end
