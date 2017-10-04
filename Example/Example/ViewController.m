//
//  ViewController.m
//  Example
//
//  Created by Raphael Seher on 14/01/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import "ViewController.h"
#import "XMMCDContent.h"
#import "XMMCDSpot.h"
#import "DetailViewController.h"
#import <XamoomSDK/XMMOfflineStorageTagModule.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *loadTabBarItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property XMMContentBlocks *blocks;
@property XMMContent *content;

@property XMMSystem *system;
@property XMMCDSystem *savedSystem;

@property XMMOfflineStorageTagModule *module;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.blocks = [[XMMContentBlocks alloc] initWithTableView:self.tableView api:self.api];
  self.blocks.delegate = self;
  
  [[NSNotificationCenter defaultCenter]
   addObserver:self
   selector:@selector(offlineReady)
   name:kManagedContextReadyNotification
   object:nil];
  
  //self.module = [[XMMOfflineStorageTagModule alloc] initWithApi:self.api];
  
  [self displayContent];
}

- (void)viewWillDisappear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kManagedContextReadyNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kXamoomOfflineUpdateDownloadCount object:nil];
}


- (void)offlineReady {
  self.loadTabBarItem.enabled = YES;
  NSLog(@"offline ready");
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)displayContent {
  [self contentWithID];
  [self contentWithIDOptions];
  [self contentWithLocationIdentifier];
  [self contentWithCondition];
  [self contentWithBeaconMajor];
  [self contentWithLocation];
  [self contentWithTags];
  [self spotsWithLocation];
  [self spotsWithTags];
  [self loadSystem];
}

- (IBAction)didClickLoad:(id)sender {
  [self.blocks.items removeAllObjects];
  [self.tableView reloadData];
  
  self.blocks.offline = YES;
  self.api.offline = YES;
  
  [self contentWithID];
}

- (void)didClickContentBlock:(NSString *)contentID {
  NSLog(@"DidClockContentBlock: %@", contentID);
  
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  DetailViewController *vc = (DetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
  vc.api = self.api;
  vc.contentID = contentID;
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)contentWithID {
  [self.api contentWithID:@"7cf2c58e6d374ce3888c32eb80be53b5" completion:^(XMMContent *content, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
      return;
    }
    
    XMMContentBlock *block = [[XMMContentBlock alloc] init];
    block.ID = @"21401059125125";
    block.contentListSortAsc = true;
    block.contentListPageSize = 11;
    block.contentListTags = @[@"test1", @"test2"];
    
    NSMutableArray *contentBlocks = [content.contentBlocks mutableCopy];
    [contentBlocks addObject:block];
    content.contentBlocks = contentBlocks;
    
    if (self.api.offline == NO) {
      [content saveOffline:^(NSString *url, NSData *data, NSError *error) {
        NSLog(@"Downloaded file %@", url);
      }];
    }
    
    [self.blocks displayContent:content];
    
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
    
    //self.content = content;
    //[self.blocks displayContent:self.content];
    
    NSLog(@"ContentWithIdOptions: %@", content.title);
    for (XMMContentBlock *block in content.contentBlocks) {
      NSLog(@"Block %@", block.title);
    }
  }];
}

- (void)contentWithLocationIdentifier {
  [self.api contentWithLocationIdentifier:@"b5v2p" completion:^(XMMContent *content, NSError *error) {
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

- (void)contentWithCondition {
  NSDictionary *condition = @{@"string":@"I'm such a wonderful goat",
                              @"date":[[NSDate alloc] init],
                              @"number":@4};
  
  [self.api contentWithLocationIdentifier:@"b5v2p"
                                  options:0
                               conditions:condition
                               completion:^(XMMContent *content, NSError *error) {
                                 if (error) {
                                   NSLog(@"Error: %@", error);
                                   return;
                                 }
                                 
                                 NSLog(@"ContentWithLocationIdentifier: %@", content.title);
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
    
    for (XMMContent *item in menu.items) {
      NSLog(@"MenuItem: %@", item.title);
    }
  }];
}

@end
