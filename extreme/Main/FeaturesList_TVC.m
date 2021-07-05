//
//  FeaturesList_TVC.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/7/9.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
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
    
    //TODO: 扫一扫
    if ([segue.identifier isEqualToString:@"codescan_segue"]) {
        id destViewController = ((EFBaseNavigationController *)segue.destinationViewController).topViewController;
        if ([destViewController isMemberOfClass:[CodeScanerTool class]]) {
            CodeScanerTool *codeScaner_tool = destViewController;
            codeScaner_tool.callbackHandler = ^(NSString *_Nonnull result) {
                [SVProgressHUD showInfoWithStatus:STRING_FORMAT(@"扫码成功，信息: %@", result)];
            };
        }
    }
}

@end
