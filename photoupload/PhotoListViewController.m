//
//  ViewController.m
//  photoupload
//
//  Created by Jeff Dickey on 12/13/13.
//  Copyright (c) 2013 Jeff Dickey. All rights reserved.
//

#import "PhotoListViewController.h"

@interface PhotoListViewController ()

@end

@implementation PhotoListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"PhotoCell"];
    self.photos = @[];
    [self loadPhotos];
    UIBarButtonItem *takePhotoButton = [[UIBarButtonItem alloc]
                                        initWithTitle:@"Shoot"
                                        style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(photoButtonClicked)];
    self.navigationItem.rightBarButtonItem = takePhotoButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSURL *)rootURL
{
    return [NSURL URLWithString:@"http://bewd-60993.usw1.actionbox.io"];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    NSDictionary *photo = [self.photos objectAtIndex:indexPath.row];
    cell.label.text = [photo objectForKey:@"name"];
    NSURL *photoURL = [NSURL URLWithString:[photo objectForKey:@"photo_url"] relativeToURL:[self rootURL]];
    [cell.imageView setImageWithURL:photoURL];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (void)photoButtonClicked
{
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    cameraUI.delegate = self;
    [self.navigationController presentViewController:cameraUI animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{ @"photo": @{ @"name": @"foobar" } };
    [manager POST:@"http://bewd-60993.usw1.actionbox.io/photos.json"
       parameters:params
            constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                [formData appendPartWithFileData:imageData name:@"photo[photo]" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
            }
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self loadPhotos];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }
     ];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadPhotos
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://bewd-60993.usw1.actionbox.io/photos.json"
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             self.photos = [responseObject objectForKey:@"photos"];
             [self.collectionView reloadData];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }
     ];
}

@end
