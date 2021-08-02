//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMContentBlock5TableViewCell.h"

@interface XMMContentBlock5TableViewCell()

@property (strong, nonatomic) UIDocumentInteractionController *docController;
@property (nonatomic) UIColor *currentEbookColor;
@property (nonatomic) UIColor *currentEbookTintColor;

@end

@implementation XMMContentBlock5TableViewCell

static NSString *bookTitle = @"Book";

- (void)awakeFromNib {
  // Initialization code
  NSBundle *bundle = [NSBundle bundleForClass:[self class]];
  NSURL *url = [bundle URLForResource:@"XamoomSDK" withExtension:@"bundle"];
  NSBundle *imageBundle = nil;
  if (url) {
    imageBundle = [NSBundle bundleWithURL:url];
  } else {
    imageBundle = bundle;
  }
  
  self.ebookImageView.image = [[UIImage imageNamed:@"ebook"
                                          inBundle:imageBundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  
  _currentEbookColor = [UIColor colorWithRed:0.02 green:0.55 blue:0.55 alpha:1.0];
  _currentEbookTintColor = [UIColor whiteColor];
  
  self.titleLabel.text = nil;
  self.artistLabel.text = nil;
  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openInReader:)];
  [self addGestureRecognizer:tapGestureRecognizer];
  [super awakeFromNib];
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.titleLabel.text = nil;
  self.artistLabel.text = nil;
}

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style offline:(BOOL)offline {
  self.offline = offline;
  
  //set title, artist and downloadUrl
  if(block.title != nil) {
    self.titleLabel.text = block.title;
  }
  
  self.artistLabel.text = block.artists;
  self.downloadUrl = block.fileID;
  
  [self updateColors];
  bookTitle = block.title;
}

- (void)updateColors {
  self.ebookBackground.backgroundColor = _currentEbookColor;
  self.titleLabel.textColor = _currentEbookTintColor;
  self.artistLabel.textColor = _currentEbookTintColor;
  self.ebookImageView.tintColor = _currentEbookTintColor;
}

- (void)openInBrowser:(id)sender {
  //open url in safari
  if (self.offline) {
    NSURL *localURL = [self.fileManager urlForSavedData:self.downloadUrl];
    if (localURL != nil) {
      self.docController = [UIDocumentInteractionController interactionControllerWithURL:localURL];
      [self.docController presentOpenInMenuFromRect:CGRectZero inView:self.contentView animated:YES];
    }
  } else {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.downloadUrl]];
  }
}


- (void)openInReader:(id)sender {
  //download ebook and open in iBooks
    NSURL *localURL = [self.fileManager urlForSavedData:self.downloadUrl fileName:bookTitle];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isFileExists = [fileManager fileExistsAtPath:localURL.path];
    
    self.docController = [UIDocumentInteractionController interactionControllerWithURL:localURL];
    self.docController.delegate = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIDocumentInteractionController *docSavedController = self.docController;
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *url = [bundle URLForResource:@"XamoomSDK" withExtension:@"bundle"];
    if (url != nil) {
      bundle = [NSBundle bundleWithURL:url];
    }
    
    if (isFileExists) {
        [UINavigationBar appearance].tintColor = [UIColor systemBlueColor];
        [self.docController presentOpenInMenuFromRect:CGRectZero inView:self.contentView animated:YES];
    } else {
        [self.fileManager saveFileFromUrl:self.downloadUrl fileName:bookTitle completion:^(NSString *url, NSData *data, NSError *error) {
            if (data != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIViewController* activeVC = [UIApplication sharedApplication].keyWindow.rootViewController;
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTableInBundle(@"contentblock5.alert.download.book.title", @"Localizable", bundle, nil)
                                                                                             message:NSLocalizedStringFromTableInBundle(@"contentblock5.alert.download.book.description", @"Localizable", bundle, nil)
                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"OK", @"Localizable", bundle, nil)
                                                                       style:UIAlertActionStyleCancel
                                                                     handler:nil];
                    [alertController addAction:actionOk];
                    
                    UIAlertAction *actionOpen = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"OPEN", @"Localizable", bundle, nil)
                                                                       style:UIAlertActionStyleDefault
                                                                     handler:^(UIAlertAction * action) {
                        [UINavigationBar appearance].tintColor = [UIColor systemBlueColor];
                        docSavedController.delegate = activeVC;
                        [docSavedController presentOpenInMenuFromRect:CGRectZero inView:activeVC.view animated:YES];
                    }];
                    [alertController addAction:actionOpen];
                    
                    [activeVC presentViewController:alertController animated:YES completion:nil];
                });
            }
        }];
    }
}

- (XMMOfflineFileManager *)fileManager {
  if (_fileManager == nil) {
    _fileManager = [[XMMOfflineFileManager alloc] init];
  }
  return _fileManager;
}

#pragma mark - UIAppearance Getters & Setters

- (void)setEbookColor:(UIColor *)ebookColor {
  _currentEbookColor = ebookColor;
  [self updateColors];
}

- (void)setEbookTintColor:(UIColor *)ebookTintColor {
  _currentEbookTintColor = ebookTintColor;
  [self updateColors];
}

- (UIColor *)ebookColor {
  return _currentEbookColor;
}

- (UIColor *)ebookTintColor {
  return _currentEbookTintColor;
}

@end
