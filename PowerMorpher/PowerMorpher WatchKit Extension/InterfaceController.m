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
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}
- (IBAction)letsMorphing {
    // NSDictionary生成　Key:"counterValue" Value（値）:counterString(counterカウント)
    NSDictionary *applicationData = @{@"FromWatchApp":[NSString stringWithFormat:@"It's Morphing Time!"]};
    
    
    // 一つ目の引数に渡したいデータを入れればOK
    [WKInterfaceController openParentApplication:applicationData reply:^(NSDictionary *replyInfo, NSError *error) {
        NSLog(@"%@",[replyInfo objectForKey:@"FromWatchApp"]);
    }];
    
}

@end



