//
//  XMMContentBlock14TableViewCell.m
//  XamoomSDK
//
//  Created by Vladyslav Cherednichenko
//  Copyright © 2020 xamoom GmbH. All rights reserved.
//

#import "XMMContentBlock14TableViewCell.h"
#import <CoreLocation/CoreLocation.h>

@interface XMMContentBlock14TableViewCell()

@property (nonatomic, strong) NSBundle *bundle;
@property (nonatomic, strong) NSString *currentContentID;
@property (nonatomic) bool showContent;
@property (nonatomic) bool didLoadStyle;
@property (nonatomic, strong) NSMutableArray *spots;
@property (nonatomic, strong) CLLocation *userLocation;
@property (nonatomic) bool isLocationGranted;
@property (nonatomic) double scaleX;
@property (nonatomic, strong) NSMutableArray *graphCoordinates;
@property (nonatomic, strong) NSString *tourGeoJsonUrl;
@property (nonatomic, strong) NSData *tourGeoJsonData;
@property (nonatomic) bool isInfoShown;
@property (nonatomic) bool isCurrentmetric;
@property (nonatomic) NSString *infoTitleFromReponse;
@property (nonatomic) NSString *routeSpentTime;
@property (nonatomic) double descentFeet;
@property (nonatomic) double descentMetres;
@property (nonatomic) double ascentFeet;
@property (nonatomic) double ascentMetres;
@property (nonatomic) double imperialTotalDistance;
@property (nonatomic) double metricTotalDistance;
@property (nonatomic, strong) NSMutableArray *imperialYElements;
@property (nonatomic, strong) NSMutableArray *imperialXElements;
@property (nonatomic, strong) NSMutableArray *metricYElements;
@property (nonatomic, strong) NSMutableArray *metricXElements;
@property (nonatomic) UIColor *currentRouteColor;

@end

@implementation XMMContentBlock14TableViewCell
static UIColor *kContentLinkColor;
static NSString *kContentLanguage;
static int kPageSize = 100;
static NSString *activeElevationButtonBackground = @"#2371D1";
static const NSString *markersSourceIdentifier = @"markersSourceIdentifier";
static const NSString *markersLayerIdentifier = @"markersLayerIdentifier";
static const NSString *routeLayerIdentifier = @"polyline";



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
  self.isInfoShown = NO;
  self.isCurrentmetric = YES;
  if(![[NSUserDefaults standardUserDefaults] stringForKey:@"template_primaryColor"]) {
      _currentRouteColor = [UIColor colorWithHexString:@"7401df"];
  } else {
      NSLog(@"template color is %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"template_primaryColor"]);
      _currentRouteColor = [[NSUserDefaults standardUserDefaults] stringForKey:@"template_primaryColor"];
  }

  
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
  
  
  [self.contentView addConstraints:@[
    [NSLayoutConstraint constraintWithItem: self.mapView.attributionButton attribute: NSLayoutAttributeWidth relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeWidth multiplier: 1.0 constant: 22],
    [NSLayoutConstraint constraintWithItem: self.mapView.attributionButton attribute: NSLayoutAttributeHeight relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeHeight multiplier: 1.0 constant: 22],
    [NSLayoutConstraint constraintWithItem: self.mapView.attributionButton attribute: NSLayoutAttributeLeft relatedBy: NSLayoutRelationEqual toItem: self.mapView attribute: NSLayoutAttributeLeft multiplier: 1.0 constant: 7],
    [NSLayoutConstraint constraintWithItem: self.mapView.attributionButton attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: self.mapView attribute: NSLayoutAttributeBottom multiplier: 1.0 constant: -30],
  ]];
  
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateLocationWithNotification:) name:@"LocationUpdateNotification" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateUserLocationButtonIcon:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleMapTap:)];
    for (UIGestureRecognizer *recognizer in self.mapView.gestureRecognizers) {
        if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            [singleTap requireGestureRecognizerToFail:recognizer];
        }
    }
    [self.mapView addGestureRecognizer:singleTap];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *lang = [userDefaults stringForKey:@"language"];
    self.bundle = [NSBundle bundleWithPath:[[NSBundle bundleWithURL:url] pathForResource:lang ofType:@"lproj"]];
}

