//
//  ListSelector_VC.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/12/21.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "ListSelector_VC.h"
#import "ListSelector_TVCell.h"

@interface ListSelector_VC ()

@end

@implementation ListSelector_VC {
    // 多选
    NSMutableArray *_dataIDs_mArray;
    NSMutableArray *_dataNames_mArray;
    // 单选
    NSIndexPath *_selectedIndexPath;
    NSString *_selectedDataName;
}

@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData];
}


#pragma mark - 加载数据
- (void)loadData {
    self.numberOfRows = self.dataSource_mArray.count;
    if (!_singled) {
        _dataIDs_mArray = [NSMutableArray array];
        _dataNames_mArray = [NSMutableArray array];
    }
    [self.tableView reloadData];
}

#pragma mark - 列表选择器回调
- (void)OKHandler:(id _Nullable)sender {
    if (_OKHandler) {
        if (!_singled) {
            if (!_dataIDs_mArray.count) {
                [SVProgressHUD showErrorWithStatus:@"请先选择"];
                return;
            }
            _OKHandler([_dataIDs_mArray copy], [_dataNames_mArray copy]);
        }
        else {
            if (!_selectedIndexPath) {
                [SVProgressHUD showErrorWithStatus:@"请先选择"];
                return;
            }
            _OKHandler(@[_selectedDataID], @[_selectedDataName]);
        }
    }
}


#pragma mark - Table view delegate

 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
     ListSelector_TVCell *cell = [tableView cellForRowAtIndexPath:indexPath];
     if (!_singled) {
         if (!cell.cellSelected) {
             cell.cellSelected = YES;
             [cell.select_imageView setImage:IMAGE(@"extreme.bundle/selected")];
             [_dataIDs_mArray addObject:cell.dataID];
             [_dataNames_mArray addObject:cell.data_label.text];
         }
         else {
             cell.cellSelected = NO;
             [cell.select_imageView setImage:IMAGE(@"extreme.bundle/unselected")];
             [_dataIDs_mArray removeObject:cell.dataID];
             [_dataNames_mArray removeObject:cell.data_label.text];
         }
     }
     else {
         if (_selectedIndexPath) {
             ListSelector_TVCell *selected_cell = [tableView cellForRowAtIndexPath:_selectedIndexPath];
             selected_cell.cellSelected = NO;
             [selected_cell.select_imageView setImage:IMAGE(@"extreme.bundle/unselected")];
         }
         cell.cellSelected = YES;
         [cell.select_imageView setImage:IMAGE(@"extreme.bundle/selected")];
         _selectedDataID = cell.dataID;
         _selectedDataName = cell.data_label.text;
         _selectedIndexPath = indexPath;
     }
     [tableView deselectRowAtIndexPath:indexPath animated:NO];
 }

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListSelector_TVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"c0"];
    BaseDataModel *model = self.dataSource_mArray[indexPath.row];
    [cell initWithModel:model];
    if (!_singled) {
        for (NSNumber *dataID in _selectedDataIDs) {
            if (model.dataID.integerValue == dataID.integerValue) { // 恢复选中状态。(Cells resume if cells selected.)
                cell.cellSelected = YES;
                [cell.select_imageView setImage:IMAGE(@"extreme.bundle/selected")];
                [_dataIDs_mArray addObject:model.dataID];
                [_dataNames_mArray addObject:model.dataName];
            }
        }
    }
    else {
        if (model.dataID.integerValue == _selectedDataID.integerValue) { // 恢复选中状态。(Cell resume if cell selected.)
            cell.cellSelected = YES;
            [cell.select_imageView setImage:IMAGE(@"extreme.bundle/selected")];
            _selectedDataName = model.dataName;
            _selectedIndexPath = indexPath;
        }
    }
    return cell;
}

@end
