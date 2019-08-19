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
  _mapView.delegate = self;
}

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style api:(XMMEnduserApi *)api offline:(BOOL)offline {
  
  if (![tableView.indexPathsForVisibleRows containsObject:indexPath]) {
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
  NSArray *spots = [[XMMContentBlocksCache sharedInstance] cachedSpotMap:[spotMapTags componentsJoinedByString:@","]];
  if (spots) {
    
    XMMSpot *spot = spots.firstObject;
    if (self.didLoadStyle == NO) {
      [self getStyleWithId:spot.system.ID api:api spots: spots];
    } else {
      [self showSpotMap:spots];
    }
    return;
  }
  
  self.spots = [[NSMutableArray alloc] init];
  [self downloadAllSpotsWithSpots:spotMapTags cursor:nil api:api completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
    if (self.didLoadStyle == NO && spots.count > 0) {
      XMMSpot *spot = spots.firstObject;
      [self getStyleWithId:spot.system.ID api:api spots:spots];
    } else if (spots.count > 0) {
      [self showSpotMap:spots];
    }
  }];
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
    
    [self.spots arrayByAddingObjectsFromArray:spots];
    
    if (hasMore) {
      [self downloadAllSpotsWithSpots:tags cursor:cursor api:api completion:completion];
    } else {
      completion(spots, false, nil, nil);
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
      
      XMMAnnotation *anno = [[XMMAnnotation alloc] initWithLocation:CLLocationCoordinate2DMake(spot.latitude + 0.00003, spot.longitude)];
      anno.spot = spot;
      
      //calculate
      
      CLLocation *annotationLocation = [[CLLocation alloc] initWithLatitude:spot.latitude longitude:spot.longitude];
      CLLocationDistance distance = [self.locationManager.location distanceFromLocation:annotationLocation];
      if (distance < 1000) {
        anno.distance = [NSString stringWithFormat:@"%@: %d m", NSLocalizedStringFromTableInBundle(@"Distance", @"Localizable", self.bundle, nil), (int)distance];
      } else {
        anno.distance = [NSString stringWithFormat:@"%@: %0.1f km", NSLocalizedStringFromTableInBundle(@"Distance", @"Localizable", self.bundle, nil), distance/1000];
      }
      
      [annotations addObject:anno];
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
      [_mapView addAnnotations:annotations];
      //[self zoomMapViewToFitAnnotations:self.mapView animated:YES];
      [_mapView showAnnotations:annotations animated:YES];
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
  
  self.mapAdditionView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.contentView addSubview:self.mapAdditionView];
  
  [self.contentView addConstraint:
   [NSLayoutConstraint constraintWithItem:self.mapAdditionView
                                attribute:NSLayoutAttributeLeading
                                relatedBy:NSLayoutRelationEqual
                                   toItem:self.contentView
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
                                                                       constant:self.mapView.bounds.size.height/2];
  
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
                      zoomLevel:_mapView.maximumZoomLevel
                       animated:YES];
}

- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id<MGLAnnotation>)annotation {
  MGLAnnotationImage *annotationImage = [mapView dequeueReusableAnnotationImageWithIdentifier:@"whatever"];
  
  if (!annotationImage){
    UIImage *image = [UIImage imageNamed:@"default_marker"];
    image = [self resizeImage:image width:23];

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

@end
