//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMContentBlocks.h"
#import <SDWebImage/UIImageView+WebCache.h>

int const kHorizontalSpaceToSubview = 32;
NSString* const kContentBlock9MapContentLinkNotification = @"com.xamoom.ios.kContentBlock9MapContentLinkNotification";
NSString* const keyboardWillShowNotificatoin = @"UIKeyboardWillShowNotification";
NSString* const keyboardWillHideNotification = @"UIKeyboardWillHideNotification";

#pragma mark - XMMContentBlocks Interface

@interface XMMContentBlocks ()
@property (nonatomic) XMMSpot *relatedSpot;
@property (nonatomic) XMMContent *content;
@property (nonatomic) CGFloat keyboardHeight;
@end

#pragma mark - XMMContentBlocks Implementation

@implementation XMMContentBlocks

- (NSURL *) mapboxStyle {
    return _mapboxStyle ? _mapboxStyle : [NSURL URLWithString:@"mapbox://styles/xamoom-georg/ck4zb0mei1l371coyi41snaww"];
}

- (instancetype)initWithTableView:(UITableView *)tableView api:(XMMEnduserApi *)api {
  self = [super init];
  
  if (self) {
    self.api = api;
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.showAllStoreLinks = NO;
    self.showAllBlocksWhenOffline = NO;
    self.listManager = [[XMMListManager alloc] initWithApi:api];
    self.navigationType = 0;
    self.cellHeightsDictionary = @{}.mutableCopy;
    
    [self setupTableView];
    [self defaultStyle];
    
    //self.tableView.backgroundColor = [UIColor colorWithHexString:self.style.backgroundColor];
    
    [XMMContentBlock0TableViewCell setFontSize:NormalFontSize];
    [XMMContentBlock100TableViewCell setFontSize:NormalFontSize + 1];
  }
  
  return self;
}

- (void)viewWillAppear {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(clickContentNotification:)
                                               name:kContentBlock9MapContentLinkNotification
                                             object:nil];
    
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillShow:)
                                               name:keyboardWillShowNotificatoin
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(keyboardWillHide:)
                                                name:keyboardWillHideNotification
                                            object:nil];
}


- (void) keyboardWillHide:(NSNotification *)notification {
    UIEdgeInsets currentInset = self.tableView.contentInset;
    [self.tableView setContentInset:UIEdgeInsetsMake(currentInset.top, currentInset.left, currentInset.bottom - self.keyboardHeight, currentInset.right)];
    [self.tableView setScrollIndicatorInsets:currentInset];
}

