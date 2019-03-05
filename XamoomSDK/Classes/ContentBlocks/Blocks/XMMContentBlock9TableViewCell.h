//
//  XMMContentBlock9TableViewCell.h
//  XamoomSDK
//
//  Created by Thomas Krainz-Mischitz on 05.02.19.
//  Copyright © 2019 xamoom GmbH. All rights reserved.
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
@import Mapbox;

@class XMMMapOverlayView;

@interface XMMContentBlock9TableViewCell : UITableViewCell<MGLMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MGLMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapViewHeightConstraint;
@property (nonatomic) NSLayoutConstraint *mapAdditionViewBottomConstraint;
@property (nonatomic) NSLayoutConstraint *mapAdditionViewHeightConstraint;

@property (nonatomic) XMMMapOverlayView *mapAdditionView;
@property (strong, nonatomic) UIImage *customMapMarker;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@interface XMMContentBlock9TableViewCell (XMMTableViewRepresentation)

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style api:(XMMEnduserApi *)api offline:(BOOL)offline;

@end
