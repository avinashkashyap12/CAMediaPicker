//
//  UIImageView+Asset.m
//  CAMediaPicker
//
//  Created by Avinash Kashyap on 12/20/16.
//  Copyright © 2016 Headerlabs. All rights reserved.
//

#import "UIImageView+Asset.h"

@implementation UIImageView (Asset)
- (void) getImageFromAsset:(PHAsset *)asset targetSize:(CGSize)size{
    PHImageManager *imageManager = [PHImageManager defaultManager];
    [imageManager requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:PHImageRequestOptionsResizeModeNone resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        self.image = result;
    }];
}
@end