- (void) setButtonsParams {
    self.imperialButton.layer.cornerRadius = 5;
    self.imperialButton.layer.borderWidth = 1;
    self.imperialButton.layer.borderColor = CFBridgingRetain([UIColor whiteColor]);
    self.metricButton.layer.cornerRadius = 5;
    self.metricButton.layer.borderWidth = 1;
    self.metricButton.layer.borderColor = CFBridgingRetain([UIColor whiteColor]);
    self.infoButton.layer.cornerRadius = 15;
    self.infoDistance.adjustsFontSizeToFitWidth = true;
    self.infoAscent.adjustsFontSizeToFitWidth = true;
    self.infoDescent.adjustsFontSizeToFitWidth = true;
    self.infoTime.adjustsFontSizeToFitWidth = true;
    
}

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style api:(XMMEnduserApi *)api offline:(BOOL)offline {
  
    _mapView.styleURL = _mapboxStyle;
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(40.7326808, -73.9843407)
                        zoomLevel:1
                         animated:NO];
      self.lineChartView.chartTitle = NSLocalizedStringFromTableInBundle(@"contentblock14.eleavationChart", @"Localizable", self.bundle, nil);;
    
    self.graphCoordinates = [NSMutableArray new];
    self.metricXElements = [NSMutableArray new];
    self.metricYElements = [NSMutableArray new];
    self.imperialXElements = [NSMutableArray new];
    self.imperialYElements = [NSMutableArray new];
    [self setButtonsParams];
    self.tourGeoJsonUrl = block.fileID;
    self.scaleX = block.scaleX;
    self.titleView.text = block.title;
    self.showContent = true;
    [self calculateCoordinates:block.fileID showGraph:block.showElevation];
    [self getSpotMap:api spotMapTags:block.spotMapTags];
}


- (IBAction)onZoomInButtonClick:(UIButton *)sender {
    [self.mapView setCenterCoordinate:self.mapView.centerCoordinate zoomLevel:self.mapView.zoomLevel + 1 animated:YES];
}

- (IBAction)onZoomOutButtonClick:(UIButton *)sender {
    [self.mapView setCenterCoordinate:self.mapView.centerCoordinate zoomLevel:self.mapView.zoomLevel - 1 animated:YES];
}

- (IBAction)handleMapTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {


        NSArray *layerIdentifiers = @[markersLayerIdentifier];

        CGPoint point = [sender locationInView:sender.view];
        for (id feature in [self.mapView visibleFeaturesAtPoint:point inStyleLayersWithIdentifiers:[NSSet setWithArray:layerIdentifiers]]) {
            if ([feature isKindOfClass:[MGLPointFeature class]]) {
                MGLPointFeature *selectedFeature = (MGLPointFeature *) feature;
                NSString *featureTitle = (NSString *) [selectedFeature.attributes objectForKey:@"title"];
                for(XMMSpot *spot in self.spots) {
                    if([spot.name isEqualToString:featureTitle]) {
                        NSLog(@"");
                        XMMAnnotation *annotation = [[XMMAnnotation alloc] initWithLocation:CLLocationCoordinate2DMake(spot.latitude, spot.longitude)];
                        annotation.spot = spot;
                        [self zoomToAnnotationWithAdditionView:annotation];
                        [self openMapAdditionView:annotation];
                    }
                }

                return;
            }
        }

        [self closeMapAdditionView];
    }
}



- (UIColor *)colorFromHexString:(NSString *)hexString alpha: (double) alpha {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:alpha];
}

- (void)drawPolyline:(NSData *)geoJson {
  
    if ([self.mapView.style sourceWithIdentifier:@"polyline"] != nil) return;
  
    MGLShape *shape = [MGLShape shapeWithData:geoJson encoding:NSUTF8StringEncoding error:nil];
    MGLSource *source = [[MGLShapeSource alloc] initWithIdentifier:@"polyline" shape:shape options:nil];
    [self.mapView.style addSource:source];
    MGLLineStyleLayer *layer = [[MGLLineStyleLayer alloc] initWithIdentifier:routeLayerIdentifier source:source];
    layer.lineColor = [NSExpression expressionForConstantValue:[self colorFromHexString:_currentRouteColor alpha:1.0]];
    
    layer.lineWidth = [NSExpression expressionWithFormat:@"mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
    @{@5: @3, @10: @5}];
    [self.mapView.style addLayer:layer];
}

