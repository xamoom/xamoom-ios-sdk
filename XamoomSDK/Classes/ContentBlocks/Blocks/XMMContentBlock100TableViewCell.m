//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMContentBlock100TableViewCell.h"
#import "XMMAnnotation.h"
#import <EventKit/EventKit.h>

@interface XMMContentBlock100TableViewCell()
@property (nonatomic) NSString *title;
@property (nonatomic) NSBundle *bundle;
@property (nonatomic) NSString *calendarLocationName;
@end

@implementation XMMContentBlock100TableViewCell

static int contentFontSize;
static UIColor *contentLinkColor;

- (void)awakeFromNib {
  // Initialization code
  self.titleLabel.text = @"";
  self.contentTextView.text = @"";
  
  NSBundle *bundle = [NSBundle bundleForClass:[self class]];
  NSURL *url = [bundle URLForResource:@"XamoomSDK" withExtension:@"bundle"];
  if (url) {
    self.bundle = [NSBundle bundleWithURL:url];
  } else {
    self.bundle = bundle;
  }
  
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
  
  [self displayEvent:tableView block:block];
  [self displayTitle:block.title block:block];
  [self displayContent:block.text style:style];
}

- (void)displayEvent:(UITableView *)tableView block:(XMMContentBlock *)block {
  UIColor *locationColor = [UIColor darkGrayColor];
  if (self.relatedSpot && self.eventStartDate) {
    self.calendarLocationName = self.relatedSpot.name;
    [self showEventTimeLayout:locationColor];
    [self showEventLocationLayout:locationColor];
  } else if (!self.relatedSpot && self.eventStartDate) {
    [self hideEventLocationLayout];
    [self showEventTimeLayout:locationColor];
  } else if (self.relatedSpot && !self.eventStartDate) {
    self.calendarLocationName = self.relatedSpot.name;
    [self hideEventTimeLayout];
    [self showEventLocationLayout:locationColor];
  } else {
    [self hideEventTimeLayout];
    [self hideEventLocationLayout];
  }
  
  if ([tableView.visibleCells containsObject:self]) {
    [tableView reloadData];
  }
}

- (void)showEventTimeLayout:(UIColor *)tintColor {
  [_eventTimeImageView setImage:[self coloredImageWithColor:tintColor image:_eventTimeImageView.image]];
  [_eventDateLabel setTextColor:tintColor];
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  NSLocale *locale = [NSLocale currentLocale];
  [dateFormatter setLocale:locale];
  [dateFormatter setDateFormat:@"E d MMM HH:mm"];
  
  NSString *eventDateString = [dateFormatter stringFromDate:self.eventStartDate];
  if (self.eventEndDate != nil) {
    eventDateString = [NSString stringWithFormat:@"%@ -\n%@", [dateFormatter stringFromDate:self.eventStartDate], [dateFormatter stringFromDate:self.eventEndDate]];
  }
  
  [_eventDateLabel setText:eventDateString];
  _dateLabelHeightConstraint.constant = [self.eventDateLabel.text sizeWithFont:self.eventDateLabel.font
  constrainedToSize: CGSizeMake(self.eventDateLabel.frame.size.width, FLT_MAX)
      lineBreakMode:self.eventDateLabel.lineBreakMode].height;
  _eventDateLabel.userInteractionEnabled = YES;
  UITapGestureRecognizer *calendarAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveEventInCalendar)];
  [_eventDateLabel addGestureRecognizer:calendarAction];
}

- (void)showEventLocationLayout:(UIColor *)tintColor {
  [_eventLocationImageView setImage:[self coloredImageWithColor:tintColor image:_eventLocationImageView.image]];
  [_eventLocationLabel setTextColor:tintColor];
  [_eventLocationLabel setText:self.relatedSpot.name];
  _locationLabelHeightConstraint.constant = [self.eventLocationLabel.text sizeWithFont:self.eventLocationLabel.font
                                                                     constrainedToSize: CGSizeMake(self.eventLocationLabel.frame.size.width, FLT_MAX)
                                                                     lineBreakMode:self.eventLocationLabel.lineBreakMode].height;
  
  _eventLocationLabel.userInteractionEnabled = YES;
  UITapGestureRecognizer *navigationAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navigateToEvent)];
  [_eventLocationLabel addGestureRecognizer:navigationAction];
}

- (void)hideEventTimeLayout {
  _timeImageViewHeightConstraint.constant = 0;
  _dateLabelHeightConstraint.constant = 0;
  self.eventDateLabelTopConstraint.constant = 0;
  self.eventTimeImageViewTopConstraint.constant = 0;
}

