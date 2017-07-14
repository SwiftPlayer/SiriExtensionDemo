//
//  IntentViewController.m
//  SiriExtensionUI
//
//  Created by haofree on 2017/7/8.
//  Copyright © 2017年 haofree. All rights reserved.
//

#import "IntentViewController.h"
#import <Intents/Intents.h>
#import "UserInfoModel.h"
#import "SendMessageIntentView.h"
#import "SendPaymentIntentView.h"

@interface IntentViewController () <INUIHostedViewSiriProviding>

@property (nonatomic, strong) SendMessageIntentView *sendMsgView;
    
@property (nonatomic, strong) SendPaymentIntentView *sendPayView;

@end

@implementation IntentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.sendMsgView];
    [self.view addSubview:self.sendPayView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (SendMessageIntentView *)sendMsgView {
    if (!_sendMsgView) {
        _sendMsgView = [[SendMessageIntentView alloc] initWithFrame:self.view.frame];
        _sendMsgView.hidden = YES;
    }
    return _sendMsgView;
}
    
- (SendPaymentIntentView *)sendPayView {
    if (!_sendPayView) {
        _sendPayView = [[SendPaymentIntentView alloc] initWithFrame:self.view.frame];
        _sendPayView.hidden = YES;
    }
    return _sendPayView;
}
#pragma mark - INUIHostedViewControlling

// 获取siri解析的意图，准备视图展示
- (void)configureWithInteraction:(INInteraction *)interaction context:(INUIHostedViewContext)context completion:(void (^)(CGSize))completion {
    if ([interaction.intent isKindOfClass:[INSendMessageIntent class]]) {
        // 获取发送消息的意图
        INSendMessageIntent *intent = (INSendMessageIntent *)(interaction.intent);
        self.sendMsgView.hidden = NO;
        self.sendPayView.hidden = YES;
        self.sendMsgView.intent = intent;
        // 获取错误信息
        //NSUserActivity *activity = interaction.intentResponse.userActivity;        
    }else if ([interaction.intent isKindOfClass:[INSendPaymentIntent class]]) {
        // 获取转账付款的意图
        INSendPaymentIntent *intent = (INSendPaymentIntent *)(interaction.intent);
        self.sendMsgView.hidden = YES;
        self.sendPayView.hidden = NO;
        self.sendPayView.intent = intent;
    }else {
        return;
    }
    
    // block返回
    if (completion) {
        completion(CGSizeMake([self desiredSize].width, 280));
    }
}

- (CGSize)desiredSize {
    return [self extensionContext].hostedViewMaximumAllowedSize;
}

#pragma mark - INUIHostedViewSiriProviding
// 用代理方法返YES禁止默认的发消息界面
- (BOOL)displaysMessage {
    return YES;
}
  
// 用代理方法返YES禁止默认的转账的界面
- (BOOL)displaysPaymentTransaction {
    return YES;
}
@end