- (void) calculateCoordinates: (NSString *)url showGraph: (BOOL *)showElevationGraph{
    NSString *jsonString = [self getDataFrom:url];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e;
    bool showGraph = true;
    
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:nil error:&e];
    NSDictionary *firstFeature = [responseDictionary[@"features"] objectAtIndex:0];
    NSDictionary *geometry = firstFeature[@"geometry"];
    
    self.infoTitleFromReponse = firstFeature[@"properties"][@"name"];
    
    NSArray *coordinates = geometry[@"coordinates"];
    
    
    double distanceMetric = 0.0;
    double distanceImperial = 0.0;
    
    double previousLtd = 0.0;
    double previousLong = 0.0;
    
    double previoudAltitudeMetres = 0.0;
    self.ascentFeet = 0.0;
    self.ascentMetres = 0.0;
    self.descentFeet = 0.0;
    self.descentMetres = 0.0;
    for(int i = 0; i < coordinates.count; i++){
        NSArray *coordinate = [coordinates objectAtIndex:i];
        
        double longitude = [[coordinate objectAtIndex:0] doubleValue];
        double latitude = [[coordinate objectAtIndex:1] doubleValue];
        NSLog(@"longitude %f latitude %f \n", longitude, latitude);
        [self.graphCoordinates addObject:[[CLLocation alloc] initWithLatitude:latitude longitude:longitude]];
        
        
        
        double altitude;
        double altitudeFeet;
        
        if(coordinate.count > 2) {
          altitude = [[coordinate objectAtIndex:2] doubleValue];
          altitudeFeet = altitude * 3.281;
        }
        else {
            showGraph = false;
            altitude = -100.0;
            altitudeFeet = -100.0;
        }
        if(i == 0) {
            if (self.tourGeoJsonUrl != nil) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSData *jsonData = [NSData dataWithContentsOfURL: [NSURL URLWithString: self.tourGeoJsonUrl]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                      self.tourGeoJsonData = jsonData;
                      [self drawPolyline: jsonData];
                        
                      MGLPointAnnotation *point = [[MGLPointAnnotation alloc] init];
                      point.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
                      
                      MGLShapeSource *shapeSource = [[MGLShapeSource alloc] initWithIdentifier:@"start-tour-source" shape:point options:nil];
                      MGLSymbolStyleLayer *shapeLayer = [[MGLSymbolStyleLayer alloc] initWithIdentifier:@"start-tour-layer-background" source:shapeSource];
                      
                      
                      [self.mapView.style setImage:[UIImage imageNamed:@"ic_route_begin"] forName:@"ic_start_tour"];
                      shapeLayer.iconImageName = [NSExpression expressionForConstantValue:@"ic_start_tour_foreground"];
                      shapeLayer.iconScale = [NSExpression expressionForConstantValue:[NSNumber numberWithFloat:0.1]];
                      
                      [self.mapView.style addSource:shapeSource];
                      [self.mapView.style addLayer:shapeLayer];
                    });
                });
            }
        }
        
        
        if(i != 0){
            double kilometres = [self getDistanceBetweenLocations:[[CLLocation alloc] initWithLatitude:previousLtd longitude:previousLong] :[[CLLocation alloc] initWithLatitude:latitude longitude:longitude]];
            distanceMetric += kilometres;
            distanceImperial += kilometres / 1.609344;
            if(altitude != -100.0 && altitudeFeet != -100.0) {
                if(altitude - previoudAltitudeMetres > 0) {
                    self.ascentMetres += altitude - previoudAltitudeMetres;
                    self.ascentFeet += altitudeFeet - previoudAltitudeMetres * 3.281;
                    NSLog(@"ascent alt prevAlt ascent %.2f %.2f %.2f\n", altitude, previoudAltitudeMetres, self.ascentMetres);
                } else if(previoudAltitudeMetres - altitude > 0){
                    self.descentMetres += previoudAltitudeMetres - altitude;
                    self.descentFeet += previoudAltitudeMetres * 3.281 - altitudeFeet;
                    NSLog(@"descent alt prevAlt ascent %.2f %.2f %.2f \n", altitude, previoudAltitudeMetres, self.descentMetres);
                }
            }
            
        }
        
        NSLog(@"x(dist) in kilomeres is %f", distanceMetric);
        NSLog(@"y(alt) in metres is %f", altitude);
        NSLog(@"x(dist) in miles is %f", distanceImperial);
        NSLog(@"y(alt) in feet is %f", altitudeFeet);
        
        previousLong = longitude;
        previousLtd = latitude;
        
        if(altitude != -100.0 && altitudeFeet    != -100.0) {
            [self.metricXElements addObject: [NSNumber numberWithDouble:distanceMetric]];
            [self.metricYElements addObject: [NSNumber numberWithDouble:altitude]];
            [self.imperialXElements addObject:[NSNumber numberWithDouble:distanceImperial]];
            [self.imperialYElements addObject: [NSNumber numberWithDouble:altitudeFeet]];
            previoudAltitudeMetres = altitude;
        }
    }
    
    self.metricTotalDistance = distanceMetric;
    self.imperialTotalDistance = distanceImperial;
    self.routeSpentTime = [self getTimeInHours:distanceImperial/1.86];
    
    NSLog(@"ascent metres&feet %f %f ", self.ascentMetres, self.ascentFeet);
    NSLog(@"descent metres%feet %f %f ", self.descentMetres, self.descentFeet);
    NSLog(@"total distance metres&feet %f %f ", self.metricTotalDistance, self.imperialTotalDistance);
    NSLog(@"spent time is %@", self.routeSpentTime);
    
    
    [self closeInfoAlertView];
    [self.metricButton setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal & UIControlStateSelected & UIControlStateHighlighted];
    self.metricButton.backgroundColor = [self colorFromHexString:activeElevationButtonBackground alpha:0.8];
    self.imperialButton.backgroundColor = [UIColor whiteColor];
    [self.imperialButton setTitleColor: [UIColor blackColor] forState:UIControlStateNormal & UIControlStateSelected & UIControlStateHighlighted];
    [self.lineChartView updateChartWithXElements:self.metricXElements yElements:self.metricYElements];
    self.isCurrentmetric = YES;
    [self setInfoValues];
    if(showElevationGraph && showGraph) {
        [self drawGraph];
    }
    
}

