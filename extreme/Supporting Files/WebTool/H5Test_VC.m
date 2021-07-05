//
//  H5Test_VC.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/12/22.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "H5Test_VC.h"

@interface H5Test_VC ()

@end

@implementation H5Test_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.url = @"http://www.xfmwk.com";
    self.needReloadByStep = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.scriptMessageHandlers = @[@"iOS_login"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self removeAllScriptMessageHandlers];
}


#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    [super userContentController:userContentController didReceiveScriptMessage:message];
    
    if ([message.name isEqualToString:@"iOS_login"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            EFBaseNavigationController *userNC = [EFUtils sharedControllerInstanceWithStoryName:@"Login" andStoryboardID:@"Login_NC"];
            userNC.originalViewController = self;
            [self presentViewController:userNC animated:YES completion:nil];
        });
    }
}

@end
