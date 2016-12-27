CAMediaPicker works like a UIImagePickercontroller. Its allow to select multiple images at a time from photo albums and photo libraries using "Photos Framework". It is a simple library and easy to integrate.


Features of CAMediaPicker

CAMediaPicker has a 4 options to select/add media 

1. MediaPickerSourcePhotoTypeAlbum: Allow to select multiple images at a time form photo albums and libraries.

2. MediaPickerSourceTypeImage:  Click live photo.

3. MediaPickerSourceVideoTypeAlbum: Allow to select a video from video libraries.

4. MediaPickerSourceTypeVideo: Record a live video.


Integration of CAMediaPicker:

1. First add all classes of CAMediaPicker to project.

2. Import "CAMediaManager.h" class to controller.

#import "CAMediaManager.h"

3. Create an instance of CAMediaManager.

CAMediaManager *mediaManager = [CAMediaManager sharedMediaManagerWithRootController:self];

4. Set delegate for CAMediaManage.

mediaManager.mediaPickerDelegate = self;

5. Present CAMediaPicker with setting MediaPickerSourceType

[mediaManager presentMediaPickerControllerWithSource:source];

6. Define delegate methods.


CAMediaPicker return selected media to MediaPickerDelegate.

MediaPickerDelegate contain 3 simple methods.

1.-(void) mediaPicker:(CAMediaManager *)mediaPicker didFailWithAuthorizationStatus:(PHAuthorizationStatus)status;

Above delegate method give current authentication that app can use application is authorized or not  to access photo data.


2. -(void) mediaPicker:(CAMediaManager *)mediaPicker didSelectedAssets:(NSArray *)assetList

Above delegate method give all selected media. It will give multiple images in case of selecting images from photo album, in the rest of the case it will give only one object.


3.-(void) didCancelMediaPicker:(CAMediaManager *)mediaPicker

This delegate method call, if user cancel selection of media.


 Sample code for display photo libraries and photo album(for selecting images)

CAMediaManager *mediaManager = [CAMediaManager sharedMediaManagerWithRootController:self];
    mediaManager.mediaPickerDelegate = self;
    [mediaManager presentMediaPickerControllerWithSource:MediaPickerSourcePhotoTypeAlbum]; 


Sample code for click a photo

CAMediaManager *mediaManager = [CAMediaManager sharedMediaManagerWithRootController:self];
    mediaManager.mediaPickerDelegate = self;
    [mediaManager presentMediaPickerControllerWithSource:MediaPickerSourceTypeImage]; 


Sample code for display list of all videos

 CAMediaManager *mediaManager = [CAMediaManager sharedMediaManagerWithRootController:self];
    mediaManager.mediaPickerDelegate = self;
    [mediaManager presentMediaPickerControllerWithSource:MediaPickerSourceVideoTypeAlbum]; 


Sample code for record a video

CAMediaManager *mediaManager = [CAMediaManager sharedMediaManagerWithRootController:self];
    mediaManager.mediaPickerDelegate = self;
    [mediaManager presentMediaPickerControllerWithSource:MediaPickerSourceTypeVideo];


Delegate methos

-(void) mediaPicker:(CAMediaManager *)mediaPicker didFailWithAuthorizationStatus:(PHAuthorizationStatus)status{
    if (status == PHAuthorizationStatusRestricted) {
        NSLog(@"Application not having access to use photo album and camera");
    }
   
}


-(void) mediaPicker:(CAMediaManager *)mediaPicker didSelectedAssets:(NSArray *)assetList{

     NSLog(@"Selected assets count = %zd", assetList.count);
}

-(void) didCancelMediaPicker:(CAMediaManager *)mediaPicker{
    NSLog(@"Cancel media selection");
}


CAMediaPicker works like a UIImagePickercontroller. Its allow to select multiple images at a time from photo albums and photo libraries using "Photos Framework". It is a simple library and easy to integrate.


Features of CAMediaPicker

CAMediaPicker has a 4 options to select/add media 

1. MediaPickerSourcePhotoTypeAlbum: Allow to select multiple images at a time form photo albums and libraries.

2. MediaPickerSourceTypeImage:  Click live photo.

3. MediaPickerSourceVideoTypeAlbum: Allow to select a video from video libraries.

4. MediaPickerSourceTypeVideo: Record a live video.


Integration of CAMediaPicker:

1. First add all classes of CAMediaPicker to project.

2. Import "CAMediaManager.h" class to controller.

#import "CAMediaManager.h"

3. Create an instance of CAMediaManager.

CAMediaManager *mediaManager = [CAMediaManager sharedMediaManagerWithRootController:self];

4. Set delegate for CAMediaManage.

mediaManager.mediaPickerDelegate = self;

5. Present CAMediaPicker with setting MediaPickerSourceType

[mediaManager presentMediaPickerControllerWithSource:source];

6. Define delegate methods.


CAMediaPicker return selected media to MediaPickerDelegate.

MediaPickerDelegate contain 3 simple methods.

1.-(void) mediaPicker:(CAMediaManager *)mediaPicker didFailWithAuthorizationStatus:(PHAuthorizationStatus)status;

Above delegate method give current authentication that app can use application is authorized or not  to access photo data.


2. -(void) mediaPicker:(CAMediaManager *)mediaPicker didSelectedAssets:(NSArray *)assetList

Above delegate method give all selected media. It will give multiple images in case of selecting images from photo album, in the rest of the case it will give only one object.


3.-(void) didCancelMediaPicker:(CAMediaManager *)mediaPicker

This delegate method call, if user cancel selection of media.


 Sample code for display photo libraries and photo album(for selecting images)

CAMediaManager *mediaManager = [CAMediaManager sharedMediaManagerWithRootController:self];
    mediaManager.mediaPickerDelegate = self;
    [mediaManager presentMediaPickerControllerWithSource:MediaPickerSourcePhotoTypeAlbum]; 


Sample code for click a photo

CAMediaManager *mediaManager = [CAMediaManager sharedMediaManagerWithRootController:self];
    mediaManager.mediaPickerDelegate = self;
    [mediaManager presentMediaPickerControllerWithSource:MediaPickerSourceTypeImage]; 


Sample code for display list of all videos

 CAMediaManager *mediaManager = [CAMediaManager sharedMediaManagerWithRootController:self];
    mediaManager.mediaPickerDelegate = self;
    [mediaManager presentMediaPickerControllerWithSource:MediaPickerSourceVideoTypeAlbum]; 


Sample code for record a video

CAMediaManager *mediaManager = [CAMediaManager sharedMediaManagerWithRootController:self];
    mediaManager.mediaPickerDelegate = self;
    [mediaManager presentMediaPickerControllerWithSource:MediaPickerSourceTypeVideo];


Delegate methos

-(void) mediaPicker:(CAMediaManager *)mediaPicker didFailWithAuthorizationStatus:(PHAuthorizationStatus)status{
    if (status == PHAuthorizationStatusRestricted) {
        NSLog(@"Application not having access to use photo album and camera");
    }
   
}


-(void) mediaPicker:(CAMediaManager *)mediaPicker didSelectedAssets:(NSArray *)assetList{

     NSLog(@"Selected assets count = %zd", assetList.count);
}

-(void) didCancelMediaPicker:(CAMediaManager *)mediaPicker{
    NSLog(@"Cancel media selection");
}


https://www.blogger.com/blogger.g?blogID=993268587510721134#allposts check blog post.
