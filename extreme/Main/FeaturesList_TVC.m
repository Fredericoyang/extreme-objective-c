//
//  FeaturesList_TVC.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/7/9.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

#import "FeaturesList_TVC.h"
#import "CodeScanerTool.h"

@interface FeaturesList_TVC ()

@end

@implementation FeaturesList_TVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"web_segue"]) {
        id destViewController = segue.destinationViewController;
        if ([destViewController isKindOfClass:[NormalBaseWebViewController class]]) {
            NormalBaseWebViewController *web_VC = destViewController;
            web_VC.url = @"http://www.xfmwk.com/";
            web_VC.needReloadByStep = NO;
        }
    }
    else if ([segue.identifier isEqualToString:@"codescan_segue"]) {
        id destViewController = ((EFBaseNavigationController *)segue.destinationViewController).topViewController;
        if ([destViewController isKindOfClass:[CodeScanerTool class]]) {
            CodeScanerTool *codeScaner_tool = destViewController;
            codeScaner_tool.Callback = ^(NSString *_Nonnull result) {
                [SVProgressHUD showInfoWithStatus:FORMAT_STRING(@"扫码成功，信息: %@", result)];
            };
        }
    }
}

@end
