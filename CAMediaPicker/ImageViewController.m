//
//  ImageViewController.m
//  CAMediaPicker
//
//  Created by Avinash Kashyap on 12/27/16.
//  Copyright © 2016 Headerlabs. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()
{
    UIImage *aimage;
}
@end

@implementation ImageViewController
-(instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withImage:(UIImage *)image{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        aimage = image;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.aImageView.image = aimage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
