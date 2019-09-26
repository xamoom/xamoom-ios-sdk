//
//  XMMContentBlockEventTableViewCell.m
//  XamoomSDK
//
//  Created by Thomas Krainz-Mischitz on 26.09.19.
//  Copyright © 2019 xamoom GmbH. All rights reserved.
//

#import "XMMContentBlockEventTableViewCell.h"

@interface XMMContentBlockEventTableViewCell()
@property (nonatomic) NSBundle *bundle;
@property (nonatomic) XMMContent *relatedContent;
@property (nonatomic) XMMSpot *relatedSpot;
@property (nonatomic) UIColor *currentCalendarColor;
@property (nonatomic) UIColor *currentNavigationColor;
@property (nonatomic) UIColor *currentCalendarTintColor;
@property (nonatomic) UIColor *currentNavigationTintColor;
@property (nonatomic) UIImage *calendarImage;
@property (nonatomic) UIImage *navigationImage;
@end

@implementation XMMContentBlockEventTableViewCell

- (void)awakeFromNib {
    // Initialization code
  self.navigationTitleLabel.text = @"";
  self.navigationDescriptionLabel.text = @"";
  self.calendarTitleLabel.text = @"";
  self.calendarDescriptionLabel.text = @"";
  
  NSBundle *bundle = [NSBundle bundleForClass:[self class]];
  NSURL *url = [bundle URLForResource:@"XamoomSDK" withExtension:@"bundle"];
  if (url) {
    self.bundle = [NSBundle bundleWithURL:url];
  } else {
    self.bundle = bundle;
  }

  _currentCalendarColor = [UIColor colorWithRed:0.23 green:0.35 blue:0.60 alpha:1.0];
  _currentCalendarTintColor = UIColor.whiteColor;
  _currentNavigationColor = [UIColor colorWithRed:0.05 green:0.64 blue:0.38 alpha:1.0f];
  _currentNavigationTintColor = UIColor.whiteColor;
  
  self.calendarImage = [[UIImage imageNamed:@"cal"
                                  inBundle:self.bundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  self.navigationImage = [[UIImage imageNamed:@"directional"
                                 inBundle:self.bundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  
  [super awakeFromNib];
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.navigationTitleLabel.text = @"";
  self.navigationDescriptionLabel.text = @"";
  
  self.calendarTitleLabel.text = @"";
  self.calendarDescriptionLabel.text = @"";
}

- (void)setupCellWithContent:(XMMContent *)content spot:(XMMSpot *)spot {
  
  self.relatedSpot = spot;
  self.relatedContent = content;
  
  NSDate *eventStartDate = content.fromDate;
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  NSLocale *locale = [NSLocale currentLocale];
  [dateFormatter setLocale:locale];
  [dateFormatter setDateFormat:@"E d MMM HH:mm"];
  
  [self.navigationTitleLabel setText:NSLocalizedStringFromTableInBundle(@"event.navigation.title", @"Localizable", self.bundle, nil)];
  [self.navigationDescriptionLabel setText:spot.name];
  
  [self.calendarTitleLabel setText:NSLocalizedStringFromTableInBundle(@"event.calendar.title", @"Localizable", self.bundle, nil)];
  [self.calendarDescriptionLabel setText:[dateFormatter stringFromDate:eventStartDate]];
  
  UITapGestureRecognizer *navigationAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navigateToEvent)];
  [self.navigationView addGestureRecognizer:navigationAction];
  
  UITapGestureRecognizer *calendarAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveEventInCalendar)];
  [self.calendarView addGestureRecognizer:calendarAction];
  
  [self styleUI];
}

- (void)styleUI {
  [self.calendarImageView setImage:self.calendarImage];
  [self.navigationImageView setImage:self.navigationImage];
  
  self.calendarView.backgroundColor = _currentCalendarColor;
  self.calendarTitleLabel.textColor = _currentCalendarTintColor;
  self.calendarImageView.tintColor = _currentCalendarTintColor;
  self.navigationView.backgroundColor = _currentNavigationColor;
  self.navigationTitleLabel.textColor = _currentNavigationTintColor;
  self.navigationImageView.tintColor = _currentNavigationTintColor;
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
      newEvent.startDate = self.relatedContent.fromDate;
      newEvent.endDate = self.relatedContent.toDate;
      newEvent.title = self.relatedContent.title;
      newEvent.location = self.relatedSpot.name;
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

- (UIColor *)calendarColor {
  return _currentCalendarColor;
}

- (UIColor *)calendarTintColor {
  return _currentCalendarTintColor;
}

- (UIColor *)navigationColor {
  return _currentNavigationColor;
}

- (UIColor *)navigationTintColor {
  return _currentNavigationTintColor;
}

- (void)setNavigationColor:(UIColor *)navigationColor {
  _currentNavigationColor = navigationColor;
  [self styleUI];
}

- (void)setNavigationTintColor:(UIColor *)navigationTintColor {
  _currentNavigationTintColor = navigationTintColor;
  [self styleUI];
}

- (void)setCalendarColor:(UIColor *)calendarColor {
  _currentCalendarColor = calendarColor;
  [self styleUI];
}

- (void)setCalendarTintColor:(UIColor *)calendarTintColor {
  _currentCalendarTintColor = calendarTintColor;
  [self styleUI];
}

@end
