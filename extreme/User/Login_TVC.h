//
//  Login_TVC.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

@interface InputCell : EFBaseTableViewCell

@property (weak, nonatomic) IBOutlet UITextField *control;

@end


@interface Login_TVC : EFBaseTableViewController

- (IBAction)tapToChangeAPIEnv:(id)sender;

@end
