//
//  APIIntegrationTests.m
//  XamoomSDK
//
//  Created by Raphael Seher on 25/02/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Nocilla/Nocilla.h>
#import "XMMEnduserApi.h"

@interface APIIntegrationTests : XCTestCase

@property XMMEnduserApi *api;
@property NSString* apikey;
@property NSString* contentID;
@property NSString* qrMarker;
@property double timeout;

@end

@implementation APIIntegrationTests

- (void)setUp {
  [super setUp];
  self.timeout = 2.0;
  self.apikey = @"test";
  self.contentID = @"7cf2c58e6d374ce3888c32eb80be53b5";
  self.qrMarker = @"k7ttt";
  
  NSDictionary *httpHeaders = @{@"Content-Type":@"application/vnd.api+json",
                                @"User-Agent":@"XamoomSDK iOS",
                                @"APIKEY":self.apikey};
  
  NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
  [config setHTTPAdditionalHeaders:httpHeaders];
  XMMRestClient *restClient = [[XMMRestClient alloc] initWithBaseUrl:[NSURL URLWithString:@"http://localhost:9999/_api/v2/consumer/"] session:[NSURLSession sessionWithConfiguration:config]];
  
  self.api = [[XMMEnduserApi alloc] initWithRestClient:restClient];

  [[LSNocilla sharedInstance] start];
}

- (void)tearDown {
  self.api = nil;
  [[LSNocilla sharedInstance] stop];

  [super tearDown];
}

