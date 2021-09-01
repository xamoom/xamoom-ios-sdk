//
//  XMMContentBlock9TableViewCell.m
//  XamoomSDK
//
//  Created by Thomas Krainz-Mischitz on 05.02.19.
//  Copyright © 2019 xamoom GmbH. All rights reserved.
//

#import "XMMContentBlock9TableViewCell.h"

@interface XMMContentBlock9TableViewCell()

@property (nonatomic, strong) NSBundle *bundle;
@property (nonatomic, strong) NSString *currentContentID;
@property (nonatomic) bool showContent;
@property (nonatomic) bool didLoadStyle;
@property (nonatomic, strong) NSMutableArray *spots;
@property (nonatomic, strong) NSMutableArray *downloadedSpots;
@property (nonatomic, strong) CLLocation *userLocation;
@property (nonatomic) bool isLocationGranted;
@end

@implementation XMMContentBlock9TableViewCell
static UIColor *kContentLinkColor;
static NSString *kContentLanguage;
static int kPageSize = 100;

- (void)awakeFromNib {
    [super awakeFromNib];
  
  NSBundle *bundle = [NSBundle bundleForClass:[self class]];
  NSURL *url = [bundle URLForResource:@"XamoomSDK" withExtension:@"bundle"];
  if (url != nil) {
    self.bundle = [NSBundle bundleWithURL:url];
  } else {
    self.bundle = bundle;
  }
  
  [self setupLocationManager];
  [self setupMapOverlayView];
  
  self.mapViewHeightConstraint.constant = [UIScreen mainScreen].bounds.size.width - 50;
  [_mapView setMaximumZoomLevel:17.4];
  [_mapView setPitchEnabled:true];
  [_mapView setAllowsTilting:false];
  _mapView.delegate = self;
    
  UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
  [self.mapView addGestureRecognizer:panGestureRecognizer];
    panGestureRecognizer.minimumNumberOfTouches = 1;
    panGestureRecognizer.maximumNumberOfTouches = 1;
    UIViewController *activeVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    panGestureRecognizer.delegate = activeVC;
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateLocationWithNotification:) name:@"LocationUpdateNotification" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateUserLocationButtonIcon:) name:UIApplicationWillEnterForegroundNotification object:nil];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *lang = [userDefaults stringForKey:@"language"];
    self.bundle = [NSBundle bundleWithPath:[[NSBundle bundleWithURL:url] pathForResource:lang ofType:@"lproj"]];
}

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style api:(XMMEnduserApi *)api offline:(BOOL)offline {
  

  if (![tableView.indexPathsForVisibleRows containsObject:indexPath] || self.spots.count > 0) {
    return;
  } else {
    _mapView.styleURL = _mapboxStyle;
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(40.7326808, -73.9843407)
                        zoomLevel:1
                         animated:NO];
    
    self.titleView.text = block.title;
    self.showContent = block.showContent;
    [self getSpotMap:api spotMapTags:block.spotMapTags];
  }
}

- (void)setupLocationManager {
  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.delegate = self;
  self.locationManager.distanceFilter = 100.0f; //meter
  self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  self.locationManager.activityType = CLActivityTypeOther;
  
  // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
  if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
    [self.locationManager requestWhenInUseAuthorization];
  }
}

- (void)getSpotMap:(XMMEnduserApi *)api spotMapTags:(NSArray *)spotMapTags {
  NSArray *loadedSpots = [[XMMContentBlocksCache sharedInstance] cachedSpotMap:[spotMapTags componentsJoinedByString:@","]];
  if (loadedSpots) {
    [self.spots addObjectsFromArray:loadedSpots];
    XMMSpot *spot = self.spots.firstObject;
    if (self.didLoadStyle == NO) {
      [self getStyleWithId:spot.system.ID api:api spots: self.spots];
    } else {
      [self showSpotMap:self.spots];
    }
    return;
  }
  
  self.spots = [[NSMutableArray alloc] init];
  self.downloadedSpots = [[NSMutableArray alloc] init];
    
  [self downloadAllSpotsWithSpots:spotMapTags cursor:nil api:api completion:^(NSArray *loadedSpots, bool hasMore, NSString *cursor, NSError *error) {
    if (self.didLoadStyle == NO && loadedSpots.count > 0) {
      [self.spots addObjectsFromArray:loadedSpots];
      XMMSpot *spot = self.spots.firstObject;
      [self getStyleWithId:spot.system.ID api:api spots:self.spots];
    } else if (loadedSpots.count > 0) {
      [self.spots addObjectsFromArray:loadedSpots];
      [self showSpotMap:self.spots];
    }
  }];
  [self didUpdateUserLocationButtonIcon:nil];
}

