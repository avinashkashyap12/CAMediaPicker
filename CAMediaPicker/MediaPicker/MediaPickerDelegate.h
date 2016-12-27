//
//  MediaPickerDelegate.h
//  CAMediaPicker
//
//  Created by Avinash Kashyap on 12/19/16.
//  Copyright © 2016 Headerlabs. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
@class CAMediaManager;

@protocol MediaPickerDelegate <NSObject>

-(void) mediaPicker:(CAMediaManager *)mediaPicker didFailWithAuthorizationStatus:(PHAuthorizationStatus)status;
-(void) mediaPicker:(CAMediaManager *)mediaPicker didSelectedAssets:(NSArray *)assetList;
-(void) didCancelMediaPicker:(CAMediaManager *)mediaPicker;
@end

