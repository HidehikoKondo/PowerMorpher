//
//  ViewController.m
//  PowerMorpher
//
//  Created by UDONKONET on 2015/05/24.
//  Copyright (c) 2015年 UDONKONET. All rights reserved.
//

#import "ViewController.h"
#import "AVFoundation/AVFoundation.h"
#import <Social/Social.h>

@interface ViewController()
@property (weak, nonatomic) IBOutlet ADBannerView *iAdView;


@end

@implementation ViewController
UIImage *saveImage;
ADInterstitialAd *iAdInterstitial;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    //4s以下は広告非表示
    UIScreen *sc = [UIScreen mainScreen];
    if(sc.bounds.size.height < 568){
        [_iAdView setHidden:YES];
    }
    
    [self loadiAdInterstitial];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)cameraBoot{
    NSLog(@"カメラ起動");
    [self heySiri:@"Say morphing call."];
    
    //カメラを開く
    [self openCamera];
}

-(void)shutter{
    NSLog(@"シャッター");
    [self heySiri:@"It's morphing time."];
    
    //カメラが開いていたらシャッター
    [NSTimer scheduledTimerWithTimeInterval:2.0f //タイマーを発生させる間隔
                                     target:self //タイマー発生時に呼び出すメソッドがあるターゲット
                                   selector:@selector(takePhoto:) //タイマー発生時に呼び出すメソッド
                                   userInfo:nil //selectorに渡す情報(NSDictionary)
                                    repeats:NO //リピート
     ];
}

-(void)heySiri:(NSString*)message{
    AVSpeechSynthesizer* speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
    NSString* speakingText = message;
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:speakingText];
    utterance.rate = AVSpeechUtteranceDefaultSpeechRate/3;        //読み上げる速さ
    utterance.pitchMultiplier = 0.7f;                           //声の高さ
    utterance.volume = 0.7f;                                    //声の大きさ
    AVSpeechSynthesisVoice* JVoice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
    utterance.voice =  JVoice;
    
    [speechSynthesizer speakUtterance:utterance];
    
}

//カメラを開く
-(void)openCamera{
    //retake時の処理（カメラが開いていたらcameraViewのインスタンスを作りなおさない）
    if(self.cameraView){
        return;
    }
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        self.cameraView = [[UIImagePickerController alloc] init];
        [self.cameraView setDelegate:self];
        self.cameraView.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.cameraView.allowsEditing = NO;
        //        self.cameraView.showsCameraControls = YES;
        self.cameraView.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        [self presentViewController:self.cameraView animated:YES completion:nil];
    }else{
        NSLog(@"カメラがないよ");
    }
}

//シャッター
-(void)takePhoto:(NSTimer*)timer{
    [self.cameraView takePicture];
    
    NSLog(@"シャッター切ったよ");
}

#pragma -mark カメラ制御
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // オリジナル画像
    UIImage *originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
    // 編集画像
    UIImage *editedImage = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
    
    if(editedImage)
    {
        saveImage = editedImage;
    }
    else
    {
        saveImage = originalImage;
    }
    
    
    
    // UIImageViewに画像を設定
    //    self.pictureImage.image = saveImage;
    
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        // カメラから呼ばれた場合は画像をフォトライブラリに保存してViewControllerを閉じる
        UIImageWriteToSavedPhotosAlbum(saveImage, nil, nil, nil);
        [self dismissViewControllerAnimated:YES completion:^{
            [self share:saveImage];
        }];
        
        
        
    }
    else
    {
        // フォトライブラリから呼ばれた場合はPopOverを閉じる（iPad）
        //        [popover dismissPopoverAnimated:YES];
        //        [popover release];
        //        popover = nil;
    }
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    _cameraView = nil;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)context
{
    if (error) {
        // mistake
        NSLog(@"エラー");
    } else {
        // success
    }
}