- (void)downloadAllSpotsWithSpots:(NSArray *)tags cursor:(NSString *)cursor api:(XMMEnduserApi *)api completion:(void (^)(NSArray *spots, bool hasMore, NSString *cursor, NSError *error))completion {
  NSUInteger options = XMMSpotOptionsWithLocation;
  if (self.showContent) {
    options = options|XMMSpotOptionsIncludeContent;
  }
  
  [api spotsWithTags:tags pageSize:kPageSize cursor:cursor options:options sort:0 completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
    if (error != nil) {
      completion(nil, false, nil, error);
    }
    
    [self.downloadedSpots addObjectsFromArray:spots];
      
    if (hasMore) {
      [self downloadAllSpotsWithSpots:tags cursor:cursor api:api completion:completion];
    } else {
        [self.downloadedSpots setArray:[[NSSet setWithArray:self.downloadedSpots] allObjects]];
      completion(self.downloadedSpots, false, nil, nil);
    }
  }];
}

- (void)getStyleWithId:(NSString *)systemId api:(XMMEnduserApi *)api spots:(NSArray *)spots {
  [api styleWithID:systemId completion:^(XMMStyle *style, NSError *error) {
    self.didLoadStyle = YES;
    [self mapMarkerFromBase64:style.customMarker];
    [self showSpotMap:spots];
   // [self getSpotMap:api spotMapTags:spotMapTags]; // reloads data to use custom marker
  }];
}

- (void)showSpotMap:(NSArray *)spots {
  // Add annotations
  if (_mapView.annotations != nil) {
    [_mapView removeAnnotations:_mapView.annotations];
  }
  
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
  dispatch_async(queue, ^{
    
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    for (XMMSpot *spot in spots) {
      NSString *annotationTitle = nil;
      if (spot.name != nil && ![spot.name isEqualToString:@""]) {
        annotationTitle = spot.name;
      } else {
        annotationTitle = @"Spot";
      }
      
      XMMAnnotation *anno = [[XMMAnnotation alloc] initWithLocation:CLLocationCoordinate2DMake(spot.latitude, spot.longitude)];
      anno.spot = spot;
      [annotations addObject:anno];
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
      [self.mapView addAnnotations:annotations];
      [self zoomMapViewToFitAnnotations];
    });
  });
}

- (void)mapMarkerFromBase64:(NSString*)base64String {
  if ([base64String containsString:@"data:image/svg"]) {
    base64String = [base64String stringByReplacingOccurrencesOfString:@"data:image/svg+xml;base64," withString:@""];
    NSData *decodedData2 = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    self.customMapMarker= [JAMSVGImage imageWithSVGData:decodedData2].image;
  } else {
    //create UIImage
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:base64String]];
    self.customMapMarker = [UIImage imageWithData:imageData];
  }
  
  self.customMapMarker = [self resizeImage:self.customMapMarker width:23];
}
  
  - (UIImage*)resizeImage:(UIImage*)image width:(CGFloat)width {
    CGSize size = image.size;
    double imageRatio = size.width / size.height;
    double newHeight = width / imageRatio;
    CGSize newSize = CGSizeMake(width, newHeight);
    CGRect rect = CGRectMake(0, 0, newSize.width, newSize.height);
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    [image drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
  }

- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation {
  return YES;
}

- (void)setupMapOverlayView {
  self.mapAdditionView = [[self.bundle loadNibNamed:@"XMMMapOverlayView" owner:self options:nil] firstObject];
  [self.contentView addSubview:self.mapAdditionView];

  self.mapAdditionView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.contentView addSubview:self.mapAdditionView];
  
  [self.contentView addConstraint:
   [NSLayoutConstraint constraintWithItem:self.mapAdditionView
                                attribute:NSLayoutAttributeLeading
                                relatedBy:NSLayoutRelationEqual
                                   toItem:self.mapView
                                attribute:NSLayoutAttributeLeading
                               multiplier:1
                                 constant:0]];
  
  [self.contentView addConstraint:
   [NSLayoutConstraint constraintWithItem:self.mapAdditionView
                                attribute:NSLayoutAttributeTrailing
                                relatedBy:NSLayoutRelationEqual
                                   toItem:self.mapView
                                attribute:NSLayoutAttributeTrailing
                               multiplier:1
                                 constant:0]];
  
  self.mapAdditionViewBottomConstraint = [NSLayoutConstraint constraintWithItem:self.mapAdditionView
                                                                      attribute:NSLayoutAttributeBottom
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.mapView
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1
                                                                       constant:self.mapView.bounds.size.height/2 + 10];
  [self.contentView addConstraint:self.mapAdditionViewBottomConstraint];
  
  self.mapAdditionViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.mapAdditionView
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1
                                                                       constant:([UIScreen mainScreen].bounds.size.width - 8 * 2) / 2];
  
  [self.mapAdditionView addConstraint:self.mapAdditionViewHeightConstraint];
  [self.mapAdditionView setHidden:YES];
}

