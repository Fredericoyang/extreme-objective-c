//
//  EFBaseNavigationController.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFConfig.h"

@class EFBaseViewController;

@interface EFBaseNavigationController : UINavigationController

/**
 用于在控制器基类中设置导航栏样式，基于 EFMacros中的主题色 THEME_COLOR或 THEME_COLOR_LIGHT。(Used in EFBaseViewController or EFBaseTableViewController based view controllers.)
 注意：请勿直接在导航栏实例上设置，而应该在 EFBaseViewController或者 EFBaseTableViewController的子类中的 viewWillAppear:animated:中设置类似属性。(Only setup the navigationBarStyle property on the viewWillAppear:animated: in subclasses of EFBaseViewController or EFBaseTableViewController.)
 */
@property (assign, nonatomic) EFBarStyle navigationBarStyle;

/**
 外部调用发起控制器。(Modally presenter.)
 */
@property (strong, nonatomic, nonnull) EFBaseViewController *originalViewController;

@end
