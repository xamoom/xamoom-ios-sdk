//
//  XMMContentBlock14TableViewCell.h
//  XamoomSDK
//
//  Created by Vladyslav Cherednichenko
//  Copyright © 2020 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JAMSVGImage/JAMSVGImage.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "XMMEnduserApi.h"
#import "XMMContentBlocks.h"
#import "XMMContentBlocksCache.h"
#import "XMMAnnotation.h"
#import "XMMMapOverlayView.h"
#import "XMMStyle.h"
#import "UIColor+HexString.h"
#import "UIImage+Scaling.h"
#import <Mapbox/Mapbox.h>
#include <HCLineChartView/HCLineChartView.h>

@class XMMMapOverlayView;

@interface XMMContentBlock14TableViewCell : UITableViewCell<MGLMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MGLMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *centerUserLocationButton;
@property (weak, nonatomic) IBOutlet UIButton *centerSpotBoundsButton;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapViewHeightConstraint;
@property (weak, nonatomic) IBOutlet HCLineChartView *lineChartView;
@property (weak, nonatomic) IBOutlet UIButton *metricButton;
@property (weak, nonatomic) IBOutlet UIButton *imperialButton;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIButton *zoomIn;
@property (weak, nonatomic) IBOutlet UIButton *zoomOut;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *infoTitle;
@property (weak, nonatomic) IBOutlet UILabel *infoDistance;
@property (weak, nonatomic) IBOutlet UILabel *infoAscent;
@property (weak, nonatomic) IBOutlet UILabel *infoDescent;
@property (weak, nonatomic) IBOutlet UILabel *infoTime;
@property (weak, nonatomic) IBOutlet UILabel *infoDistanceDescription;
@property (weak, nonatomic) IBOutlet UILabel *infoAscentDescentDescription;
@property (weak, nonatomic) IBOutlet UILabel *infoTimeDescription;
@property (nonatomic) NSLayoutConstraint *mapAdditionViewBottomConstraint;
@property (nonatomic) NSLayoutConstraint *mapAdditionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineChartHeightConstraint;
@property (nonatomic) XMMMapOverlayView *mapAdditionView;
@property (strong, nonatomic) UIImage *customMapMarker;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSURL *mapboxStyle;
@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UILabel *overlayTitle;
@property (weak, nonatomic)  NSNumber *navigationType;
@end

@interface XMMContentBlock14TableViewCell (XMMTableViewRepresentation)

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style api:(XMMEnduserApi *)api offline:(BOOL)offline;

@end