- (void) setInfoValues {
    self.infoTitle.text = self.infoTitleFromReponse;
    self.infoTime.text = self.routeSpentTime;
    self.infoDistanceDescription = NSLocalizedStringFromTableInBundle(@"contentblock14.distance", @"Localizable", self.bundle, nil);
    self.infoAscentDescentDescription = [NSString stringWithFormat:@"%@ | %@", NSLocalizedStringFromTableInBundle(@"contentblock14.ascent", @"Localizable", self.bundle, nil), NSLocalizedStringFromTableInBundle(@"contentblock14.descent", @"Localizable", self.bundle, nil)];
    if(self.isCurrentmetric) {
        self.infoDistance.text = [NSString stringWithFormat:@"%.2f km", self.metricTotalDistance];
        self.infoAscent.text = [NSString stringWithFormat:@"%d m", (int)self.ascentMetres];
        self.infoDescent.text = [NSString stringWithFormat:@"%d m", (int)self.descentMetres];
        self.infoTimeDescription.text = NSLocalizedStringFromTableInBundle(@"contentblock14.durationAtKm", @"Localizable", self.bundle, nil);
    } else {
        self.infoDistance.text = [NSString stringWithFormat:@"%.2f mi", self.imperialTotalDistance];
        self.infoAscent.text = [NSString stringWithFormat:@"%d ft", (int)self.ascentFeet];
        self.infoDescent.text = [NSString stringWithFormat:@"%d ft", (int)self.descentFeet];
        self.infoTimeDescription.text = NSLocalizedStringFromTableInBundle(@"contentblock14.durationAtM", @"Localizable", self.bundle, nil);
    }
}

