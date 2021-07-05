//
//  ListSelector_VC.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/12/21.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

@interface ListSelector_VC : EFBaseModalDialogViewController

@property (weak, nonatomic, nullable) IBOutlet UITableView *tableView;
/**
 是否单选。(Single selection or not.)
 */
@property (assign, nonatomic) BOOL singled;
/**
 已选择的行 DataID，恢复选中状态。(For cell resume if cell selected.)
 */
@property (strong, nonatomic, nullable) NSNumber *selectedDataID;
/**
 已选择的行 DataIDs，恢复选中状态。(For cells resume if cells selected.)
 */
@property (strong, nonatomic, nullable) NSArray *selectedDataIDs;
/**
 列表选择器回调，多选时返回已选的 dataIDs和 dataNames，单选时: 元素基于 BaseDataModel的数据源返回 dataID和 dataName。(OK callback handler,  for multiple selection you will get 'dataIDs' and 'dataNames' that you selected, for single selection you will get 'dataID' and 'dataName' that you selected.)
 */
@property (strong, nonatomic, nonnull) void(^OKHandler)(NSArray *_Nonnull dataIDs, NSArray *_Nonnull dataNames);

@end
