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
// along with xamoom-pingeborg-ios. If not, see <http://www.gnu.org/licenses/>.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "XMMEnduserApi.h"
#import "XMMAnnotation.h"
#import "XMMAnnotationView.h"
#import "XMMCalloutView.h"
#import <SMCalloutView/SMCalloutView.h>
#import "SVGKit.h"
#import "SVGKSourceString.h"

@class XamoomMapView;

@interface XMMContentBlock9TableViewCell : UITableViewCell <MKMapViewDelegate, SMCalloutViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *viewForMap;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@property (nonatomic, strong) XamoomMapView *mapKitWithSMCalloutView;
@property NSArray *spotMapTags; 
@property UIImage *customMapMarker;
@property CLLocationManager *locationManager;
@property UIColor* linkColor;

- (void)getSpotMapWithSystemId:(NSString*)systemId withLanguage:(NSString*)language;

@end