-(void)keyboardWillShow:(NSNotification *)notification {
    if(notification.userInfo != nil) {
        NSDictionary *userInfo = [notification userInfo];
        CGRect keyboardRect = [userInfo[@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
        float keyboardHeight = keyboardRect.size.height;
        self.keyboardHeight = keyboardHeight;
        UIEdgeInsets currentInsets = self.tableView.contentInset;
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(currentInsets.top, currentInsets.left, keyboardHeight, currentInsets.right);
        [self.tableView setContentInset:contentInsets];
        [self.tableView setScrollIndicatorInsets:contentInsets];
    }
}

- (void)viewWillDisappear {
  [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseAllSounds" object:self];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupTableView {
  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 20.0;
  
  [self registerNibs];
}

- (void)defaultStyle {
  
  if (self.chromeColor == nil || [self.chromeColor isEqualToString:@""]) {
    self.chromeColor = @"#999999";
  }
  _style = [[XMMStyle alloc] init];
  
  self.style.backgroundColor = @"#FFFFFF";
  self.style.highlightFontColor = @"#0000FF";
  self.style.foregroundFontColor = @"#000000";
  self.style.chromeHeaderColor = self.chromeColor;
  
  if (@available(iOS 13.0, *)) {
    UIUserInterfaceStyle *userInterfaceStyle = [[UITraitCollection currentTraitCollection] userInterfaceStyle];
    if (userInterfaceStyle == UIUserInterfaceStyleDark) {
      self.style.backgroundColor = @"#000000";
      self.style.foregroundFontColor = @"#FFFFFF";
    }
  }
}

- (void)registerNibs {
  NSBundle *bundle = [NSBundle bundleForClass:[XMMContentBlocks class]];
  NSURL *url = [bundle URLForResource:@"XamoomSDK" withExtension:@"bundle"];
  NSBundle *nibBundle;
  if (url) {
    nibBundle = [NSBundle bundleWithURL:url];
  } else {
    nibBundle = bundle;
  }
  
  UINib *nib = [UINib nibWithNibName:@"XMMContentBlock100TableViewCell" bundle:nibBundle];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"XMMContentBlock100TableViewCell"];
  
  nib = [UINib nibWithNibName:@"XMMContentBlockEventTableViewCell" bundle:nibBundle];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"XMMContentBlockEventTableViewCell"];
  
  nib = [UINib nibWithNibName:@"XMMContentBlock0TableViewCell" bundle:nibBundle];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"XMMContentBlock0TableViewCell"];
  
  nib = [UINib nibWithNibName:@"XMMContentBlock1TableViewCell" bundle:nibBundle];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"XMMContentBlock1TableViewCell"];
  
  nib = [UINib nibWithNibName:@"XMMContentBlock2TableViewCell" bundle:nibBundle];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"XMMContentBlock2TableViewCell"];
  
  nib = [UINib nibWithNibName:@"XMMContentBlock3TableViewCell" bundle:nibBundle];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"XMMContentBlock3TableViewCell"];
  
  nib = [UINib nibWithNibName:@"XMMContentBlock4TableViewCell" bundle:nibBundle];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"XMMContentBlock4TableViewCell"];
  
  nib = [UINib nibWithNibName:@"XMMContentBlock5TableViewCell" bundle:nibBundle];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"XMMContentBlock5TableViewCell"];
  
  nib = [UINib nibWithNibName:@"XMMContentBlock6TableViewCell" bundle:nibBundle];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"XMMContentBlock6TableViewCell"];
  
  nib = [UINib nibWithNibName:@"XMMContentBlock7TableViewCell" bundle:nibBundle];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"XMMContentBlock7TableViewCell"];
  
  nib = [UINib nibWithNibName:@"XMMContentBlock8TableViewCell" bundle:nibBundle];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"XMMContentBlock8TableViewCell"];
  
  nib = [UINib nibWithNibName:@"XMMContentBlock9TableViewCell" bundle:nibBundle];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"XMMContentBlock9TableViewCell"];
  
  nib = [UINib nibWithNibName:@"XMMContentBlock11TableViewCell" bundle:nibBundle];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"XMMContentBlock11TableViewCell"];
  
  nib = [UINib nibWithNibName:@"XMMContentBlock12TableViewCell" bundle:nibBundle];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"XMMContentBlock12TableViewCell"];
  
  nib = [UINib nibWithNibName:@"XMMContentBlock14TableViewCell" bundle:nibBundle];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"XMMContentBlock14TableViewCell"];
    
  nib = [UINib nibWithNibName:@"XMMContentBlock15TableViewCell" bundle:nibBundle];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"XMMContentBlock15TableViewCell"];
    
}

- (void)displayContent:(XMMContent *)content {
  [self displayContent:content addHeader:YES];
}

- (void)displayContent:(XMMContent *)content addHeader:(Boolean)addHeader {
  if (addHeader) {
    self.items = [self addContentHeader:content];
  } else {
    self.items = [content.contentBlocks mutableCopy];
    XMMContentBlock *block = (XMMContentBlock *) self.items[0];
    block.copyright = content.coverImageCopyRight;
    self.items[0] = block;
  }
  
  if (!self.showAllStoreLinks) {
    self.items = [self removeStoreLinkBlocks:self.items];
  }
  
  if (!self.showAllBlocksWhenOffline && self.offline) {
    self.items = [self removeNonOfflineBlocks:self.items];
  }

  self.items = [self validContentBlockItems];
  self.content = content;
  
  if (content.relatedSpot != nil && content.relatedSpot.ID != nil) {
    [self.api spotWithID:content.relatedSpot.ID completion:^(XMMSpot *spot, NSError *error) {
      self.relatedSpot = spot;
      
      XMMContentBlock *event = [[XMMContentBlock alloc] init];
      event.publicStatus = YES;
      event.blockType = -2;
      event.title = content.title;
      event.text = content.contentDescription;
      [self.items addObject:event];

      dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
      });
    }];
  } else if (content.fromDate != nil) {
    XMMContentBlock *event = [[XMMContentBlock alloc] init];
    event.publicStatus = YES;
    event.blockType = -2;
    event.title = content.title;
    event.text = content.contentDescription;
    [self.items addObject:event];
    
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.tableView reloadData];
    });
  } else {
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.tableView reloadData];
    });
  }
}

#pragma mark - Setters

- (void)setStyle:(XMMStyle *)style {
  _style = style;
  self.tableView.backgroundColor = [UIColor colorWithHexString:style.backgroundColor];
}

#pragma mark - Getters

+ (NSString *)kContentBlock9MapContentLinkNotification {
  return kContentBlock9MapContentLinkNotification;
}

#pragma mark - Custom Methods