- (void)hideEventLocationLayout {
  _locationImageViewHeightConstraint.constant = 0;
  _locationLabelHeightConstraint.constant = 0;
  self.eventLocationImageViewTopConstraint.constant = 0;
  self.evenLocationLabelTopConstraint.constant = 0;
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
    self.contentTextViewBottomConstraint.constant = 0;
    self.contentTextViewTopConstraint.constant = 0;
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
  [color setFill];
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextTranslateCTM(context, 0, rect.size.height);
  CGContextScaleCTM(context, 1.0, -1.0);
  CGContextSetBlendMode(context, kCGBlendModeNormal);
  CGContextClipToMask(context, rect, image.CGImage);
  CGContextFillRect(context, rect);
  UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return img;
}

- (void)navigateToEvent {
  CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.relatedSpot.latitude, self.relatedSpot.longitude);
  MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
  MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
  
  NSString *directionMode = MKLaunchOptionsDirectionsModeDriving;
  
  switch ([self.navigationType intValue]) {
    case 0:
      directionMode = MKLaunchOptionsDirectionsModeWalking;
      break;
    case 1:
      directionMode = MKLaunchOptionsDirectionsModeDriving;
      break;
    case 2:
      directionMode = MKLaunchOptionsDirectionsModeTransit;
      break;
    default:
      directionMode = MKLaunchOptionsDirectionsModeDriving;
      break;
  }
  
  NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : directionMode};
  [mapItem setName: self.relatedSpot.name];
  [mapItem openInMapsWithLaunchOptions:launchOptions];
}

- (void)saveEventInCalendar {
  EKEventStore *store = [EKEventStore new];
  [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
    if (granted) {
      NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
      [dateFormatter setDateFormat:@"yyyyMMdd'T'HHmmss"];
      EKEvent *newEvent = [EKEvent eventWithEventStore:store];
      newEvent.startDate = self.eventStartDate;
      
      if (self.eventEndDate) {
        newEvent.endDate = self.eventEndDate;
      } else {
        newEvent.endDate = self.eventStartDate;
      }
           
      newEvent.title = self.contentTilte;
      
      if (self.calendarLocationName != nil && ![self.calendarLocationName isEqualToString:@""]) {
        newEvent.location = self.calendarLocationName;
      }
      
      if (newEvent != nil) {
        [self saveEvent:newEvent withStore:store];
      } else {
        [self showErrorAlert];
      }
    }
  }];
}

/**
 * Save the given event. Shows an UIAlertController for choosing an calendar.
 *
 * @param event The given event to save.
 * @param store The EKEventStore to save the event.
 */
-(void)saveEvent:(EKEvent *)event withStore:(EKEventStore*)store {
  NSArray *calendars = [store calendarsForEntityType: EKEntityTypeEvent];
  NSMutableArray *res =[[NSMutableArray alloc] init];
  
  for (EKCalendar *cal in calendars) {
    if (cal.type == EKCalendarTypeCalDAV || cal.type == EKCalendarTypeLocal){
      [res addObject: cal];
    }
  }
  
  if (res.count > 0){
    dispatch_async(dispatch_get_main_queue(), ^{
      UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTableInBundle(@"contentblock8.alert.choose.calendar", @"Localizable", self.bundle, nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
       for (EKCalendar *cal in res) {
          UIAlertAction *calAction = [UIAlertAction actionWithTitle: cal.title style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [event setCalendar:cal];
            [store saveEvent:event span:EKSpanThisEvent error:nil];
            [self showAddCalenderSuccess:cal event:event];
          }];
          
          [alert addAction:calAction];
        }
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"contentblock8.alert.cancel", @"Localizable", self.bundle, nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
          [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alert addAction:cancel];
        
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    });
  }
}

/**
 * Shows a UIAlertView to notify the user that the event was added successfully.
 *
 * @param calendar The calendar which was used to save the event.
 * @param event The saved event.
 */
-(void)showAddCalenderSuccess:(EKCalendar *)calendar event:(EKEvent*)event {
  dispatch_async(dispatch_get_main_queue(), ^{
    NSString *title = NSLocalizedStringFromTableInBundle(@"contentblock8.alert.hint.title", @"Localizable", self.bundle, nil);
    NSString *message = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"contentblock8.alert.calendar.success.message", @"Localizable", self.bundle, nil), event.title, calendar.title];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: title
                                                    message: message
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"OK", @"Localizable", self.bundle, nil)
                                          otherButtonTitles:nil];
    [alert show];
  });
}

/// Shows a default error message.
-(void)showErrorAlert {
  dispatch_async(dispatch_get_main_queue(), ^{
    
    
    NSString *title = NSLocalizedStringFromTableInBundle(@"contentblock8.alert.error.title", @"Localizable", self.bundle, nil);
    NSString *message = NSLocalizedStringFromTableInBundle(@"contentblock8.alert.error.message", @"Localizable", self.bundle, nil);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: title
                                                    message: message
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"OK", @"Localizable", self.bundle, nil)
                                          otherButtonTitles:nil];
    [alert show];
  });
}

@end
