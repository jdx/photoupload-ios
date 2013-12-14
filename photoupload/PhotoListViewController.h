//
//  ViewController.h
//  photoupload
//
//  Created by Jeff Dickey on 12/13/13.
//  Copyright (c) 2013 Jeff Dickey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "PhotoCell.h"

@interface PhotoListViewController : UICollectionViewController <UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSArray *photos;
@property (nonatomic, strong) IBOutlet UICollectionViewFlowLayout *flowLayout;

@end
