//
//  CAAlbumTableViewCell.m
//  CAMediaPicker
//
//  Created by Avinash Kashyap on 12/20/16.
//  Copyright © 2016 Headerlabs. All rights reserved.
//

#import "CAAlbumTableViewCell.h"

@implementation CAAlbumTableViewCell
-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"CAAlbumTableViewCell" owner:self options:nil];;
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UITableViewCell class]]) {
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
