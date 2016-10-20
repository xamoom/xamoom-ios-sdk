//
//  ViewController.m
//  Example
//
//  Created by Raphael Seher on 14/01/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import "ViewController.h"
#import "XMMCDSystem.h"
#import "XMMCDContent.h"
#import "XMMCDSpot.h"
#import "DetailViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *loadTabBarItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property XMMEnduserApi *api;
@property XMMContentBlocks *blocks;
@property XMMContent *content;

@property XMMSystem *system;
@property XMMCDSystem *savedSystem;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"TestingIDs" ofType:@"plist"];
  NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
  NSString *apikey = [dict objectForKey:@"APIKEY"];
  NSString *devkey = [dict objectForKey:@"X-DEVKEY"];
  
  NSDictionary *httpHeaders = @{@"Content-Type":@"application/vnd.api+json",
                                @"User-Agent":@"XamoomSDK iOS | SDK Example | dev",
                                @"APIKEY":apikey,
                                @"X-DEVKEY":devkey};
  
  NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
  [config setHTTPAdditionalHeaders:httpHeaders];
  XMMRestClient *restClient = [[XMMRestClient alloc] initWithBaseUrl:[NSURL URLWithString:@"https://xamoom-cloud-dev.appspot.com/_api/v2/consumer/"] session:[NSURLSession sessionWithConfiguration:config]];
  
  self.api = [[XMMEnduserApi alloc] initWithRestClient:restClient];
  
  self.blocks = [[XMMContentBlocks alloc] initWithTableView:self.tableView api:self.api];
  self.blocks.delegate = self;
  
  
  [[NSNotificationCenter defaultCenter]
   addObserver:self
   selector:@selector(offlineReady)
   name:kManagedContextReadyNotification
   object:nil];
  
  [[NSNotificationCenter defaultCenter]
   addObserver:self
   selector:@selector(offlineFileSaveError:)
   name:kXamoomOfflineSaveFileFromUrlError
   object:nil];
  
  [[NSNotificationCenter defaultCenter]
   addObserver:self
   selector:@selector(downloadFileUpdate:)
   name:kXamoomOfflineUpdateDownloadCount
   object:nil];
    
  //[self loadSystem];
  //[self contentWithID];
}

- (void)viewWillDisappear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kManagedContextReadyNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kXamoomOfflineSaveFileFromUrlError object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kXamoomOfflineUpdateDownloadCount object:nil];
}


- (void)offlineReady {
  self.loadTabBarItem.enabled = YES;
  
  [self contentWithTags];
  //[self contentWithID];
}

- (void)downloadFileUpdate:(NSNotification *)notification {
  NSLog(@"Count %@", notification.userInfo[@"count"]);

}

- (void)offlineFileSaveError:(NSNotification *)notification {
  NSError *error = notification.userInfo[@"error"];
  NSString *url = notification.userInfo[@"url"];
  NSLog(@"Error:%@ loading file: %@", error, url);
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)displayContent {
  [self contentWithID];
  [self contentWithIDOptions];
  [self contentWithLocationIdentifier];
  [self contentWithBeaconMajor];
  [self contentWithLocation];
  [self contentWithTags];
  [self spotsWithLocation];
  [self spotsWithTags];
  [self loadSystem];
}

- (IBAction)didClickLoad:(id)sender {
  self.api.offline = YES;
  
  [self.api contentWithID:@"7cf2c58e6d374ce3888c32eb80be53b5" completion:^(XMMContent *content, NSError *error) {
    NSLog(@"Content: %@", content);
    self.blocks.offline = YES;
    [self.blocks displayContent:content];
  }];
}

- (void)didClickContentBlock:(NSString *)contentID {
  NSLog(@"DidClockContentBlock: %@", contentID);
  
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  DetailViewController *vc = (DetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
  vc.contentID = contentID;
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)contentWithID {
  [self.api contentWithID:@"7cf2c58e6d374ce3888c32eb80be53b5" completion:^(XMMContent *content, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
      return;
    }
    
    XMMCDContent *savedContent = [XMMCDContent insertNewObjectFrom:content];
    //[self.blocks displayContent:content];
    
    NSLog(@"ContentWithId: %@", content.title);
    for (XMMContentBlock *block in content.contentBlocks) {
      NSLog(@"Block %@", block.title);
    }
  }];
}

- (void)contentWithIDOptions {
  [self.api contentWithID:@"0737f96b520645cab6d71242cd43cdad" options:XMMContentOptionsPrivate completion:^(XMMContent *content, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
      return;
    }
    
    XMMCDContent *savedContent = [XMMCDContent insertNewObjectFrom:content];
    
    
    //self.content = content;
    //[self.blocks displayContent:self.content];
    
    NSLog(@"ContentWithIdOptions: %@", content.title);
    for (XMMContentBlock *block in content.contentBlocks) {
      NSLog(@"Block %@", block.title);
    }
  }];
}