- (NSString *) getTimeInHours: (double)timeInDec {
    NSNumber *doubleNumber = [NSNumber numberWithDouble:timeInDec];
    NSString *doubleAsString = [doubleNumber stringValue];
    NSRange dotIndex = [doubleAsString rangeOfString:@"."];
    NSString *wholePart = [doubleAsString substringToIndex:dotIndex.location];
    NSInteger wholePartNumber = [doubleNumber integerValue];
    NSString *fractionalPart = @"0";
    fractionalPart = [fractionalPart stringByAppendingString:[doubleAsString substringFromIndex:dotIndex.location]];
    fractionalPart = [fractionalPart substringToIndex:4];
    double fractionalDoubleMinutes = ceil([fractionalPart doubleValue] * 60);
    int fractionalMinutes = [[[NSNumber numberWithDouble:fractionalDoubleMinutes] stringValue] intValue];
    if (fractionalMinutes == 60) {
        fractionalMinutes = 0;
        wholePartNumber = wholePartNumber + 1;
        wholePart = [NSString stringWithFormat: @"%ld", (long)wholePartNumber];
        return [[wholePart stringByAppendingString: @":"] stringByAppendingString:@"00 h"];
    }
    NSString *result = [[[wholePart stringByAppendingString: @":"] stringByAppendingString:
                        [[NSNumber numberWithInt:fractionalMinutes] stringValue]]
                        stringByAppendingString:@" h"];
    return result;
    
}

- (void) drawGraph {
    [self.lineChartView setHidden:NO];
    [self.lineChartHeightConstraint setConstant:160.0];
    self.lineChartView.showSubtitle = NO;
    self.lineChartView.chartTitle = @"";
    self.lineChartView.chartLineColor = [UIColor colorWithHexString:_currentRouteColor];
    self.lineChartView.xElements = self.metricXElements;
    self.lineChartView.yElements = self.metricYElements;
    [self.lineChartView drawChart];
}

- (double) getDistanceBetweenLocations:(CLLocation *) locA :(CLLocation *) locB {
    CLLocationDistance distanceMetres = [locA distanceFromLocation:locB];
    NSString *distanceStringKilometres = [[NSString alloc] initWithFormat: @"%f", distanceMetres / 1000.0];
    return [distanceStringKilometres doubleValue];
}

- (IBAction)onMetricButtonClick:(UIButton *)sender {
    [self.metricButton setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal & UIControlStateSelected & UIControlStateHighlighted];
    self.metricButton.backgroundColor = [self colorFromHexString:activeElevationButtonBackground alpha:0.8];
    self.imperialButton.backgroundColor = [UIColor whiteColor];
    [self.imperialButton setTitleColor: [UIColor blackColor] forState:UIControlStateNormal & UIControlStateSelected & UIControlStateHighlighted];
    [self.lineChartView updateChartWithXElements:self.metricXElements yElements:self.metricYElements];
    self.isCurrentmetric = YES;
    [self setInfoValues];
}


- (IBAction)onImperialButtonClick:(UIButton *)sender {
    [self.imperialButton setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal & UIControlStateSelected & UIControlStateHighlighted];
    self.imperialButton.backgroundColor = [self colorFromHexString:activeElevationButtonBackground alpha:0.8];
    [self.metricButton setTitleColor: [UIColor blackColor] forState:UIControlStateNormal & UIControlStateSelected & UIControlStateHighlighted];
    self.metricButton.backgroundColor = [UIColor whiteColor];
    [self.lineChartView updateChartWithXElements:self.imperialXElements yElements:self.imperialYElements];
   self.isCurrentmetric = NO;
    [self setInfoValues];
}

- (IBAction)onInfoButtonClick:(UIButton *)sender {
    if(!self.isInfoShown) {
        [self showInfoAlertView];
        self.isInfoShown = YES;
    } else {
        [self closeInfoAlertView];
    }
}

- (NSData *) getDataFrom:(NSString *)url{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];

    NSError *error = nil;
    NSHTTPURLResponse *responseCode = nil;

    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];

    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %i", url, [responseCode statusCode]);
        return nil;
    }

    return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
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
  }];
}