-(void)share:(UIImage*)shareImage{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Share your photo."
                                                                message:@"Please Select SNS."
                                                         preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    // OK用のアクションを生成
    UIAlertAction *fbAction =
    [UIAlertAction actionWithTitle:@"Facebook"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction *action) {
                               // ボタンタップ時の処理
                               [self facebook:shareImage];
                           }];
    
    // Destructive用のアクションを生成
    UIAlertAction *twAction =
    [UIAlertAction actionWithTitle:@"Twitter"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction *action) {
                               // ボタンタップ時の処理
                               [self twitter:shareImage];
                           }];
    
    // Cancel用のアクションを生成
    UIAlertAction *cancelAction =
    [UIAlertAction actionWithTitle:@"Cancel"
                             style: UIAlertActionStyleCancel
                           handler:^(UIAlertAction *action) {
                               // ボタンタップ時の処理
                               [self interstitalAdd];
                           }];
    
    // コントローラにアクションを追加
    [ac addAction:twAction];
    [ac addAction:fbAction];
    [ac addAction:cancelAction];
    
    //    // アクションシート表示処理
    //    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    //
    //        CGRect frame = [[UIScreen mainScreen] applicationFrame];
    //
    //        ac.popoverPresentationController.sourceView = self.view;
    //        ac.popoverPresentationController.sourceRect = CGRectMake(CGRectGetMidX(frame)-60,frame.size.height-50, 120,50);
    //
    //    }
    
    [self presentViewController:ac animated:YES completion:nil];
    
}

-(void)facebook:(UIImage*)shareImage{
    
    SLComposeViewController *facebookPostVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [facebookPostVC setInitialText:@"It's Morphing Time!! \n\nhttps://itunes.apple.com/jp/app/id1013469638\n\n#MorphinCam"];
    [facebookPostVC addImage:shareImage];
    [facebookPostVC addURL:[NSURL URLWithString:@"http://www.udonko.net"]];
    
    // 処理終了後に呼び出されるコールバックを指定する
    [facebookPostVC setCompletionHandler:^(SLComposeViewControllerResult result) {
        
        switch (result) {
            case SLComposeViewControllerResultDone:
                NSLog(@"Done!!");
                [self interstitalAdd];
                break;
            case SLComposeViewControllerResultCancelled:
                NSLog(@"Cancel!!");
                [self interstitalAdd];
                [self share:shareImage];
                break;
        }
    }];
    [self presentViewController:facebookPostVC animated:YES completion:nil];
}


-(void)twitter:(UIImage*)shareImage{
    // Social Frameworkが使える
    SLComposeViewController *twitterPostVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [twitterPostVC setInitialText:@"It's Morphing Time!! \n\nhttps://itunes.apple.com/jp/app/id1013469638\n\n#MorphinCam"];
    [twitterPostVC addImage:shareImage];
    [twitterPostVC addURL:[NSURL URLWithString:@"www.udonko.net"]];
    
    // 処理終了後に呼び出されるコールバックを指定する
    [twitterPostVC setCompletionHandler:^(SLComposeViewControllerResult result) {
        
        switch (result) {
            case SLComposeViewControllerResultDone:
                NSLog(@"Done!!");
                [self interstitalAdd];
                break;
            case SLComposeViewControllerResultCancelled:
                NSLog(@"Cancel!!");
                [self interstitalAdd];
                [self share:shareImage];
                break;
        }
    }];
    
    
    [self presentViewController:twitterPostVC animated:YES completion:nil];
}

#pragma -mark iAd

-(void)interstitalAdd{
    if (iAdInterstitial.loaded) {
        [iAdInterstitial presentFromViewController:self];
        
        //        [self requestInterstitialAdPresentation];
    }
}

// iAdインタースティシャル広告読み込み
- (void)loadiAdInterstitial
{
    iAdInterstitial = [[ADInterstitialAd alloc] init];
    iAdInterstitial.delegate = self;
    self.interstitialPresentationPolicy = ADInterstitialPresentationPolicyManual;
    [self requestInterstitialAdPresentation];
}

// iAdインタースティシャル広告がロードされた時に呼ばれる
- (void)interstitialAdDidLoad:(ADInterstitialAd *)interstitialAd
{
    
    NSLog(@"iAdロード完了");
    
}

// iAdインタースティシャル広告がアンロードされた時に呼ばれる
- (void)interstitialAdDidUnload:(ADInterstitialAd *)interstitialAd
{
    iAdInterstitial = nil;
}

// iAdインタースティシャル広告の読み込み失敗時に呼ばれる
- (void)interstitialAd:(ADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error
{
    iAdInterstitial = nil;
}

// iAdインタースティシャル広告が閉じられた時に呼ばれる
- (void)interstitialAdActionDidFinish:(ADInterstitialAd *)interstitialAd
{
    iAdInterstitial = nil;
}

@end
