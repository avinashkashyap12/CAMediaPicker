//
//  CAAlbumPickerViewController.m
//  CAMediaPicker
//
//  Created by Avinash Kashyap on 11/28/16.
//  Copyright © 2016 Headerlabs. All rights reserved.
//

#import "CAAlbumPickerViewController.h"
#import "CAImagePickerController.h"
#import "CAAlbumTableViewCell.h"
#import "UIImageView+Asset.h"

@interface CAAlbumPickerViewController ()<ImagePickerDelegate>

@end

@implementation CAAlbumPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //set title
    self.title = @"Albums";
    //add navigation button
    [self addLeftBarButton];
    //fetch all colection list
    [self fetchAllCollectionListFromDevice];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Add navigation button
-(void) addLeftBarButton{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBarButtonAction:)];
}
-(void) cancelBarButtonAction:(UIBarButtonItem *)sender{
    NSLog(@"Cacnel Action");
    [self dismissMediaPicker];
}
-(void) dismissMediaPicker{
    if(self.albumDelegate && [self.albumDelegate respondsToSelector:@selector(didCancelImageAlbumPicker:)]){
        [self.albumDelegate didCancelImageAlbumPicker:self];
    }
}
#pragma mark - fetch Album

-(void) fetchAllCollectionListFromDevice{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    //get smart album list
    PHFetchResult *smartAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    for (PHAssetCollection *collection in smartAlbum){
        NSLog(@"Title Album= %@",collection.localizedTitle);
        [tempArray addObject:@{@"AssetCollection":collection, @"ThumbnailAsset":[self getThumbnailAssetForCollection:collection]}];
    }
    //Get Album list
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    for (PHAssetCollection *collection in userAlbums){
        NSLog(@"Title Album= %@",collection.localizedTitle);
        PHAsset *asset = [self getThumbnailAssetForCollection:collection];
        if (asset == nil) {
            [tempArray addObject:@{@"AssetCollection":collection}];
        }
        else{
            [tempArray addObject:@{@"AssetCollection":collection, @"ThumbnailAsset":[self getThumbnailAssetForCollection:collection]}];
        }
        
    }
    self.assetAlbumArray = [NSArray arrayWithArray:tempArray];
    [tempArray removeAllObjects];
    [self.albumTableView reloadData];
}
-(PHAsset *) getThumbnailAssetForCollection:(PHAssetCollection *)collection{
    PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
    PHAsset *asset = [assetsFetchResult lastObject];
    return asset;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark -  TableViewDelegate and Datasource
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.assetAlbumArray.count;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"CellIdentifier";
    CAAlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[CAAlbumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSDictionary *dict = [self.assetAlbumArray objectAtIndex:indexPath.row];
    
    PHAssetCollection *collection = [self.assetAlbumArray objectAtIndex:indexPath.row][@"AssetCollection"];
    if (dict[@"ThumbnailAsset"]) {
        PHAsset *asset = [self.assetAlbumArray objectAtIndex:indexPath.row][@"ThumbnailAsset"];
        [cell.thumbnailImageView getImageFromAsset:asset targetSize:CGSizeMake(90, 90)];
    }
    cell.albumTitleLabel.text = collection.localizedTitle;
    return cell;
}
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0f];
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self displayAssetCollection:indexPath.row];
}


#pragma mark -
-(void) displayAssetCollection:(NSInteger)index{
    CAImagePickerController *imagePickerController = [[CAImagePickerController alloc] initWithNibName:@"CAImagePickerController" bundle:nil withassetCollection:[self.assetAlbumArray objectAtIndex:index][@"AssetCollection"]];
    imagePickerController.imagePickerDelegate = self;
    [self.navigationController pushViewController:imagePickerController animated:YES];
}
#pragma mark -
-(void) imagePickerDidCancel{
    [self dismissMediaPicker];
}
-(void) imagePickerDidSelectImages:(NSArray *)imageList{
    if (self.albumDelegate && [self.albumDelegate respondsToSelector:@selector(albumPicker:didSelectedAssetList:)]) {
        [self.albumDelegate albumPicker:self didSelectedAssetList:imageList];
    }
    [self dismissMediaPicker];
}
@end
