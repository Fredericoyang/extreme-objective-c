//
//  Embed_MyOrder_TVC.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/6/10.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

#import "Embed_MyOrder_TVC.h"
#import "Model/OrderModel.h"

@interface Embed_MyOrder_TVC ()

@end

@implementation Embed_MyOrder_TVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshEnabled = YES;
    [self loadData];
}


//TODO: 下拉刷新
- (void)refresh:(id)sender {
    [self loadData];
}


#pragma mark - 加载数据
- (void)loadData {
    self.noDataText = @"数据加载中";
    [self showNoData];
    if (!self.dataSource_mArray) {
        self.dataSource_mArray = [NSMutableArray array];
    }
    else {
        [self.dataSource_mArray removeAllObjects];
    }
    [self.tableView reloadData]; // 显示无数据需要先刷新表格
    NSDictionary *responseObj = @{@"code":@0, @"msg":@"Success",
                                  @"result":@[@{@"orderID":@1,@"orderName":@"标题1，此处仅作单元格标题展示"},
                                            @{@"orderID":@2,@"orderName":@"标题2，此处仅作仅作单元格标题展示"},
                                            @{@"orderID":@3,@"orderName":@"标题3，此处仅作仅作单元格标题展示"},
                                            @{@"orderID":@4,@"orderName":@"标题4，此处仅作仅作单元格标题展示"},
                                            @{@"orderID":@5,@"orderName":@"标题5，此处仅作仅作单元格标题展示"},
                                            @{@"orderID":@6,@"orderName":@"标题6，此处仅作仅作单元格标题展示"},
                                            @{@"orderID":@7,@"orderName":@"标题7，此处仅作仅作单元格标题展示"},
                                            @{@"orderID":@8,@"orderName":@"标题8，此处仅作仅作单元格标题展示"},
                                            @{@"orderID":@9,@"orderName":@"标题9，此处仅作仅作单元格标题展示"},
                                            @{@"orderID":@10,@"orderName":@"标题10，此处仅作仅作单元格标题展示"}]};
    if (self.isRefreshEnabled) {
        RUN_AFTER(1, ^{
            [self.refreshControl endRefreshing];
            
            [self fillAndReloadDataWithArray:responseObj[result_key]];
        });
    }
}

#pragma mark 解析数据并装载进数据源，刷新显示
- (void)fillAndReloadDataWithArray:(NSArray *)array {
    for (NSDictionary *dict in array) {
        NSError *error;
        OrderModel *model = [[OrderModel alloc] initWithDictionary:dict error:&error];
        if (model) {
            [self.dataSource_mArray addObject:model];
        }
    }
    if (self.dataSource_mArray.count > 0) {
        [self hideNoData];
    }
    else {
        self.noDataText = @"没有数据";
        [self showNoData];
    }
    [self.tableView reloadData];
}


#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return 0;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource_mArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier;
    cellIdentifier = @"simpleOrder_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    OrderModel *model = self.dataSource_mArray[indexPath.row];
    cell.textLabel.text = model.orderName;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
