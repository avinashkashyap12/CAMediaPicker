//
//  CAImagePickerController.h
//  CAMediaPicker
//
//  Created by Avinash Kashyap on 12/19/16.
//  Copyright © 2016 Headerlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@protocol ImagePickerDelegate <NSObject>

-(void) imagePickerDidCancel;
-(void) imagePickerDidSelectImages:(NSArray *)imageList;

@end

@interface CAImagePickerController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSMutableArray *selectedIndexListArray;
}
@property (nonatomic, strong)  NSMutableArray *allImageAssetArray;
@property (nonatomic, weak) IBOutlet UICollectionView *listCollectionView;
@property (nonatomic, weak) id <ImagePickerDelegate> imagePickerDelegate;
-(instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withassetCollection:(PHAssetCollection *)collectionIdentifier;
@end