- (void)openMapAdditionView:(XMMAnnotation *)annotation {
  [self.mapAdditionView displayAnnotation:annotation showContent:self.showContent navigationType:self.navigationType];
  [self.mapAdditionView setHidden:NO];

  [self.contentView layoutIfNeeded];
  self.mapAdditionViewBottomConstraint.constant = 0;
  [UIView animateWithDuration:0.3 animations:^{
    [self.contentView layoutIfNeeded];
  }];
}

- (void)closeMapAdditionView {
  [self.contentView layoutIfNeeded];
  [self.mapAdditionView setHidden:YES];
  self.mapAdditionViewBottomConstraint.constant = self.mapAdditionViewHeightConstraint.constant + 10;
  [UIView animateWithDuration:0.3 animations:^{
    [self.contentView layoutIfNeeded];
  }];
}

- (void)zoomToAnnotationWithAdditionView:(XMMAnnotation *)annotation {
  
  double a = annotation.coordinate.latitude;
  double d = a - 0.0002;
  
  if (d < -90) {
    d = -90;
  } else if (d > 90) {
    d = 90;
  }
  
  [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(d, annotation.coordinate.longitude)
                      zoomLevel:16.0
                       animated:YES];
}

- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id<MGLAnnotation>)annotation {
  MGLAnnotationImage *annotationImage = [mapView dequeueReusableAnnotationImageWithIdentifier:@"whatever"];
  
  if (!annotationImage){
    UIImage *image = [UIImage imageNamed:@"default_marker"];
    image = [self resizeImage:image width:20];

    if (self.customMapMarker != nil) {
      image = self.customMapMarker;
    }
    
    annotationImage = [MGLAnnotationImage annotationImageWithImage:image reuseIdentifier:@"whatever"];
  }
  
  return annotationImage;
}

- (void)mapView:(MGLMapView *)mapView didSelectAnnotation:(id<MGLAnnotation>)annotation {
  if ([annotation isKindOfClass:[XMMAnnotation class]]) {
    [self zoomToAnnotationWithAdditionView:annotation];
    [self openMapAdditionView:annotation];
  }
}

- (void)mapView:(MGLMapView *)mapView didDeselectAnnotation:(id<MGLAnnotation>)annotation {
  if ([annotation isKindOfClass:[XMMAnnotation class]]) {
    [self closeMapAdditionView];
  }
}

- (void)didUpdateLocationWithNotification:(NSNotification *)notification {
  _userLocation = notification.userInfo[@"location"];
  
  _mapView.showsUserLocation = NO;

  if (_userLocation != nil) {
    _mapView.showsUserLocation = YES;
    [self didUpdateUserLocationButtonIcon:nil];
  }
}

- (void)didUpdateUserLocationButtonIcon:(NSNotification *)notification {
  _isLocationGranted = ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways ||
                        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse);
  
  UIColor *imageColor = [UIColor blackColor];
  
  _userLocation = _mapView.userLocation;
  
  if (!_isLocationGranted || _userLocation == nil) {
    imageColor = [UIColor grayColor];
  }
  
  UIImage *image = [UIImage imageNamed:@"ic_user_location"];
  CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextClipToMask(context, rect, image.CGImage);
  CGContextSetFillColorWithColor(context, [imageColor CGColor]);
  CGContextFillRect(context, rect);
  UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  [_centerUserLocationButton setImage:img forState:UIControlStateNormal];
}