- (void)showSpotMap:(NSArray *)spots {
  
    UIImage *markerImage = [UIImage imageNamed:@"default_marker"];
    markerImage = [self resizeImage:markerImage width:20];
    
    if (self.customMapMarker != nil) {
        markerImage = self.customMapMarker;
    }
    
    NSMutableArray *featuresArray = [[NSMutableArray alloc] init];
    for(XMMSpot *spot in spots) {
        MGLPointFeature *feature = [[MGLPointFeature alloc] init];
        feature.title = spot.name;
        feature.coordinate = CLLocationCoordinate2DMake(spot.latitude, spot.longitude);
        feature.attributes = [[NSDictionary alloc] initWithObjectsAndKeys: spot.name, @"title", nil];
        [featuresArray addObject:feature];
    }
    
    MGLShapeSource *previousSource = [self.mapView.style sourceWithIdentifier:markersSourceIdentifier];
    if (previousSource != nil) {
        MGLSymbolStyleLayer *previousMarkerLayer = [self.mapView.style layerWithIdentifier:markersLayerIdentifier];
        if (previousMarkerLayer != nil) {
            [self.mapView.style removeLayer:previousMarkerLayer];
        }
        
        [self.mapView.style removeSource:previousSource];
    }
    
    MGLShapeSource *markerSource = [[MGLShapeSource alloc] initWithIdentifier:markersSourceIdentifier features:featuresArray options:nil];
    
    [self.mapView.style addSource:markerSource];
    
    
    MGLSymbolStyleLayer *markerLayer = [[MGLSymbolStyleLayer alloc] initWithIdentifier:markersLayerIdentifier source:markerSource];

    [self.mapView.style setImage:markerImage forName:@"markerImage"];
    markerLayer.iconImageName = [NSExpression expressionForConstantValue:@"markerImage"];

    MGLSymbolStyleLayer *startRouteIconLayer = [self.mapView.style layerWithIdentifier:@"start-tour-layer-background"];
    [self.mapView.style insertLayer:markerLayer belowLayer:startRouteIconLayer];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      if(self.graphCoordinates != nil) {
            [self zoomToFitAnnotationsAndRoute];
        }
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

- (void) showInfoAlertView {
    [self setInfoValues];
    self.infoView.hidden = NO;
    self.isInfoShown = YES;
}

- (void) closeInfoAlertView {
    self.infoView.hidden = YES;
    self.isInfoShown = NO;
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
    if (self.spots.count != 0) {
        [self showSpotMap:self.spots];
    }
}

- (void)openSettings {
  NSURL *url = [[NSURL alloc] initWithString: UIApplicationOpenSettingsURLString];
  if (url != nil) {
    [[UIApplication sharedApplication] openURL:url];
  }
}

-(void) zoomToFitAnnotationsAndRoute {
    
    NSMutableArray *latArray = [NSMutableArray new];
    NSMutableArray *lonArray = [NSMutableArray new];
    
    for(XMMSpot *location in self.spots) {
        [latArray addObject:[NSNumber numberWithDouble:location.latitude]];
        [lonArray addObject:[NSNumber numberWithDouble:location.longitude]];
    }
    
  for(CLLocation *location in self.graphCoordinates){
        [latArray addObject:[NSNumber numberWithDouble:location.coordinate.latitude]];
        [lonArray addObject:[NSNumber numberWithDouble:location.coordinate.longitude]];
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
  
    double latOffset = (maxLat - minLat) * (1 - self.scaleX / 100);
    double lonOffset = (maxLon - minLon) * (1 - self.scaleX / 100);

    CLLocationCoordinate2D ne = CLLocationCoordinate2DMake(minLat - latOffset, minLon - lonOffset);
    CLLocationCoordinate2D sw = CLLocationCoordinate2DMake(maxLat + latOffset, maxLon + lonOffset);
    
    MGLCoordinateBounds bounds = MGLCoordinateBoundsMake(sw, ne);
    [self.mapView setVisibleCoordinateBounds: bounds];
    
    if (_mapAdditionView.isHidden == false) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self closeMapAdditionView];
        });
    }
}


-(float)getDegreeOffsetForMarkerWithMax:(float)max min:(float)min markerLength:(float)markerLength {
  float mapWidth = self.mapView.frame.size.width;
  float widthDegrees = max-min;
  float degreesPerPixel = widthDegrees / mapWidth;
  return degreesPerPixel * markerLength;
}

- (void) handleTapFrom: (UIPanGestureRecognizer *)recognizer {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *url = [bundle URLForResource:@"XamoomSDK" withExtension:@"bundle"];
    NSBundle *libBundle;
    if (url != nil) {
      libBundle = [NSBundle bundleWithURL:url];
    } else {
      libBundle = bundle;
    }
    if (recognizer.numberOfTouches == 1) {
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            self.overlayTitle.textColor = UIColor.whiteColor;
            self.overlayTitle.text = NSLocalizedStringFromTableInBundle(@"mapbox.two.fingers.move.label", @"Localizable", libBundle, nil);
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
