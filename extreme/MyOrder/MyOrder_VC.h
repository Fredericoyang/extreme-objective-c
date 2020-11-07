//
//  MyOrder_VC.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/6/10.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

@interface MyOrder_VC : EFBaseViewController

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *topTapButtons;

- (IBAction)tapTopTapButton:(UIButton *)sender;

@end
