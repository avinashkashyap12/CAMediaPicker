//
//  CAImagePickerController.m
//  CAMediaPicker
//
//  Created by Avinash Kashyap on 12/19/16.
//  Copyright © 2016 Headerlabs. All rights reserved.
//

#import "CAImagePickerController.h"
#import "ImageThumbnailCollectionViewCell.h"
#import "UIImageView+Asset.h"

#define KMaxImageSelectionCount 5

@interface CAImagePickerController ()
{
    PHAssetCollection *assetCollectionIdentifier;
    CGSize thumbnailSize;
}
@end

@implementation CAImagePickerController

-(instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withassetCollection:(PHAssetCollection *)collectionIdentifier{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        assetCollectionIdentifier = collectionIdentifier;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.listCollectionView registerClass:[ImageThumbnailCollectionViewCell class] forCellWithReuseIdentifier:@"CellIdentifier"];
    //add title
    self.title = @"Select images";
    //add bar button
    [self addRightBarButton];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        thumbnailSize = CGSizeMake(100, 130);
    }
    else{
        thumbnailSize = CGSizeMake(75.5, 75.5);
    }
    [self getAllAssetsFromCollection];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Right bar button
-(void) addRightBarButton{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonAction:)];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark -
-(void) getAllAssetsFromCollection{
    self.allImageAssetArray = [[NSMutableArray alloc] init];
    
//    PHImageManager *manager = [PHImageManager defaultManager];
    PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollectionIdentifier options:nil];
    NSLog(@"Total Count = %zd", assetsFetchResult.count);
    for (PHAsset *asset in assetsFetchResult){
        [self.allImageAssetArray addObject:asset];
    }//end for loop

}
#pragma mark -
#pragma mark CollectionView Delegate and Datasource
-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.allImageAssetArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return CGSizeMake(100, 130);
    }
    return CGSizeMake(75.5, 75.5);
}
-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ImageThumbnailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    PHAsset *asset = [self.allImageAssetArray objectAtIndex:indexPath.row];
    [cell.thumbnailImageView getImageFromAsset:asset targetSize:thumbnailSize];
    if ([selectedIndexListArray containsObject:indexPath]) {
        cell.iconImageView.hidden = NO;
    }
    else{
        cell.iconImageView.hidden = YES;
    }
    return cell;
}
-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (!selectedIndexListArray) {
        selectedIndexListArray = [[NSMutableArray alloc] init];
    }
    //check if already selected
    if ([selectedIndexListArray containsObject:indexPath]) {
        NSLog(@"remove tapped index");
        [selectedIndexListArray removeObject:indexPath];
        ImageThumbnailCollectionViewCell *cell = (ImageThumbnailCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.iconImageView.hidden = YES;
        return;
    }
    //check max selection count
    if (selectedIndexListArray.count >= KMaxImageSelectionCount) {
        return;
    }
    //add selected index
    [selectedIndexListArray addObject:indexPath];
    ImageThumbnailCollectionViewCell *cell = (ImageThumbnailCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.iconImageView.hidden = NO;
}

#pragma mark -
-(void) doneButtonAction:(UIBarButtonItem *)sender{
    if (selectedIndexListArray.count == 0) {
        NSLog(@"perform cancel");
        if (self.imagePickerDelegate && [self.imagePickerDelegate respondsToSelector:@selector(imagePickerDidCancel)]) {
            [self.imagePickerDelegate imagePickerDidCancel];
        }
        return;
    }
    if (self.imagePickerDelegate && [self.imagePickerDelegate respondsToSelector:@selector(imagePickerDidSelectImages:)]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        PHImageManager *manager = [PHImageManager defaultManager];
        for(NSIndexPath *indexPath in selectedIndexListArray){
            PHAsset *asset = [self.allImageAssetArray objectAtIndex:indexPath.row];
            [manager requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                UIImage *image = [UIImage imageWithData:imageData];
                [tempArray addObject:image];
                if (tempArray.count == selectedIndexListArray.count) {
                    [self.imagePickerDelegate imagePickerDidSelectImages:tempArray];
                }
            }];

        }//end for loop
    }
}
@end
