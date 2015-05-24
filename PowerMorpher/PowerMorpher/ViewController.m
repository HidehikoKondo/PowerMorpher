//
//  ViewController.m
//  PowerMorpher
//
//  Created by UDONKONET on 2015/05/24.
//  Copyright (c) 2015年 UDONKONET. All rights reserved.
//

#import "ViewController.h"
#import "AVFoundation/AVFoundation.h"

@interface ViewController ()
@property (nonatomic, strong) UIImagePickerController *cameraView;

@end

@implementation ViewController
bool isCameraOpen = false;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    isCameraOpen = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)voice{
    if(!isCameraOpen){
        [self heySiri:@"Get Ready."];
        //カメラを開く
        [self openCamera];
        isCameraOpen = true;
    }else{
        [self heySiri:@"It's morphing time."];
        isCameraOpen = false;

        //カメラが開いていたらシャッター
        [NSTimer scheduledTimerWithTimeInterval:2.0f //タイマーを発生させる間隔
                                         target:self //タイマー発生時に呼び出すメソッドがあるターゲット
                                       selector:@selector(shutter:) //タイマー発生時に呼び出すメソッド
                                       userInfo:nil //selectorに渡す情報(NSDictionary)
                                        repeats:NO //リピート
         ];
    }
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
    self.cameraView = [[UIImagePickerController alloc] init];
    self.cameraView.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:self.cameraView animated:YES completion:nil];
}

//シャッター
-(void)shutter:(NSTimer*)timer{
    [self.cameraView takePicture];
    
}


@end