- (NSMutableArray *)addContentHeader:(XMMContent *)content {
  NSMutableArray *contentBlocks = [content.contentBlocks mutableCopy];
  
  XMMContentBlock *title = [[XMMContentBlock alloc] init];
  title.publicStatus = YES;
  title.blockType = 100;
  title.title = content.title;
  title.text = content.contentDescription;
  [contentBlocks insertObject:title atIndex:0];
  
  if (content.imagePublicUrl != nil && ![content.imagePublicUrl isEqualToString:@""]) {
    XMMContentBlock *image = [[XMMContentBlock alloc] init];
    image.publicStatus = YES;
    image.blockType = 3;
    image.fileID = content.imagePublicUrl;
    image.copyright = content.coverImageCopyRight;
    [contentBlocks insertObject:image atIndex:1];
  }
  
  return contentBlocks;
}

- (NSMutableArray *)removeStoreLinkBlocks:(NSMutableArray *)blocks {
  NSMutableArray *deleteBlocks = [[NSMutableArray alloc] init];
  for (XMMContentBlock *block in blocks) {
    if ((block.blockType == 4) && (block.linkType == 17 || block.linkType == 16)) {
      [deleteBlocks addObject:block];
    }
  }
  [blocks removeObjectsInArray:deleteBlocks];
  return blocks;
}

- (NSMutableArray *)removeNonOfflineBlocks:(NSMutableArray *)blocks {
  NSMutableArray *deleteBlocks = [[NSMutableArray alloc] init];
  for (XMMContentBlock *block in blocks) {
    if (block.blockType == 7) {
      [deleteBlocks addObject:block];
    }
    
    if (block.blockType == 9) {
      [deleteBlocks addObject:block];
    }
    
    if (block.blockType == 2) {
      if ([block.videoUrl containsString:@"youtu"]) {
        [deleteBlocks addObject:block];
      }
      
      if ([block.videoUrl containsString:@"vimeo"]) {
        [deleteBlocks addObject:block];
      }
    }
  }
  
  [blocks removeObjectsInArray:deleteBlocks];
  return blocks;
}

- (void)updateFontSizeTo:(TextFontSize)newFontSize {
  [XMMContentBlock0TableViewCell setFontSize:newFontSize];
  [XMMContentBlock100TableViewCell setFontSize:newFontSize + 1];
  [self.tableView reloadData];
}

- (void)clickContentNotification:(NSNotification *)notification {
  if ([notification.name isEqualToString:kContentBlock9MapContentLinkNotification]) {
    NSDictionary *userInfo = notification.userInfo;
    NSString *contentID = [userInfo objectForKey:@"contentID"];
    [self.delegate didClickContentBlock:contentID];
  }
}

/**
 * Checks if XMMContentBlock blockType has a XMMContentBlockTableViewCell class.
 * @return Array of XMMContentBlock items with valid blockTypes.
 */
