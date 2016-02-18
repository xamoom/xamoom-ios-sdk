//
//  UIImage+Scaling.m
//  XamoomSDK
//
//  Created by Raphael Seher on 18/02/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import "UIImage+Scaling.h"

@implementation UIImage (Scaling)

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size {
  if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
  } else {
    UIGraphicsBeginImageContext(size);
  }
  [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return newImage;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height {
  CGFloat oldWidth = image.size.width;
  CGFloat oldHeight = image.size.height;
  
  CGFloat scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
  
  CGFloat newHeight = oldHeight * scaleFactor;
  CGFloat newWidth = oldWidth * scaleFactor;
  CGSize newSize = CGSizeMake(newWidth, newHeight);
  
  return [self imageWithImage:image scaledToSize:newSize];
}

@end
