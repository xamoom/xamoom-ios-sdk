//
// Copyright 2015 by xamoom GmbH <apps@xamoom.com>
//
// This file is part of some open source application.
//
// Some open source application is free software: you can redistribute
// it and/or modify it under the terms of the GNU General Public
// License as published by the Free Software Foundation, either
// version 2 of the License, or (at your option) any later version.
//
// Some open source application is distributed in the hope that it will
// be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
// of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with xamoom-ios-sdk. If not, see <http://www.gnu.org/licenses/>.
//

#import "XMMContentBlock9TableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define MINIMUM_ZOOM_ARC 0.014
#define ANNOTATION_REGION_PAD_FACTOR 1.15
#define MAX_DEGREES_ARC 360

@interface XMMContentBlock9TableViewCell()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) NSString *currentContentID;
@property (nonatomic) XMMMapOverlayView *mapAdditionView;
@property (nonatomic) NSLayoutConstraint *mapAdditionViewBottomConstraint;
@property (nonatomic) NSLayoutConstraint *mapAdditionViewHeightConstraint;


@end

@implementation XMMContentBlock9TableViewCell

static UIColor *contentLinkColor;
static NSString *contentLanguage;
static bool showContentLinks;

- (void)awakeFromNib {
  // Initialization code
  self.clipsToBounds = YES;
  [self setupLocationManager];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

+ (UIColor *)linkColor {
  return contentLinkColor;
}

+ (void)setLinkColor:(UIColor *)linkColor {
  contentLinkColor = linkColor;
}

+ (BOOL)showContentLinks {
  return showContentLinks;
}

+ (void)setShowContentLinks:(BOOL)showLinks {
  showContentLinks = showLinks;
}

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath api:(XMMEnduserApi *)api {
  self.titleLabel.text = block.title;
  self.spotMapTags = [block.spotMapTags componentsJoinedByString:@","];
  [self getSpotMap:api];
  [self setupMapOverlayView];
}

- (void)setupMapView {
  self.mapView.delegate = self;
  self.mapView.showsUserLocation = YES;
  
}

- (void)setupLocationManager {
  //init up locationManager
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

- (void)setupMapOverlayView {
  NSBundle *bundle = [NSBundle bundleForClass:[self class]];
  NSURL *url = [bundle URLForResource:@"XamoomSDKNibs" withExtension:@"bundle"];
  NSBundle *nibBundle = [NSBundle bundleWithURL:url];
  self.mapAdditionView = [[nibBundle loadNibNamed:@"XMMMapOverlayView" owner:self options:nil] firstObject];
  
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
                                                                       constant:210];
  [self.contentView addConstraint:self.mapAdditionViewBottomConstraint];
  
  self.mapAdditionViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.mapAdditionView
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1
                                                                    constant:200];
  
  [self.mapAdditionView addConstraint:self.mapAdditionViewHeightConstraint];
}

- (void)getSpotMap:(XMMEnduserApi *)api {
  NSArray *spots = [[XMMContentBlocksCache sharedInstance] cachedSpotMap:self.spotMapTags];
  if (spots) {
    [self.loadingIndicator stopAnimating];
    [self setupMapView];
    [self showSpotMap:spots];
    return;
  }
  
  [api spotsWithTags:[self.spotMapTags componentsSeparatedByString:@","] pageSize:10 cursor:nil options:XMMSpotOptionsNone sort:XMMSpotSortOptionsNone completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
    [[XMMContentBlocksCache sharedInstance] saveSpotMap:spots key:self.spotMapTags];
    
    [self.loadingIndicator stopAnimating];
    [self setupMapView];
    [self showSpotMap:spots];
  }];
}

#pragma mark - XMMEnduser Delegate

- (void)showSpotMap:(NSArray *)spots {
  //get the customMarker for the map
  /*
   if (result.style.customMarker != nil) {
   [self mapMarkerFromBase64:result.style.customMarker];
   }
   */
  
  // Add annotations
  for (XMMSpot *item in spots) {
    XMMAnnotation *annotation = [[XMMAnnotation alloc] initWithLocation: CLLocationCoordinate2DMake(item.lat, item.lon)];
    annotation.data = item;
    
    //calculate
    CLLocation *annotationLocation = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
    CLLocationDistance distance = [self.locationManager.location distanceFromLocation:annotationLocation];
    annotation.distance = [NSString stringWithFormat:@"Entfernung: %d Meter", (int)distance];
    
    [self.mapView addAnnotation:annotation];
  }
  
  [self zoomMapViewToFitAnnotations:self.mapView animated:YES];
}

