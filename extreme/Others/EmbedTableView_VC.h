//
//  EmbedTableView_VC.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/7/20.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

@interface Survey_TVCell : EFBaseTableViewCell

@property (weak, nonatomic) IBOutlet id control;

@end


@interface EmbedTableView_VC : EFBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
