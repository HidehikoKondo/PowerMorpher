//
//  InterfaceController.m
//  PowerMorpher WatchKit Extension
//
//  Created by UDONKONET on 2015/05/24.
//  Copyright (c) 2015年 UDONKONET. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController()

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    //カメラ起動
//    [self callParentApp];
    
    //音声入力開始
    //[self callMorphingCode];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

//タップ時
- (IBAction)letsMorphing {
    //親のカメラ起動
    [self callCamera];
}


-(void)callMorphingCode{
    NSArray* initialPhrases = @[
                                @"おはよう",
                                @"こんにちは",
                                @"こんばんは"];
    
    [self presentTextInputControllerWithSuggestions:nil
                                   allowedInputMode:WKTextInputModePlain
                                         completion:^(NSArray *results) {
                                             //音声入力
                                             if (results && results.count > 0) {
                                                 id aResult = [results objectAtIndex:0];
                                                 NSLog(@"音声入力：%@",(NSString*)aResult);
                                                 
                                                 
                                                 if([aResult isEqualToString:@"It's morphing time"]){
                                                     //Morphing Callが一致したらシャッター
                                                     [self shutter];
                                                 }else{
                                                     //とりあえずなんでもOK
                                                     [self shutter];
                                                 }
                                             }
                                             else {
                                                 // 文字が選択されていません。
                                             }
                                         }];
}



-(void)callCamera {
    // NSDictionary生成　Key:"counterValue" Value（値）:counterString(counterカウント)
    NSDictionary *applicationData = @{@"FromWatchApp":@"CAMERABOOT"};
    
    // 一つ目の引数に渡したいデータを入れればOK
    [WKInterfaceController openParentApplication:applicationData reply:^(NSDictionary *replyInfo, NSError *error) {
        NSLog(@"%@",[replyInfo objectForKey:@"FromParentApp"]);
        
        //親Appからの返信
        if([(NSString*)[replyInfo objectForKey:@"FromParentApp"]isEqualToString:@"CAMERAOPENED"]){
            //音声入力画面の起動
            [self callMorphingCode];
        }
//        else if([(NSString*)[replyInfo objectForKey:@"FromParentApp"]isEqualToString:@"CAMERACLOSED"]){
//        
//        }
    }];
}

-(void)shutter{
    // NSDictionary生成　Key:"counterValue" Value（値）:counterString(counterカウント)
    NSDictionary *applicationData = @{@"FromWatchApp":@"CAMERASHUTTER"};
    
    // 一つ目の引数に渡したいデータを入れればOK
    [WKInterfaceController openParentApplication:applicationData reply:^(NSDictionary *replyInfo, NSError *error) {
        NSLog(@"%@",[replyInfo objectForKey:@"FromParentApp"]);
    }];
}


@end



