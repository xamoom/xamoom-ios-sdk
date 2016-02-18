//
//  UIImage+Scaling.h
//  XamoomSDK
//
//  Created by Raphael Seher on 18/02/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Scaling)

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height;

@end
