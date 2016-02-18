//
//  ViewController.m
//  Example
//
//  Created by Raphael Seher on 14/01/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property XMMEnduserApi *api;
@property XMMContentBlocks *blocks;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property XMMContent *content;

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
                                @"User-Agent":@"XamoomSDK iOS",
                                @"APIKEY":apikey,
                                @"X-DEVKEY":devkey};
  
  NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
  [config setHTTPAdditionalHeaders:httpHeaders];
  XMMRestClient *restClient = [[XMMRestClient alloc] initWithBaseUrl:[NSURL URLWithString:@"https://23-dot-xamoom-api-dot-xamoom-cloud-dev.appspot.com/_api/v2/consumer/"] session:[NSURLSession sessionWithConfiguration:config]];
  
  self.api = [[XMMEnduserApi alloc] initWithRestClient:restClient];
  
  self.blocks = [[XMMContentBlocks alloc] initWithTableView:self.tableView api:self.api];
  self.blocks.delegate = self;
  
  [self displayContent];
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
  [self system];
}

- (void)didClickContentBlock:(NSString *)contentID {
  NSLog(@"DidClockContentBlock: %@", contentID);
}

- (void)contentWithID {
  [self.api contentWithID:@"e5be72be162d44b189893a406aff5227" completion:^(XMMContent *content, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
      return;
    }
    
    self.content = content;
    
    NSLog(@"ContentWithId: %@", content.title);
    for (XMMContentBlock *block in content.contentBlocks) {
      NSLog(@"Block %@", block.title);
    }
  }];
}

- (void)contentWithIDOptions {
  [self.api contentWithID:@"28d13571a9614cc19d624528ed7c2bb8" options:XMMContentOptionsPreview|XMMContentOptionsPrivate completion:^(XMMContent *content, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
      return;
    }
    
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
  [self.api contentsWithTags:@[@"tag1",@"tag2"] pageSize:10 cursor:nil sort:0 completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
      return;
    }
    
    NSLog(@"ContentWithTags: %@", contents);
  }];
}

- (void)spotsWithLocation {
  CLLocation *location = [[CLLocation alloc] initWithLatitude:46.6150102 longitude:14.2628843];
  [self.api spotsWithLocation:location radius:1000 options:0 completion:^(NSArray *spots, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
      return;
    }
    
    NSLog(@"spotsWithLocation: %@", spots);
  }];
}

- (void)spotsWithTags {
  [self.api spotsWithTags:@[@"tag1"] pageSize:10 cursor:nil options:XMMSpotOptionsIncludeContent sort:0 completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
      return;
    }
    
    NSLog(@"spotsWithTags: %@", spots);
  }];
}

- (void)system {
  [self.api systemWithCompletion:^(XMMSystem *system, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
      return;
    }
    
    NSLog(@"system: %@", system);
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
  }];
}

- (void)styleWithID:(NSString *)styleID {
  [self.api styleWithID:styleID completion:^(XMMStyle *style, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
      return;
    }
    self.blocks.style = style;
    [self.blocks displayContent:self.content];
    
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
    
    for (XMMMenuItem *item in menu.items) {
      NSLog(@"MenuItem: %@", item.contentTitle);
    }
  }];
}

@end
