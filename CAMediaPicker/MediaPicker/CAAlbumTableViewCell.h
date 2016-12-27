//
//  CAAlbumTableViewCell.h
//  CAMediaPicker
//
//  Created by Avinash Kashyap on 12/20/16.
//  Copyright © 2016 Headerlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAAlbumTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;
@property (nonatomic, weak) IBOutlet UILabel *albumTitleLabel;
@property (nonatomic, weak) IBOutlet UIView *lineSeprator;
@end
