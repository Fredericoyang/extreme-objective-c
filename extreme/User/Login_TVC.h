//
//  Login_TVC.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

@interface InputCell : EFBaseTableViewCell

@property (weak, nonatomic) IBOutlet UITextField *input_textField;

@end


@interface Login_TVC : EFBaseTableViewController

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;

- (IBAction)tapToChangeAPIEnv:(id)sender;

@end
