//
//  UIImage+Orientation.h
//  CAMediaPicker
//
//  Created by Avinash Kashyap on 12/19/16.
//  Copyright © 2016 Headerlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface UIImage (Orientation)
- (UIImage *)fixrotation:(UIImage *)image;

@end
