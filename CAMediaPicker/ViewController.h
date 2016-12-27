//
//  ViewController.h
//  CAMediaPicker
//
//  Created by Avinash Kashyap on 11/28/16.
//  Copyright © 2016 Headerlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) NSArray *collectionList;
@property (nonatomic, weak) IBOutlet UICollectionView *listCollectionView;
-(IBAction) buttonAction:(UIButton *)sender;
@end