- (void)mapMarkerFromBase64:(NSString*)base64String {
  NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
  NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
  
  if ([decodedString containsString:@"data:image/svg"]) {
    //create svg need to DECODE TWO TIMES!
    decodedString = [decodedString stringByReplacingOccurrencesOfString:@"data:image/svg+xml;base64," withString:@""];
    NSData *decodedData2 = [[NSData alloc] initWithBase64EncodedString:decodedString options:0];
    NSString *decodedString2 = [[NSString alloc] initWithData:decodedData2 encoding:NSUTF8StringEncoding];
    //self.customMapMarker= [SVGKImage imageWithSource:[SVGKSourceString sourceFromContentsOfString:decodedString2]].UIImage; //TODO
  } else {
    //create UIImage
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:decodedString]];
    self.customMapMarker = [UIImage imageWithData:imageData];
  }
  
  //self.customMapMarker = [self imageWithImage:self.customMapMarker scaledToMaxWidth:30.0f maxHeight:30.0f];
}

- (void)openContentTapped {
  NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.currentContentID forKey:@"contentID"];
  [[NSNotificationCenter defaultCenter] postNotificationName:[XMMContentBlocks kContentBlock9MapContentLinkNotification] object:nil userInfo:userInfo];
}

#pragma mark MKMapView delegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
  //do not touch userLocation
  if ([annotation isKindOfClass:[MKUserLocation class]]) {
    return nil;
  }
  
  if ([annotation isKindOfClass:[XMMAnnotation class]]) {
    static NSString *identifier = @"xamoomAnnotation";
    MKAnnotationView *annotationView;
    if (annotationView == nil) {
      annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
      annotationView.enabled = YES;
      annotationView.canShowCallout = YES;
      
      //set mapmarker
      if(self.customMapMarker) {
        annotationView.image = self.customMapMarker;
      } else {
        annotationView.image = [UIImage imageNamed:@"mappoint"];
      }
    } else {
      annotationView.annotation = annotation;
    }
    return annotationView;
  }
  
  return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)annotationView {
  if ([annotationView isKindOfClass:[MKAnnotationView class]]) {
    XMMAnnotation *annotation =  annotationView.annotation;
    [self openMapAdditionView:annotation];
  }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)annotationView {
  if ([annotationView isKindOfClass:[MKAnnotationView class]]) {
    [self closeMapAdditionView];
  }
}

#pragma mark - Custom Methods

- (void)openMapAdditionView:(XMMAnnotation *)annotation {
  [self.mapAdditionView displayAnnotation:annotation];
  
  [self.contentView layoutIfNeeded];
  self.mapAdditionViewBottomConstraint.constant = 0;
  [UIView animateWithDuration:0.3 animations:^{
    [self.contentView layoutIfNeeded];
  }];
}

- (void)closeMapAdditionView {
  [self.contentView layoutIfNeeded];
  self.mapAdditionViewBottomConstraint.constant = 210;
  [UIView animateWithDuration:0.3 animations:^{
    [self.contentView layoutIfNeeded];
  }];
}

//size the mapView region to fit its annotations
- (void)zoomMapViewToFitAnnotations:(MKMapView *)mapView animated:(BOOL)animated {
  NSArray *annotations = mapView.annotations;
  int count = (int)[self.mapView.annotations count];
  if ( count == 0) { return; } //bail if no annotations
  
  //convert NSArray of id <MKAnnotation> into an MKCoordinateRegion that can be used to set the map size
  //can't use NSArray with MKMapPoint because MKMapPoint is not an id
  MKMapPoint points[count]; //C array of MKMapPoint struct
  for( int i=0; i<count; i++ ) //load points C array by converting coordinates to points
  {
    CLLocationCoordinate2D coordinate = [(id <MKAnnotation>)annotations[i] coordinate];
    points[i] = MKMapPointForCoordinate(coordinate);
  }
  //create MKMapRect from array of MKMapPoint
  MKMapRect mapRect = [[MKPolygon polygonWithPoints:points count:count] boundingMapRect];
  //convert MKCoordinateRegion from MKMapRect
  MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
  
  //add padding so pins aren't scrunched on the edges
  region.span.latitudeDelta  *= ANNOTATION_REGION_PAD_FACTOR;
  region.span.longitudeDelta *= ANNOTATION_REGION_PAD_FACTOR;
  //but padding can't be bigger than the world
  if( region.span.latitudeDelta > MAX_DEGREES_ARC ) { region.span.latitudeDelta  = MAX_DEGREES_ARC; }
  if( region.span.longitudeDelta > MAX_DEGREES_ARC ){ region.span.longitudeDelta = MAX_DEGREES_ARC; }
  
  //and don't zoom in stupid-close on small samples
  if( region.span.latitudeDelta  < MINIMUM_ZOOM_ARC ) { region.span.latitudeDelta  = MINIMUM_ZOOM_ARC; }
  if( region.span.longitudeDelta < MINIMUM_ZOOM_ARC ) { region.span.longitudeDelta = MINIMUM_ZOOM_ARC; }
  //and if there is a sample of 1 we want the max zoom-in instead of max zoom-out
  if( count == 1 )
  {
    region.span.latitudeDelta = MINIMUM_ZOOM_ARC;
    region.span.longitudeDelta = MINIMUM_ZOOM_ARC;
  }
  [mapView setRegion:region animated:animated];
}

@end