- (IBAction)centerUserButtonAction:(id)sender {
  [self closeMapAdditionView];

  NSBundle *bundle = [NSBundle bundleForClass:[self class]];
  NSURL *url = [bundle URLForResource:@"XamoomSDK" withExtension:@"bundle"];
  NSBundle *libBundle;
  if (url != nil) {
    libBundle = [NSBundle bundleWithURL:url];
  } else {
    libBundle = bundle;
  }
  
  if (![CLLocationManager locationServicesEnabled] || !_isLocationGranted) {
    // Show altert for settings
    dispatch_async(dispatch_get_main_queue(), ^{
      UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTableInBundle(@"contentblock9.no.permission.title", @"Localizable", libBundle, nil)  message:NSLocalizedStringFromTableInBundle(@"contentblock9.no.permission.message", @"Localizable", libBundle, nil)  preferredStyle:UIAlertControllerStyleAlert];
      
      [alert addAction: [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"contentblock9.alert.settings", @"Localizable", libBundle, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self openSettings];
      }]];
      [alert addAction: [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"contentblock9.alert.cancel", @"Localizable", libBundle, nil) style:UIAlertActionStyleCancel handler:nil]];
      
      UIViewController *parentViewController = self.window.rootViewController;
      if (parentViewController != nil) {
        [parentViewController presentViewController:alert animated:YES completion:nil];
      }
    });
    
    return;
  }
  
  if (_userLocation == nil) {
    dispatch_async(dispatch_get_main_queue(), ^{
      UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTableInBundle(@"contentblock9.no.location.title", @"Localizable", libBundle, nil)  message:NSLocalizedStringFromTableInBundle(@"contentblock9.no.location.message", @"Localizable", libBundle, nil)  preferredStyle:UIAlertControllerStyleAlert];
      
      [alert addAction: [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"contentblock9.alert.settings", @"Localizable", libBundle, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self openSettings];
      }]];
      [alert addAction: [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"contentblock9.alert.cancel", @"Localizable", libBundle, nil) style:UIAlertActionStyleCancel handler:nil]];
      
      UIViewController *parentViewController = self.window.rootViewController;
      if (parentViewController != nil) {
        [parentViewController presentViewController:alert animated:YES completion:nil];
      }
    });
    
    return;
  }
  
  CLLocationCoordinate2D userCoordinates = _userLocation.coordinate;
  [self.mapView setCenterCoordinate:userCoordinates zoomLevel:16.0 animated:YES];
}

- (IBAction)centerSpotBoundsAction:(id)sender {
  [self showSpotMap:self.spots];
}

- (void)openSettings {
  NSURL *url = [[NSURL alloc] initWithString: UIApplicationOpenSettingsURLString];
  if (url != nil) {
    [[UIApplication sharedApplication] openURL:url];
  }
}

- (void)zoomMapViewToFitAnnotations {
  NSMutableArray *latArray = [NSMutableArray new];
  NSMutableArray *lonArray = [NSMutableArray new];
  
  for (XMMSpot *location in self.spots) {
    [latArray addObject:[NSNumber numberWithDouble:location.latitude]];
    [lonArray addObject:[NSNumber numberWithDouble:location.longitude]];
  }
  
  if (latArray.count == 0 || lonArray.count == 0) {
    if (_userLocation != nil) {
      [self centerUserButtonAction:nil];
    }
    return;
  }

  float maxLat = [[latArray valueForKeyPath:@"@max.floatValue"] floatValue];
  float minLat = [[latArray valueForKeyPath:@"@min.floatValue"] floatValue];
  float maxLon = [[lonArray valueForKeyPath:@"@max.floatValue"] floatValue];
  float minLon = [[lonArray valueForKeyPath:@"@min.floatValue"] floatValue];

  CGSize mapMarkerSize = self.customMapMarker.size;
  double latOffset = [self getDegreeOffsetForMarkerWithMax:maxLat min:minLat markerLength:mapMarkerSize.height];
  double lonOffset = [self getDegreeOffsetForMarkerWithMax:maxLon min:minLon markerLength:mapMarkerSize.width];

  CLLocationCoordinate2D ne = CLLocationCoordinate2DMake(minLat - latOffset, minLon - lonOffset);
  CLLocationCoordinate2D sw = CLLocationCoordinate2DMake(maxLat + latOffset, maxLon + lonOffset);
  
  MGLCoordinateBounds bounds = MGLCoordinateBoundsMake(sw, ne);
  self.mapView.visibleCoordinateBounds = bounds;
}

-(float)getDegreeOffsetForMarkerWithMax:(float)max min:(float)min markerLength:(float)markerLength {
  float mapWidth = self.mapView.frame.size.width;
  float widthDegrees = max-min;
  float degreesPerPixel = widthDegrees / mapWidth;
  return degreesPerPixel * markerLength;
}

- (void) handleTapFrom: (UIPanGestureRecognizer *)recognizer {
    if (recognizer.numberOfTouches == 1) {
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            
            self.overlayTitle.textColor = UIColor.whiteColor;
            self.overlayTitle.text = NSLocalizedStringFromTableInBundle(@"mapbox.two.fingers.move.label", @"Localizable", self.bundle, nil);
            self.overlayView.hidden = false;
        }
        if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
            self.overlayView.hidden = true;
        }
    } else {
        self.overlayView.hidden = true;
    }
}
@end
