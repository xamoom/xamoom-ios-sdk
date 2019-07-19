//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMContentBlock8TableViewCell.h"
#import <Contacts/Contacts.h>
#import <EventKit/EventKit.h>
@interface XMMContentBlock8TableViewCell() <UIDocumentInteractionControllerDelegate>

@property (strong, nonatomic) UIDocumentInteractionController *docController;
@property (nonatomic) int downloadType;
@property (nonatomic) UIColor *currentCalendarColor;
@property (nonatomic) UIColor *currentCalendarTintColor;
@property (nonatomic) UIColor *currentContactColor;
@property (nonatomic) UIColor *currentContactTintColor;
@property (nonatomic) UIColor *currentGpxColor;
@property (nonatomic) UIColor *currentGpxTintColor;
@end

@implementation XMMContentBlock8TableViewCell

- (void)awakeFromNib {
  self.titleLabel.text = nil;
  self.contentTextLabel.text = nil;
  self.fileID = nil;
  
  NSBundle *bundle = [NSBundle bundleForClass:[self class]];
  NSURL *url = [bundle URLForResource:@"XamoomSDK" withExtension:@"bundle"];
  NSBundle *imageBundle = nil;
  if (url) {
    imageBundle = [NSBundle bundleWithURL:url];
  } else {
    imageBundle = bundle;
  }
  
  self.calendarImage = [[UIImage imageNamed:@"cal"
                                  inBundle:imageBundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  self.contactImage = [[UIImage imageNamed:@"contact"
                                 inBundle:imageBundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  
  self.gpxImage = [[UIImage imageNamed:@"gpx"
                                  inBundle:imageBundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  
  _currentCalendarColor = [UIColor colorWithRed:0.23 green:0.35 blue:0.60 alpha:1.0];
  _currentCalendarTintColor = UIColor.whiteColor;
  _currentContactColor = [UIColor colorWithRed:0.67 green:0.25 blue:0.25 alpha:1.0];
  _currentContactTintColor = UIColor.whiteColor;
  
  [super awakeFromNib];
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.titleLabel.text = nil;
  self.contentTextLabel.text = nil;
  self.fileID = nil;
}

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style offline:(BOOL)offline {
  self.offline = offline;
  self.titleLabel.text = block.title;
  self.contentTextLabel.text = block.text;
  self.fileID = block.fileID;
  self.downloadType = block.downloadType;

  [self styleBlockForType:block.downloadType];
}

- (void)styleBlockForType:(int)type {
  switch (type) {
    case 0:
      [self.icon setImage:self.contactImage];
      self.viewForBackground.backgroundColor = _currentContactColor;
      self.icon.tintColor = _currentContactTintColor;
      self.titleLabel.textColor = _currentContactTintColor;
      self.contentTextLabel.textColor = _currentContactTintColor;
      break;
      
    case 1:
      [self.icon setImage:self.calendarImage];
      self.viewForBackground.backgroundColor = _currentCalendarColor;
      self.icon.tintColor = _currentCalendarTintColor;
      self.titleLabel.textColor = _currentCalendarTintColor;
      self.contentTextLabel.textColor = _currentCalendarTintColor;
      break;
      
    case 2:
      [self.icon setImage:self.gpxImage];
      self.viewForBackground.backgroundColor = _currentGpxColor;
      self.icon.tintColor = _currentGpxTintColor;
      self.titleLabel.textColor = _currentGpxTintColor;
      self.contentTextLabel.textColor = _currentGpxTintColor;
      break;
  }
}

- (void)openLink {
  if (self.offline) {
    NSURL *localURL = [self.fileManager urlForSavedData:self.fileID];
    
    if (localURL != nil) {
      self.docController = [UIDocumentInteractionController interactionControllerWithURL:localURL];
      self.docController.delegate = self;
      [self.docController presentOpenInMenuFromRect:CGRectZero inView:self.contentView animated:YES];
    }
  } else {
    NSURL *url = [NSURL URLWithString:self.fileID];
    NSData *data = [NSData dataWithContentsOfURL:url];
     if (_downloadType == 0) {
       if (!data) {
         [self showErrorAlert];
         return;
       }
      if (@available(iOS 9.0, *)) {
        CNContactStore *store = [CNContactStore new];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError *error) {
          if (granted) {
            NSArray *contacts = [CNContactVCardSerialization contactsWithData:data error:nil];
            CNContact *c = contacts[0];
            CNMutableContact *contact = [CNMutableContact new];
            contact = [(CNMutableContact *) c mutableCopy];
            
            CNSaveRequest *request = [CNSaveRequest new];
            
            @try {
              [request addContact:contact toContainerWithIdentifier:nil];
              [store executeSaveRequest:request error:&error];
              
              NSString *alertMessage = [NSString stringWithFormat:@"%@ %@ %@ %@", @"Successfully added", contact.familyName, contact.givenName, @"to your contacts"];
              UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Finished"
                                                                             message:alertMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];
              
              UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                    handler:^(UIAlertAction * action) {}];
              
              [alert addAction:defaultAction];
              [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
              printf("Contact save succeed");
            }
            @catch (NSException *exception) {
              [self showErrorAlert];
              printf("Contact save failed");
            }
          }
        }];
        
      } else {
        NSURL *localURL = [self.fileManager urlForSavedData:self.fileID];
        
        if (localURL != nil) {
          self.docController = [UIDocumentInteractionController interactionControllerWithURL:localURL];
          self.docController.delegate = self;
          [self.docController presentOpenInMenuFromRect:CGRectZero inView:self.contentView animated:YES];
        }
      }
      printf("test");
     } else if (_downloadType == 1) {
       
       EKEventStore *store = [EKEventStore new];
       [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
         if (granted) {
           NSString *icsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
           EKEvent *event = [self parseICSStringToEvent:icsString andEventStore:store];
           if (event != nil) {
             [self saveEvent:event withStore:store];
           } else {
             [self showErrorAlert];
           }
         }
       }];
       printf("test");
     } else {
       NSString *gpxString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
       NSURL *dir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
       
       NSString *fileName = [[self.fileID componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]] lastObject];
       NSURL *fileURL = [dir URLByAppendingPathComponent:fileName];
       
       @try {
         [gpxString writeToFile:fileURL atomically:NO encoding:NSUTF8StringEncoding error:nil];
         NSArray *objectsToShare = @[fileURL];
         
         UIActivityViewController *aVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
         [self.window.rootViewController presentViewController:aVC animated:YES completion:nil];
       } @catch (NSException *exception) {
         [self showErrorAlert];
       }
       printf("test");
    }
  }
}

-(EKEvent *)parseICSStringToEvent:(NSString *)icsString andEventStore:(EKEventStore*)store {
  NSError *error = nil;
  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\n +" options:NSRegularExpressionCaseInsensitive error:&error];
  NSString *icsStringWithoutNewlines = [regex stringByReplacingMatchesInString:icsString options:0 range:NSMakeRange(0, [icsString length]) withTemplate:@""];
  
  // Pull out each line from the calendar file
  NSMutableArray *eventsArray = [NSMutableArray arrayWithArray:[icsStringWithoutNewlines componentsSeparatedByString:@"BEGIN:VEVENT"]];
  
  NSString *calendarString;
  
  // Remove the first item (that's just all the stuff before the first VEVENT)
  if ([eventsArray count] > 0) {
    NSScanner *scanner = [NSScanner scannerWithString:[eventsArray objectAtIndex:0]];
    [scanner scanUpToString:@"TZID:" intoString:nil];
    
    [scanner scanUpToString:@"\n" intoString:&calendarString];
    
    calendarString = [[[calendarString stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""] stringByReplacingOccurrencesOfString:@"TZID:" withString:@""];
    
    [eventsArray removeObjectAtIndex:0];
  }
  
  NSScanner *eventScanner;
  
  // For each event, extract the data
  for (NSString *event in eventsArray) {
    NSString *timezoneIDString;
    NSString *startDateTimeString;
    NSString *endDateTimeString;
    NSString *eventUniqueIDString;
    NSString *recurrenceIDString;
    NSString *createdDateTimeString;
    NSString *descriptionString;
    NSString *lastModifiedDateTimeString;
    NSString *locationString;
    NSString *sequenceString;
    NSString *statusString;
    NSString *summaryString;
    NSString *transString;
    NSString *timeStampString;
    NSString *repetitionString;
    NSString *exceptionRuleString;
    NSMutableArray *exceptionDates = [[NSMutableArray alloc] init];
    
    // Extract event time zone ID
    eventScanner = [NSScanner scannerWithString:event];
    [eventScanner scanUpToString:@"DTSTART;TZID=" intoString:nil];
    [eventScanner scanUpToString:@":" intoString:&timezoneIDString];
    timezoneIDString = [[timezoneIDString stringByReplacingOccurrencesOfString:@"DTSTART;TZID=" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    if (!timezoneIDString) {
      // Extract event time zone ID
      eventScanner = [NSScanner scannerWithString:event];
      [eventScanner scanUpToString:@"TZID:" intoString:nil];
      [eventScanner scanUpToString:@"\n" intoString:&timezoneIDString];
      timezoneIDString = [[timezoneIDString stringByReplacingOccurrencesOfString:@"TZID:" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    
    // Extract start time
    eventScanner = [NSScanner scannerWithString:event];
    [eventScanner scanUpToString:[NSString stringWithFormat:@"DTSTART;TZID=%@:", timezoneIDString] intoString:nil];
    [eventScanner scanUpToString:@"\n" intoString:&startDateTimeString];
    startDateTimeString = [[startDateTimeString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"DTSTART;TZID=%@:", timezoneIDString] withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    if (!startDateTimeString) {
      eventScanner = [NSScanner scannerWithString:event];
      [eventScanner scanUpToString:@"DTSTART:" intoString:nil];
      [eventScanner scanUpToString:@"\n" intoString:&startDateTimeString];
      startDateTimeString = [[startDateTimeString stringByReplacingOccurrencesOfString:@"DTSTART:" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
      
      if (!startDateTimeString) {
        eventScanner = [NSScanner scannerWithString:event];
        [eventScanner scanUpToString:@"DTSTART;VALUE=DATE:" intoString:nil];
        [eventScanner scanUpToString:@"\n" intoString:&startDateTimeString];
        startDateTimeString = [[startDateTimeString stringByReplacingOccurrencesOfString:@"DTSTART;VALUE=DATE:" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
      }
    }
    
    // Extract end time
    eventScanner = [NSScanner scannerWithString:event];
    [eventScanner scanUpToString:[NSString stringWithFormat:@"DTEND;TZID=%@:", timezoneIDString] intoString:nil];
    [eventScanner scanUpToString:@"\n" intoString:&endDateTimeString];
    endDateTimeString = [[endDateTimeString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"DTEND;TZID=%@:", timezoneIDString] withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    if (!endDateTimeString) {
      eventScanner = [NSScanner scannerWithString:event];
      [eventScanner scanUpToString:@"DTEND:" intoString:nil];
      [eventScanner scanUpToString:@"\n" intoString:&endDateTimeString];
      endDateTimeString = [[endDateTimeString stringByReplacingOccurrencesOfString:@"DTEND:" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
      
      if (!endDateTimeString) {
        eventScanner = [NSScanner scannerWithString:event];
        [eventScanner scanUpToString:@"DTEND;VALUE=DATE:" intoString:nil];
        [eventScanner scanUpToString:@"\n" intoString:&endDateTimeString];
        endDateTimeString = [[endDateTimeString stringByReplacingOccurrencesOfString:@"DTEND;VALUE=DATE:" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
      }
    }
    
    // Extract timestamp
    eventScanner = [NSScanner scannerWithString:event];
    [eventScanner scanUpToString:@"DTSTAMP:" intoString:nil];
    [eventScanner scanUpToString:@"\n" intoString:&timeStampString];
    timeStampString = [[timeStampString stringByReplacingOccurrencesOfString:@"DTSTAMP:" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    // Extract the unique ID
    eventScanner = [NSScanner scannerWithString:event];
    [eventScanner scanUpToString:@"UID:" intoString:nil];
    [eventScanner scanUpToString:@"\n" intoString:&eventUniqueIDString];
    eventUniqueIDString = [[eventUniqueIDString stringByReplacingOccurrencesOfString:@"UID:" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    // Extract the attendees
    eventScanner = [NSScanner scannerWithString:event];
    
    // Extract the recurrance ID
    eventScanner = [NSScanner scannerWithString:event];
    [eventScanner scanUpToString:[NSString stringWithFormat:@"RECURRENCE-ID;TZID=%@:", timezoneIDString] intoString:nil];
    [eventScanner scanUpToString:@"\n" intoString:&recurrenceIDString];
    recurrenceIDString = [[recurrenceIDString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"RECURRENCE-ID;TZID=%@:", timezoneIDString] withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    // Extract the created datetime
    eventScanner = [NSScanner scannerWithString:event];
    [eventScanner scanUpToString:@"CREATED:" intoString:nil];
    [eventScanner scanUpToString:@"\n" intoString:&createdDateTimeString];
    createdDateTimeString = [[createdDateTimeString stringByReplacingOccurrencesOfString:@"CREATED:" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    
    // Extract event description
    eventScanner = [NSScanner scannerWithString:event];
    [eventScanner scanUpToString:@"DESCRIPTION:" intoString:nil];
    [eventScanner scanUpToString:@"\n" intoString:&descriptionString];
    descriptionString = [[[descriptionString stringByReplacingOccurrencesOfString:@"DESCRIPTION:" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    // Extract last modified datetime
    eventScanner = [NSScanner scannerWithString:event];
    [eventScanner scanUpToString:@"LAST-MODIFIED:" intoString:nil];
    [eventScanner scanUpToString:@"\n" intoString:&lastModifiedDateTimeString];
    lastModifiedDateTimeString = [[[lastModifiedDateTimeString stringByReplacingOccurrencesOfString:@"LAST-MODIFIED:" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    // Extract the event location
    eventScanner = [NSScanner scannerWithString:event];
    [eventScanner scanUpToString:@"LOCATION:" intoString:nil];
    [eventScanner scanUpToString:@"\n" intoString:&locationString];
    locationString = [[[locationString stringByReplacingOccurrencesOfString:@"LOCATION:" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    // Extract the event sequence
    eventScanner = [NSScanner scannerWithString:event];
    [eventScanner scanUpToString:@"SEQUENCE:" intoString:nil];
    [eventScanner scanUpToString:@"\n" intoString:&sequenceString];
    sequenceString = [[[sequenceString stringByReplacingOccurrencesOfString:@"SEQUENCE:" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    // Extract the event status
    eventScanner = [NSScanner scannerWithString:event];
    [eventScanner scanUpToString:@"STATUS:" intoString:nil];
    [eventScanner scanUpToString:@"\n" intoString:&statusString];
    statusString = [[[statusString stringByReplacingOccurrencesOfString:@"STATUS:" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    // Extract the event summary
    eventScanner = [NSScanner scannerWithString:event];
    [eventScanner scanUpToString:@"SUMMARY:" intoString:nil];
    [eventScanner scanUpToString:@"\n" intoString:&summaryString];
    summaryString = [[[summaryString stringByReplacingOccurrencesOfString:@"SUMMARY:" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    // Extract the event transString
    eventScanner = [NSScanner scannerWithString:event];
    [eventScanner scanUpToString:@"TRANSP:" intoString:nil];
    [eventScanner scanUpToString:@"\n" intoString:&transString];
    transString = [[[transString stringByReplacingOccurrencesOfString:@"TRANSP:" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    // Extract the event repetition rules
    eventScanner = [NSScanner scannerWithString:event];
    [eventScanner scanUpToString:@"RRULE:" intoString:nil];
    [eventScanner scanUpToString:@"\n" intoString:&repetitionString];
    repetitionString = [[[repetitionString stringByReplacingOccurrencesOfString:@"RRULE:" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    // Extract the event exception rules
    eventScanner = [NSScanner scannerWithString:event];
    [eventScanner scanUpToString:@"EXRULE:" intoString:nil];
    [eventScanner scanUpToString:@"\n" intoString:&exceptionRuleString];
    exceptionRuleString = [[[exceptionRuleString stringByReplacingOccurrencesOfString:@"EXRULE:" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    // Set up scanner for
    eventScanner = [NSScanner scannerWithString:event];
    [eventScanner scanUpToString:@"EXDATE;" intoString:nil];
    
    while (![eventScanner isAtEnd]) {
      [eventScanner scanUpToString:@":" intoString:nil];
      NSString *exceptionString = [[NSString alloc] init];
      [eventScanner scanUpToString:@"\n" intoString:&exceptionString];
      exceptionString = [[[exceptionString stringByReplacingOccurrencesOfString:@":" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
      
      if (exceptionString) {
        [exceptionDates addObject:exceptionString];
      }
      
      [eventScanner scanUpToString:@"EXDATE;" intoString:nil];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd'T'HHmmss"];
    
    EKEvent *newEvent = [EKEvent eventWithEventStore:store];
    newEvent.startDate = [dateFormatter dateFromString:startDateTimeString];
    newEvent.endDate = [dateFormatter dateFromString:endDateTimeString];
    newEvent.title = descriptionString;
    newEvent.location = locationString;
    
    return newEvent;
  }
  
  return nil;
}

-(void)saveEvent:(EKEvent *)event withStore:(EKEventStore*)store {
  NSArray *calendars = [store calendarsForEntityType: EKEntityTypeEvent];
  NSMutableArray *res =[[NSMutableArray alloc] init];
  
  for (EKCalendar *cal in calendars) {
    if (cal.type == EKCalendarTypeCalDAV || cal.type == EKCalendarTypeLocal){
      [res addObject: cal];
    }
  }
  
  if (res.count > 0){
  
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Title" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (EKCalendar *cal in res) {
      UIAlertAction *calAction = [UIAlertAction actionWithTitle: cal.title style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [event setCalendar:[store defaultCalendarForNewEvents]];
        [store saveEvent:event span:EKSpanThisEvent error:nil];
      }];
      
      [alert addAction:calAction];
    }
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
      [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:cancel];
    
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
  } else {
    //TODO: No calendar available.
  }
}

-(void)showErrorAlert {
  dispatch_async(dispatch_get_main_queue(), ^{
    
    NSString *title = NSLocalizedString(@"contentblock8.alert.error.title", nil);
    NSString *message = NSLocalizedString(@"contentblock8.alert.error.message", nil);
    
    if ([title isEqualToString:@"contentblock8.alert.error.title"]) {
      title = @"Error";
    }
    
    if ([message isEqualToString:@"contentblock8.alert.error.message"]) {
      message = @"This is not a valid file";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: title
                                                    message: message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
  });
}

- (XMMOfflineFileManager *)fileManager {
  if (_fileManager == nil) {
    _fileManager = [[XMMOfflineFileManager alloc] init];
  }
  return _fileManager;
}

- (UIColor *)calendarColor {
  return _currentCalendarColor;
}

- (UIColor *)calendarTintColor {
  return _currentCalendarColor;
}

- (UIColor *)gpxColor {
  return _currentGpxColor;
}

- (void)setContactColor:(UIColor *)contactColor {
  _currentContactColor = contactColor;
  [self styleBlockForType:self.downloadType];
}

- (void)setContactTintColor:(UIColor *)contactTintColor {
  _currentContactTintColor = contactTintColor;
  [self styleBlockForType:self.downloadType];
}

- (void)setCalendarColor:(UIColor *)calendarColor {
  _currentCalendarColor = calendarColor;
  [self styleBlockForType:self.downloadType];
}

- (void)setCalendarTintColor:(UIColor *)calendarTintColor {
  _currentCalendarTintColor = calendarTintColor;
  [self styleBlockForType:self.downloadType];
}

- (void)setGpxColor:(UIColor *)gpxColor {
  _currentGpxColor = gpxColor;
  [self styleBlockForType:self.downloadType];
}

- (void)setGpxTintColor:(UIColor *)gpxTintColor {
  _currentGpxTintColor = gpxTintColor;
  [self styleBlockForType:self.downloadType];
}
@end
