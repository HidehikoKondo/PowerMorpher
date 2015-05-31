//
//  ViewController.h
//  PowerMorpher
//
//  Created by UDONKONET on 2015/05/24.
//  Copyright (c) 2015年 UDONKONET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>


@interface ViewController : UIViewController
<UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
ADInterstitialAdDelegate>
-(void)cameraBoot;
-(void)shutter;


@end