- (NSMutableArray *)validContentBlockItems {
  NSUInteger index = 0;
  NSMutableArray *newItems = [NSMutableArray new];
  
  for (XMMContentBlock *block in self.items) {
    @try {
      NSString *reuseIdentifier = [NSString stringWithFormat:@"XMMContentBlock%dTableViewCell", block.blockType];
      //id cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
      [newItems addObject:block]; 
    }
    @catch (NSException *exception) {
      NSString *logException = [[NSString alloc] initWithFormat:@"Block Type %i not supported. ContentBlock at position %lu will not be shown", block.blockType, index];
      NSLog(logException);
    }
    index++;
  }
  
  return newItems;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row >= self.items.count) {
    return  [[UITableViewCell alloc] initWithFrame:CGRectZero];
  }
  
  XMMContentBlock *block = [self.items objectAtIndex:indexPath.row];
  if (block.blockType == -2) {
    XMMContentBlockEventTableViewCell *eventCell = [tableView dequeueReusableCellWithIdentifier:@"XMMContentBlockEventTableViewCell" forIndexPath:indexPath];
    [eventCell setNavigationType:self.navigationType];
    [eventCell setupCellWithContent:self.content spot:self.relatedSpot];
    return eventCell;
  }
  
    NSString *reuseIdentifier;
      id cell;
      @try {
          reuseIdentifier = [NSString stringWithFormat:@"XMMContentBlock%dTableViewCell", block.blockType];
          cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
      }
      @catch (NSException *exception){
          NSString *logException = [[NSString alloc] initWithFormat:@"Block Type %i not supported. ContentBlock will not be shown", block.blockType];
          NSLog(logException);
      }
      

    if (cell) {
      UITableViewCell *tableViewCell = (UITableViewCell *)cell;
      tableViewCell.backgroundColor = [UIColor clearColor];
    }
  
  if ([cell isKindOfClass:[XMMContentBlock100TableViewCell class]]) {
    [(XMMContentBlock100TableViewCell *) cell setRelatedSpot: self.relatedSpot];
    [(XMMContentBlock100TableViewCell *) cell setEventStartDate:self.content.fromDate];
    [(XMMContentBlock100TableViewCell *) cell setEventEndDate:self.content.toDate];
    [(XMMContentBlock100TableViewCell *) cell setNavigationType:self.navigationType];
    [(XMMContentBlock100TableViewCell *) cell setContentTilte:self.content.title];
    if (self.chromeColor != nil) {
      [(XMMContentBlock100TableViewCell *) cell setChromeColor:self.chromeColor];
    }
  }
  
  if ([cell isKindOfClass:[XMMContentBlock9TableViewCell class]] && self.mapboxStyle != nil) {
    [(XMMContentBlock9TableViewCell *) cell setMapboxStyle:self.mapboxStyle];
  }
  
  if ([cell isKindOfClass:[XMMContentBlock9TableViewCell class]] && self.navigationType != nil) {
    [(XMMContentBlock9TableViewCell *) cell setNavigationType:self.navigationType];
  }
    
  if ([cell isKindOfClass:[XMMContentBlock14TableViewCell class]] && self.mapboxStyle != nil) {
      [(XMMContentBlock14TableViewCell *) cell setMapboxStyle:self.mapboxStyle];
  }

  if ([cell isKindOfClass:[XMMContentBlock14TableViewCell class]] && self.navigationType != nil) {
      [(XMMContentBlock14TableViewCell *) cell setNavigationType:self.navigationType];
  }
    
    if ([cell isKindOfClass:[XMMContentBlock15TableViewCell class]] && self.showCBFormOverlay != nil) {
        [(XMMContentBlock15TableViewCell *) cell
         setShowCBFormOverlay:self.showCBFormOverlay];
    }
  
  if ([cell respondsToSelector:@selector(configureForCell:tableView:indexPath:style:offline:)]) {
    [cell configureForCell:block tableView:tableView indexPath:indexPath style:self.style offline:self.offline];
    return cell;
  }
  
  if ([cell respondsToSelector:@selector(configureForCell:tableView:indexPath:style:api:offline:)]) {
    [cell configureForCell:block tableView:tableView indexPath:indexPath style:self.style api:self.api offline:self.offline];
    return cell;
  }
  
  if ([cell respondsToSelector:@selector(configureForCell:tableView:indexPath:style:api:listManager:offline:delegate:)]) {
    [cell configureForCell:block tableView:tableView indexPath:indexPath style:self.style api:self.api listManager:_listManager offline:self.offline delegate:self.delegate];
    return cell;
  }
  
  return [[UITableViewCell alloc] initWithFrame:CGRectZero];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  id cell = [tableView cellForRowAtIndexPath:indexPath];
  if ([cell isKindOfClass:[XMMContentBlock2TableViewCell class]]) {
    XMMContentBlock2TableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell openVideo];
  }
  
  if ([cell isKindOfClass:[XMMContentBlock6TableViewCell class]]) {
    XMMContentBlock6TableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.delegate didClickContentBlock:cell.contentID];
  }
  
  if ([cell isKindOfClass:[XMMContentBlock8TableViewCell class]]) {
    id cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell openLink];
  }
  
  if ([cell isKindOfClass:[XMMContentBlock3TableViewCell class]]) {
    XMMContentBlock3TableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *id = cell.contentID;
      if (id != nil && ![id  isEqual: @"None"]) {
      [self.delegate didClickContentBlock:cell.contentID];
    }
    else if (self.navController != nil && self.urls != nil) {
      cell = (XMMContentBlock3TableViewCell *)cell;
      [cell setWebViewControllerNavigationTintColor: _webViewNavigationBarTintColor];
      [cell openLink:self.urls controller:self.navController];
    } else {
      [cell openLink];
    }
  }
  
  if ([cell isKindOfClass:[XMMContentBlock4TableViewCell class]]) {
    if (self.navController != nil && self.urls != nil) {
      cell = (XMMContentBlock4TableViewCell *)cell;
      [cell setWebViewControllerNavigationTintColor: _webViewNavigationBarTintColor];
      [cell openLink:self.urls controller:self.navController];
    } else {
      [cell openLink];
    }
  }
}

// save height
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.cellHeightsDictionary setObject:@(cell.frame.size.height) forKey:indexPath];
}

// give exact height value
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *height = [self.cellHeightsDictionary objectForKey:indexPath];
    if (height) return height.doubleValue;
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSNumber *height = [self.cellHeightsDictionary objectForKey:indexPath];
  if (height) return height.doubleValue;
  return UITableViewAutomaticDimension;
}

@end
