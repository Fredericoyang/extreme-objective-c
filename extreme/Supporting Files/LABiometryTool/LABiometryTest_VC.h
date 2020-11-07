//
//  LABiometryTest_VC.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/4/13.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

#import "LABiometryTool.h"

@interface LABiometryTest_VC : EFBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *result_label;
- (IBAction)tapToTry:(id)sender;

@end
