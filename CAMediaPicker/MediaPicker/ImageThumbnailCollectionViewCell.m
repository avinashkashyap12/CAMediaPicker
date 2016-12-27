//
//  ImageThumbnailCollectionViewCell.m
//  MediaProtector
//
//  Created by Avinash Kashyap on 11/4/16.
//  Copyright © 2016 Headerlabs. All rights reserved.
//

#import "ImageThumbnailCollectionViewCell.h"

@implementation ImageThumbnailCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"ImageThumbnailCollectionViewCell" owner:self options:nil];
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
        self.thumbnailImageView.layer.borderColor = [UIColor colorWithRed:(CGFloat)247/255 green:(CGFloat)247/255 blue:(CGFloat)247/255 alpha:1.0].CGColor;
        self.thumbnailImageView.layer.borderWidth = 0.7;
    }
    return self;
}
@end
