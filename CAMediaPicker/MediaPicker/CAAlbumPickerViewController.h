//
//  CAAlbumPickerViewController.h
//  CAMediaPicker
//
//  Created by Avinash Kashyap on 11/28/16.
//  Copyright © 2016 Headerlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@protocol ImageAlbumDelegate;

@interface CAAlbumPickerViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *albumTableView;
@property (nonatomic, strong) NSArray *assetAlbumArray;
@property (nonatomic, weak) id <ImageAlbumDelegate> albumDelegate;
@end

@protocol ImageAlbumDelegate <NSObject>


-(void) didCancelImageAlbumPicker:(CAAlbumPickerViewController *)albumPicker;
-(void) albumPicker:(CAAlbumPickerViewController *)albumPicker didSelectedAssetList:(NSArray *)assetList;


@end