- (void)testContentWithID {
  stubRequest(@"GET", @"http://localhost:9999/_api/v2/consumer/contents/7cf2c58e6d374ce3888c32eb80be53b5?lang=en").
  withHeaders(@{ @"APIKEY": @"test", @"Content-Type": @"application/vnd.api+json", @"User-Agent": @"XamoomSDK iOS" }).
  andReturn(200).
  withBody([self jsonResponse:@"contentById"]);
  
  stubRequest(@"GET", @"http://localhost:9999/_api/v2/consumer/contents/5f6a24e9ec5e4090890b7911c791a0c7?lang=en").
  withHeaders(@{ @"APIKEY": @"test", @"Content-Type": @"application/vnd.api+json", @"User-Agent": @"XamoomSDK iOS" }).
  andReturn(200).
  withBody([self jsonResponse:@"5f6a24e9ec5e4090890b7911c791a0c7"]);
  
  stubRequest(@"GET", @"http://localhost:9999/_api/v2/consumer/contents/2dacd9944946484b9df2b822c475a90c?lang=en").
  withHeaders(@{ @"APIKEY": @"test", @"Content-Type": @"application/vnd.api+json", @"User-Agent": @"XamoomSDK iOS" }).
  andReturn(200).
  withBody([self jsonResponse:@"2dacd9944946484b9df2b822c475a90c"]);
  
  stubRequest(@"GET", @"http://localhost:9999/_api/v2/consumer/contents/6b4102f6fd0c40eba7398e4012069d1d?lang=en").
  withHeaders(@{ @"APIKEY": @"test", @"Content-Type": @"application/vnd.api+json", @"User-Agent": @"XamoomSDK iOS" }).
  andReturn(200).
  withBody([self jsonResponse:@"6b4102f6fd0c40eba7398e4012069d1d"]);
  
  stubRequest(@"GET", @"http://localhost:9999/_api/v2/consumer/contents/49c8f22408b047598c2b00507aed04db?lang=en").
  withHeaders(@{ @"APIKEY": @"test", @"Content-Type": @"application/vnd.api+json", @"User-Agent": @"XamoomSDK iOS" }).
  andReturn(200).
  withBody([self jsonResponse:@"49c8f22408b047598c2b00507aed04db"]);
  
  stubRequest(@"GET", @"http://localhost:9999/_api/v2/consumer/contents/2570fd0d2a0a48c39112bc9913461f5d?lang=en").
  withHeaders(@{ @"APIKEY": @"test", @"Content-Type": @"application/vnd.api+json", @"User-Agent": @"XamoomSDK iOS" }).
  andReturn(200).
  withBody([self jsonResponse:@"2570fd0d2a0a48c39112bc9913461f5d"]);
  
  stubRequest(@"GET", @"http://localhost:9999/_api/v2/consumer/contents/0737f96b520645cab6d71242cd43cdad?lang=en").
  withHeaders(@{ @"APIKEY": @"test", @"Content-Type": @"application/vnd.api+json", @"User-Agent": @"XamoomSDK iOS" }).
  andReturn(200).
  withBody([self jsonResponse:@"0737f96b520645cab6d71242cd43cdad"]);
  
  stubRequest(@"GET", @"http://localhost:9999/_api/v2/consumer/contents/1d4f6152baa5418098d12cbf14e20275?lang=en").
  withHeaders(@{ @"APIKEY": @"test", @"Content-Type": @"application/vnd.api+json", @"User-Agent": @"XamoomSDK iOS" }).
  andReturn(200).
  withBody([self jsonResponse:@"1d4f6152baa5418098d12cbf14e20275"]);
  
  stubRequest(@"GET", @"http://localhost:9999/_api/v2/consumer/contents/1d966300bb304a199a7ba5d9ff295269?lang=en").
  withHeaders(@{ @"APIKEY": @"test", @"Content-Type": @"application/vnd.api+json", @"User-Agent": @"XamoomSDK iOS" }).
  andReturn(200).
  withBody([self jsonResponse:@"1d966300bb304a199a7ba5d9ff295269"]);
  
  stubRequest(@"GET", @"http://localhost:9999/_api/v2/consumer/contents/3092bce1dbef409c8943ab43afa2c938?lang=en").
  withHeaders(@{ @"APIKEY": @"test", @"Content-Type": @"application/vnd.api+json", @"User-Agent": @"XamoomSDK iOS" }).
  andReturn(200).
  withBody([self jsonResponse:@"3092bce1dbef409c8943ab43afa2c938"]);

  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  NSArray *tags = [NSArray arrayWithObjects:@"tests", @"Wörthersee", nil];
  
  XMMContent * __block loadedContent = nil;
  
  self.api.language = @"en";
  [self.api contentWithID:self.contentID completion:^(XMMContent *content, NSError *error) {
    XCTAssertNotNil(content);
    XCTAssertNil(error);
    
    loadedContent = content;
    
    //content
    XCTAssertTrue([content.title isEqualToString:@"APP | Testing Hub"]);
    XCTAssertTrue([content.contentDescription isEqualToString:@"Testing Hub excerpt."]);
    XCTAssertTrue([content.language isEqualToString:@"de"]);

    XCTAssertTrue([content.imagePublicUrl isEqualToString:@"https://storage.googleapis.com/xamoom-files-dev/mobile/d8baa2bad1ce4d9da21297098ce4ff00.jpg?v=b87374bc207bd8267e5e89e439b3e475eb90b63fd974fbe338421cdd63944370e98dd495fab54ceaf3efef6b9223f7de9f44097a39c630c08a969d1545c4aa63"]);
    XCTAssertTrue([content.tags isEqualToArray:tags]);
    XCTAssertTrue(content.category == 58);
    
    //system
    XCTAssertTrue([content.system.ID isEqualToString:@"5755996320301056"]);
    
    XCTAssertEqual(content.contentBlocks.count, 10);
    
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
  
  if (loadedContent) {
    [self checkAllContentBlocks:loadedContent.contentBlocks];
  }
}

- (void)testContentWithLocationIdentifier {
  stubRequest(@"GET", @"http://localhost:9999/_api/v2/consumer/contents?lang=en&filter%5Blocation-identifier%5D=k7ttt").
  withHeaders(@{ @"APIKEY": @"test", @"Content-Type": @"application/vnd.api+json", @"User-Agent": @"XamoomSDK iOS" }). andReturn(200).
  withBody([self jsonResponse:@"contentByQr"]);
  
  XMMContent * __block loadedContent = nil;
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.api contentWithLocationIdentifier:self.qrMarker completion:^(XMMContent *content, NSError *error) {
    XCTAssertNotNil(content);
    XCTAssertNil(error);
    XCTAssertTrue([content.title isEqualToString:@"APP | Testing Hub"]);

    loadedContent = content;
    
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testContentWithBeacon {
  stubRequest(@"GET", @"http://localhost:9999/_api/v2/consumer/contents?lang=en&filter%5Blocation-identifier%5D=54222%7C24265").
  withHeaders(@{ @"APIKEY": @"test", @"Content-Type": @"application/vnd.api+json", @"User-Agent": @"XamoomSDK iOS" }).
  andReturn(200).
  withBody([self jsonResponse:@"contentByQr"]);
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.api contentWithBeaconMajor:@54222 minor:@24265 completion:^(XMMContent *content, NSError *error) {
    XCTAssertNotNil(content);
    XCTAssertNil(error);
    XCTAssertTrue([content.title isEqualToString:@"APP | Testing Hub"]);
    
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testSpotsWithTag {
  stubRequest(@"GET", @"http://localhost:9999/_api/v2/consumer/spots?filter%5Btags%5D=%5B%22spot1%22%5D&page%5Bsize%5D=100&include_markers=true&lang=en&include_content=true").
  withHeaders(@{ @"APIKEY": @"test", @"Content-Type": @"application/vnd.api+json", @"User-Agent": @"XamoomSDK iOS" }).
  andReturn(200).
  withBody([self jsonResponse:@"spotByTags"]);
  
  NSArray *tags = [NSArray arrayWithObjects:@"spot1", @"allSpots", @"Wörthersee", nil];
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.api spotsWithTags:@[@"spot1"] options:XMMSpotOptionsIncludeContent|XMMSpotOptionsIncludeMarker completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
    XCTAssertFalse(hasMore);
    XCTAssertTrue([cursor isEqualToString:@""]);
    XMMSpot *spot = [spots firstObject];
    
    XCTAssertTrue([spot.name isEqualToString:@"APP | Spot 1"]);
    XCTAssertTrue([spot.spotDescription isEqualToString:@"Thats the spot excerpt."]);

    XCTAssertTrue([spot.image isEqualToString:@"https://storage.googleapis.com/xamoom-files-dev/mobile/9bee8ab135bc41f392aab58dff07a8de.jpg?v=2cd9bbdc0d25b399deec11fcfd97b89614774102229b844662f08889de50f4d5ead08b76dc78c0124e7ef90e0023f96127fcab6a53bc1f87cdee24b25a576819"]);
    XCTAssertTrue(spot.latitude == 46.615031299999998);
    XCTAssertTrue(spot.longitude == 14.261887000000002);
    XCTAssertTrue([spot.tags isEqualToArray:tags]);
    XCTAssertTrue([spot.system.ID isEqualToString:@"5755996320301056"]);
    XCTAssertTrue([spot.content.ID isEqualToString:@"7cf2c58e6d374ce3888c32eb80be53b5"]);
    XCTAssertNotNil(spot.markers);
    
    XMMMarker *marker = [spot.markers firstObject];
    XCTAssertNotNil(marker);
    XCTAssertTrue([marker.nfc isEqualToString:@"0c0horvyze9d"]);
    XCTAssertTrue([marker.qr isEqualToString:@"b5v2p"]);
    XCTAssertTrue([marker.beaconMajor isEqualToString:@"8843"]);
    XCTAssertTrue([marker.beaconMinor isEqualToString:@"29521"]);
    XCTAssertTrue([marker.beaconUUID isEqualToString:@"de2b94ae-ed98-11e4-3432-78616d6f6f6d"]);
    XCTAssertTrue([marker.eddyStoneUrl isEqualToString:@"dev.xm.gl/32lf0x"]);
    
    [expectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testSystem {
  stubRequest(@"GET", @"http://localhost:9999/_api/v2/consumer/systems?lang=en").
  withHeaders(@{ @"APIKEY": @"test", @"Content-Type": @"application/vnd.api+json", @"User-Agent": @"XamoomSDK iOS" }).
  andReturn(200).
  withBody([self jsonResponse:@"system"]);
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.api systemWithCompletion:^(XMMSystem *system, NSError *error) {
    XCTAssertTrue([system.name isEqualToString:@"Dev xamoom testing UMGEBUNG"]);
    XCTAssertTrue([system.url isEqualToString:@"http://testpavol.at"]);
    XCTAssertTrue([system.setting.ID isEqualToString:@"5755996320301056"]);
    XCTAssertTrue([system.style.ID isEqualToString:@"5755996320301056"]);
    XCTAssertTrue([system.menu.ID isEqualToString:@"5755996320301056"]);
    
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testSystemSettings {
  stubRequest(@"GET", @"http://localhost:9999/_api/v2/consumer/settings/5755996320301056?lang=en").
  withHeaders(@{ @"APIKEY": @"test", @"Content-Type": @"application/vnd.api+json", @"User-Agent": @"XamoomSDK iOS" }).
  andReturn(200).
  withBody([self jsonResponse:@"setting"]);
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.api systemSettingsWithID:@"5755996320301056" completion:^(XMMSystemSettings *settings, NSError *error) {
    XCTAssertTrue([settings.googlePlayAppId isEqualToString:@"com.xamoom.android.xamoom_pingeborg_android"]);
    XCTAssertTrue([settings.itunesAppId isEqualToString:@"998504165"]);
    
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testStyle {
  stubRequest(@"GET", @"http://localhost:9999/_api/v2/consumer/styles/5755996320301056?lang=en").
  withHeaders(@{ @"APIKEY": @"test", @"Content-Type": @"application/vnd.api+json", @"User-Agent": @"XamoomSDK iOS" }).
  andReturn(200).
  withBody([self jsonResponse:@"style"]);
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.api styleWithID:@"5755996320301056" completion:^(XMMStyle *style, NSError *error) {
    XCTAssertTrue([style.chromeHeaderColor isEqualToString:@"#ffee00"]);
    XCTAssertTrue([style.highlightFontColor isEqualToString:@"#d6220c"]);
    XCTAssertTrue([style.foregroundFontColor isEqualToString:@"#222222"]);
    XCTAssertTrue([style.backgroundColor isEqualToString:@"#f2f2f2"]);
    XCTAssertNotNil(style.customMarker);
    XCTAssertNotNil(style.icon);
    
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testMenu {
  stubRequest(@"GET", @"http://localhost:9999/_api/v2/consumer/menus/5755996320301056?lang=en").
  withHeaders(@{ @"APIKEY": @"test", @"Content-Type": @"application/vnd.api+json", @"User-Agent": @"XamoomSDK iOS" }).
  andReturn(200).
  withBody([self jsonResponse:@"menu"]);
  
  XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
  [self.api menuWithID:@"5755996320301056" completion:^(XMMMenu *menu, NSError *error) {
    XCTAssertNotNil(menu.items);
    XCTAssertEqual(menu.items.count, 3);
    
    XMMContent *content = menu.items[0];
    XCTAssertTrue([content.ID isEqualToString:@"28d13571a9614cc19d624528ed7c2bb8"]);
    
    content = menu.items[1];
    XCTAssertTrue([content.ID isEqualToString:@"7cf2c58e6d374ce3888c32eb80be53b5"]);
    
    content = menu.items[2];
    XCTAssertTrue([content.ID isEqualToString:@"3092bce1dbef409c8943ab43afa2c938"]);
    
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

# pragma mark - Assert Helper

- (void)checkAllContentBlocks:(NSArray *)contentBlocks {
  for (XMMContentBlock *contentblock in contentBlocks) {
    if (contentblock.contentID == nil) {
      continue;
    }
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [self.api contentWithID:contentblock.contentID completion:^(XMMContent *content, NSError *error) {
      XMMContentBlock *block = content.contentBlocks[0];

      // text
      if ([content.ID isEqualToString:@"5f6a24e9ec5e4090890b7911c791a0c7"]) {
        XCTAssertEqual(block.blockType, 0);
        XCTAssertTrue([block.title isEqualToString:@"Titel 1"]);
        XCTAssertTrue([block.text isEqualToString:@"<p>Text 1</p>"]);
        XCTAssertTrue(block.publicStatus);
      }
      
      if ([content.ID isEqualToString:@"1d4f6152baa5418098d12cbf14e20275"]) {
        XCTAssertTrue([block.fileID isEqualToString:@"https://storage.googleapis.com/xamoom-files-dev/10d652eeed9849d1bd6cb9168c69eecd.epub"]);
        XCTAssertTrue([block.title isEqualToString:@"Book 1| Epub"]);
        XCTAssertTrue([block.artists isEqualToString:@"Book 1 Text"]);
        XCTAssertEqual(block.blockType, 5);
      }
      
      if ([content.ID isEqualToString:@"1d966300bb304a199a7ba5d9ff295269"]) {
        XCTAssertTrue([block.title isEqualToString:@"VCard"]);
        XCTAssertTrue([block.text isEqualToString:@"VCard Description"]);
        XCTAssertTrue([block.fileID isEqualToString:@"https://storage.googleapis.com/xamoom-files-dev/862be8b5c7854986bb4cf9269e4fa0b9.vcf"]);
        XCTAssertEqual(block.blockType, 8);
        XCTAssertEqual(block.downloadType, 0);
      }
      
      if ([content.ID isEqualToString:@"2dacd9944946484b9df2b822c475a90c"]) {
        XCTAssertTrue([block.title isEqualToString:@"Audio 1 | mp3"]);
        XCTAssertTrue([block.artists isEqualToString:@"Artist"]);
        XCTAssertTrue([block.fileID isEqualToString:@"https://storage.googleapis.com/xamoom-files-dev/93b258c0c2d543759471cec6f102118d.mp3"]);
        XCTAssertEqual(block.blockType, 1);
      }

      if ([content.ID isEqualToString:@"6b4102f6fd0c40eba7398e4012069d1d"]) {
        XCTAssertTrue([block.title isEqualToString:@"Soundcloud 1"]);
        XCTAssertTrue([block.soundcloudUrl isEqualToString:@"https://soundcloud.com/istdochmiregal/ok-kid-verschwende-mich"]);
        XCTAssertEqual(block.blockType, 7);
      }
      
      if ([content.ID isEqualToString:@"0737f96b520645cab6d71242cd43cdad"]) {
        XCTAssertTrue([block.title isEqualToString:@"Image 1 | 100%"]);
        XCTAssertTrue([block.fileID isEqualToString:@"https://storage.googleapis.com/xamoom-files-dev/mobile/62a7d76c4a14446bbc8e3155b8db025f.png"]);
        XCTAssertEqual(block.scaleX, 100.0);
        XCTAssertEqual(block.blockType, 3);
      }
      
      if ([content.ID isEqualToString:@"2570fd0d2a0a48c39112bc9913461f5d"]) {
        XCTAssertTrue([block.title isEqualToString:@"Amazon"]);
        XCTAssertTrue([block.text isEqualToString:@"Amazon Text"]);
        XCTAssertTrue([block.linkUrl isEqualToString:@"http://www.amazon.de/Stupid-Hobbit-Gedruckt-Frauen-T-Shirt/dp/B013PHYR5S/ref=sr_1_15?ie=UTF8&qid=1452180457&sr=8-15&keywords=Stupid"]);
        XCTAssertEqual(block.linkType, 3);
        XCTAssertEqual(block.blockType, 4);
      }
      
      if ([content.ID isEqualToString:@"3092bce1dbef409c8943ab43afa2c938"]) {
        XCTAssertTrue([block.title isEqualToString:@"TestMap | TAG SPOT1"]);
        XCTAssertTrue([block.spotMapTags isEqualToArray:@[@"spot1"]]);
        XCTAssertTrue(block.showContent);
        XCTAssertEqual(block.blockType, 9);
      }
      
      if ([content.ID isEqualToString:@"49c8f22408b047598c2b00507aed04db"]) {
        XCTAssertTrue([block.title isEqualToString:@"Youtube Video 1"]);
        XCTAssertTrue([block.videoUrl isEqualToString:@"https://www.youtube.com/watch?v=dtm_tIkEbMc"]);
        XCTAssertEqual(block.blockType, 2);
      }
      
      [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
  }
}

# pragma mark - Helper

- (NSString *)jsonResponse:(NSString *)name {
  NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:name ofType:@"json"];
  return [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
}

@end
