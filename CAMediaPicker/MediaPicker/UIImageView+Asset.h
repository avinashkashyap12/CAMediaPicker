//
//  UIImageView+Asset.h
//  CAMediaPicker
//
//  Created by Avinash Kashyap on 12/20/16.
//  Copyright © 2016 Headerlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface UIImageView (Asset)
- (void) getImageFromAsset:(PHAsset *)asset targetSize:(CGSize)size;
@end
