//
//  ImageViewController.h
//  CAMediaPicker
//
//  Created by Avinash Kashyap on 12/27/16.
//  Copyright © 2016 Headerlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController
@property (nonatomic, weak) IBOutlet UIImageView *aImageView;
-(instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withImage:(UIImage *)image;
@end
