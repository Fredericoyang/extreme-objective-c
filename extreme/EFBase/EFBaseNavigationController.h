//
//  EFBaseNavigationController.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFConfig.h"

@class EFBaseViewController;

@interface EFBaseNavigationController : UINavigationController

/**
 用于在基于 EFBaseViewController的控制器中设置导航栏样式，基于 EFMacros中的主题色 THEME_COLOR或 THEME_COLOR_LIGHT。(Setup navigation bar style in EFBaseViewController based controllers.)
 注意：请勿直接在导航控制器实例上设置，而应该在基于 EFBaseViewController的控制器中的 -viewWillAppear:animated:中设置类似属性。(Tips: Only setup the navigationBarStyle property on the -viewWillAppear:animated: in  EFBaseViewController based controllers.)
 */
@property (assign, nonatomic) EFBarStyle navigationBarStyle;

/**
 外部调用发起控制器。(Modally presenter.)
 */
@property (strong, nonatomic, nonnull) EFBaseViewController *originalViewController;

@end