- (void)contentWithLocationIdentifier {
  [self.api contentWithLocationIdentifier:@"7qpqr" completion:^(XMMContent *content, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
      return;
    }
    
    NSLog(@"ContentWithLocationIdentifier: %@", content.title);
    for (XMMContentBlock *block in content.contentBlocks) {
      NSLog(@"Block %@", block.title);
    }
  }];
}

- (void)contentWithBeaconMajor {
  [self.api contentWithBeaconMajor:@54222 minor:@24265 completion:^(XMMContent *content, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
      return;
    }
    
    NSLog(@"ContentWithBeaconMajor: %@", content.title);
    for (XMMContentBlock *block in content.contentBlocks) {
      NSLog(@"Block %@", block.title);
    }
  }];
}

- (void)contentWithLocation {
  CLLocation *location = [[CLLocation alloc] initWithLatitude:46.6150102 longitude:14.2628843];
  [self.api contentsWithLocation:location pageSize:1 cursor:nil sort:XMMContentSortOptionsNameDesc completion:^(NSArray *contents, bool hasMore, NSString* cursor, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
      return;
    }
    
    NSLog(@"ContentWithLocation: %@", contents);
  }];
}

- (void)contentWithTags {
  self.api.offline = NO;
  [self.api contentsWithTags:@[@"tests"] pageSize:10 cursor:nil sort:0 completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
      return;
    }
    
    for (XMMContent *content in contents) {
      [self.api contentWithID:content.ID completion:^(XMMContent *content2, NSError *error) {
        [XMMCDContent insertNewObjectFrom:content2];
      }];
    }
    
    NSLog(@"ContentWithTags: %@", contents);
  }];
}

- (void)spotWithId:(NSString *)spotID {
  [self.api spotWithID:spotID completion:^(XMMSpot *spot, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
      return;
    }
    
    NSLog(@"spotWithId: %@", spot);
  }];
}

- (void)spotWithIdAndOptions:(NSString *)spotID {
  [self.api spotWithID:spotID options:XMMSpotOptionsIncludeContent|XMMSpotOptionsIncludeMarker
            completion:^(XMMSpot *spot, NSError *error) {
              if (error) {
                NSLog(@"Error: %@", error);
                return;
              }
              
              NSLog(@"spotWithIdAndOptions: %@", spot);
            }];
}

- (void)spotsWithLocation {
  /*
   CLLocation *location = [[CLLocation alloc] initWithLatitude:46.6150102 longitude:14.2628843];
   [self.api spotsWithLocation:location radius:1000 options:0 completion:^(NSArray *spots, NSError *error) {
   if (error) {
   NSLog(@"Error: %@", error);
   return;
   }
   
   NSLog(@"spotsWithLocation: %@", spots);
   XMMSpot *spot = [spots objectAtIndex:0];
   [self spotWithId:spot.ID];
   [self spotWithIdAndOptions:spot.ID];
   
   }];
   */
}

- (void)spotsWithTags {
  [self.api spotsWithTags:@[@"tag1"] pageSize:10 cursor:nil options:XMMSpotOptionsIncludeContent|XMMSpotOptionsIncludeMarker sort:0 completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
      return;
    }
    
    for (XMMSpot *spot in spots) {
      [XMMCDSpot insertNewObjectFrom:spot];
    }
    
    NSLog(@"spotsWithTags: %@", spots);
  }];
}

- (void)loadSystem {
  [self.api systemWithCompletion:^(XMMSystem *system, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
      return;
    }
    
    NSLog(@"system: %@", system);
    
    self.system = system;
    self.savedSystem = [XMMCDSystem insertNewObjectFrom:system];
    
    [self systemSettingsWithID:system.setting.ID];
    [self styleWithID:system.style.ID];
    [self menuWithID:system.menu.ID];
  }];
}

- (void)systemSettingsWithID:(NSString *)settingsID {
  [self.api systemSettingsWithID:settingsID completion:^(XMMSystemSettings *settings, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
      return;
    }
    
    NSLog(@"Settings: %@", settings);
    self.system.setting = settings;
    self.savedSystem = [XMMCDSystem insertNewObjectFrom:self.system];
  }];
}

- (void)styleWithID:(NSString *)styleID {
  [self.api styleWithID:styleID completion:^(XMMStyle *style, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
      return;
    }
    
    self.system.style = style;
    self.savedSystem = [XMMCDSystem insertNewObjectFrom:self.system];
    //self.blocks.style = style;
    //[self.blocks.tableView reloadData];
    NSLog(@"Style: %@", style);
  }];
}

- (void)menuWithID:(NSString *)menuID {
  [self.api menuWithID:menuID completion:^(XMMMenu *menu, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
      return;
    }
    
    NSLog(@"Menu: %@", menu);
    
    self.system.menu = menu;
    self.savedSystem = [XMMCDSystem insertNewObjectFrom:self.system];
    
    for (XMMMenuItem *item in menu.items) {
      NSLog(@"MenuItem: %@", item.contentTitle);
    }
  }];
}

@end
