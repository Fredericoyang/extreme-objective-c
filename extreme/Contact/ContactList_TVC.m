//
//  ContactList_TVC.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/7/30.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

#import "ContactList_TVC.h"
#import "Model/ContactModel.h"

@interface ContactList_TVC ()

@end

@implementation ContactList_TVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //TODO: 启用下拉刷新与上拉加载更多
    self.MJRefreshEnabled = YES; // 你可以先启用下拉刷新与上拉加载更多，再自定义其执行内容
    // 自定义下拉刷新与上拉加载更多的执行内容
    self.refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.refreshHeader endRefreshing];
        [SVProgressHUD showInfoWithStatus:@"你触发了自定义下拉刷新"];
    }];
    self.refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self.refreshFooter endRefreshing];
        [SVProgressHUD showInfoWithStatus:@"你触发了自定义上拉加载更多"];
    }];
//    self.MJRefreshEnabled = YES; // 或者最后再启用下拉刷新与上拉加载更多
    
    [self setNoDataImageName:@"car_animated" noDataImageExt:@"gif" width:90 height:90];
    self.noDataText = @"加载中";
    [self showNoData];
    RUN_AFTER(0.5, ^{
        [self loadData]; // 加载数据
    });
}


#pragma mark - 加载数据
- (void)loadData {
    if ([self.refreshHeader isRefreshing]) {
        [self.refreshHeader endRefreshing];
    }
    
    self.pageNumber = 1;
    self.rowsCount = 48;
    
    if (!self.dataSource_mArray) {
        self.dataSource_mArray = [NSMutableArray array];
    }
    else {
        [self.dataSource_mArray removeAllObjects];
    }
    
    NSDictionary *responseObj;
    responseObj = @{@"code":@0, @"msg":@"Success",
                    @"result":@[@{@"ContactID":@1,@"ContactName":@"王某某",@"ContactMobile":@"13678234501"},
                              @{@"ContactID":@2,@"ContactName":@"李某某",@"ContactMobile":@"13678234502"},
                              @{@"ContactID":@3,@"ContactName":@"张某某",@"ContactMobile":@"13678234503"},
                              @{@"ContactID":@4,@"ContactName":@"刘某某",@"ContactMobile":@"13678234504"},
                              @{@"ContactID":@5,@"ContactName":@"邓某某",@"ContactMobile":@"13678234505"},
                              @{@"ContactID":@6,@"ContactName":@"谢某某",@"ContactMobile":@"13678234506"},
                              @{@"ContactID":@7,@"ContactName":@"吴某某",@"ContactMobile":@"13678234507"},
                              @{@"ContactID":@8,@"ContactName":@"黄某某",@"ContactMobile":@"13678234508"},
                              @{@"ContactID":@9,@"ContactName":@"郑某某",@"ContactMobile":@"13678234509"},
                              @{@"ContactID":@10,@"ContactName":@"杨某某",@"ContactMobile":@"13678234510"}]};
    if (MJRefreshStateRefreshing==self.refreshFooter.state || MJRefreshStateNoMoreData==self.refreshFooter.state) {
        [self.refreshFooter endRefreshing];
    }
    [self fillAndReloadDataWithArray:responseObj[result_key]];
}

- (void)loadMoreDataWithPageNumber:(NSUInteger)pageNumber {
    if ([self.refreshFooter isRefreshing]) {
        [self.refreshFooter endRefreshing];
    }
    
    self.pageNumber = pageNumber;
    
    NSDictionary *responseObj;
    if (self.rowsCount > self.pageNumber*ContactHTTPRequestPerPageSize) {
        responseObj = @{@"code":@0, @"msg":@"Success",
                        @"result":@[@{@"ContactID":@(1+(pageNumber-1)*10),@"ContactName":FORMAT_STRING(@"王某某%@", @(pageNumber)),@"ContactMobile":FORMAT_STRING(@"136782345%@", @(1+(pageNumber-1)*10))},
                                  @{@"ContactID":@(2+(pageNumber-1)*10),@"ContactName":FORMAT_STRING(@"李某某%@", @(pageNumber)),@"ContactMobile":FORMAT_STRING(@"136782345%@", @(2+(pageNumber-1)*10))},
                                  @{@"ContactID":@(3+(pageNumber-1)*10),@"ContactName":FORMAT_STRING(@"张某某%@", @(pageNumber)),@"ContactMobile":FORMAT_STRING(@"136782345%@", @(3+(pageNumber-1)*10))},
                                  @{@"ContactID":@(4+(pageNumber-1)*10),@"ContactName":FORMAT_STRING(@"刘某某%@", @(pageNumber)),@"ContactMobile":FORMAT_STRING(@"136782345%@", @(4+(pageNumber-1)*10))},
                                  @{@"ContactID":@(5+(pageNumber-1)*10),@"ContactName":FORMAT_STRING(@"邓某某%@", @(pageNumber)),@"ContactMobile":FORMAT_STRING(@"136782345%@", @(5+(pageNumber-1)*10))},
                                  @{@"ContactID":@(6+(pageNumber-1)*10),@"ContactName":FORMAT_STRING(@"谢某某%@", @(pageNumber)),@"ContactMobile":FORMAT_STRING(@"136782345%@", @(6+(pageNumber-1)*10))},
                                  @{@"ContactID":@(7+(pageNumber-1)*10),@"ContactName":FORMAT_STRING(@"吴某某%@", @(pageNumber)),@"ContactMobile":FORMAT_STRING(@"136782345%@", @(7+(pageNumber-1)*10))},
                                  @{@"ContactID":@(8+(pageNumber-1)*10),@"ContactName":FORMAT_STRING(@"黄某某%@", @(pageNumber)),@"ContactMobile":FORMAT_STRING(@"136782345%@", @(8+(pageNumber-1)*10))},
                                  @{@"ContactID":@(9+(pageNumber-1)*10),@"ContactName":FORMAT_STRING(@"郑某某%@", @(pageNumber)),@"ContactMobile":FORMAT_STRING(@"136782345%@", @(9+(pageNumber-1)*10))},
                                  @{@"ContactID":@(10+(pageNumber-1)*10),@"ContactName":FORMAT_STRING(@"杨某某%@", @(pageNumber)),@"ContactMobile":FORMAT_STRING(@"136782345%@", @(10+(pageNumber-1)*10))}]};
    }
    else {
        responseObj = @{@"code":@0, @"msg":@"Success",
                        @"result":@[@{@"ContactID":@(1+(pageNumber-1)*10),@"ContactName":FORMAT_STRING(@"王某某%@", @(pageNumber)),@"ContactMobile":FORMAT_STRING(@"136782345%@", @(1+(pageNumber-1)*10))},
                                  @{@"ContactID":@(2+(pageNumber-1)*10),@"ContactName":FORMAT_STRING(@"李某某%@", @(pageNumber)),@"ContactMobile":FORMAT_STRING(@"136782345%@", @(2+(pageNumber-1)*10))},
                                  @{@"ContactID":@(3+(pageNumber-1)*10),@"ContactName":FORMAT_STRING(@"张某某%@", @(pageNumber)),@"ContactMobile":FORMAT_STRING(@"136782345%@", @(3+(pageNumber-1)*10))},
                                  @{@"ContactID":@(4+(pageNumber-1)*10),@"ContactName":FORMAT_STRING(@"刘某某%@", @(pageNumber)),@"ContactMobile":FORMAT_STRING(@"136782345%@", @(4+(pageNumber-1)*10))},
                                  @{@"ContactID":@(5+(pageNumber-1)*10),@"ContactName":FORMAT_STRING(@"邓某某%@", @(pageNumber)),@"ContactMobile":FORMAT_STRING(@"136782345%@", @(5+(pageNumber-1)*10))},
                                  @{@"ContactID":@(6+(pageNumber-1)*10),@"ContactName":FORMAT_STRING(@"谢某某%@", @(pageNumber)),@"ContactMobile":FORMAT_STRING(@"136782345%@", @(6+(pageNumber-1)*10))},
                                  @{@"ContactID":@(7+(pageNumber-1)*10),@"ContactName":FORMAT_STRING(@"吴某某%@", @(pageNumber)),@"ContactMobile":FORMAT_STRING(@"136782345%@", @(7+(pageNumber-1)*10))},
                                  @{@"ContactID":@(8+(pageNumber-1)*10),@"ContactName":FORMAT_STRING(@"黄某某%@", @(pageNumber)),@"ContactMobile":FORMAT_STRING(@"136782345%@", @(8+(pageNumber-1)*10))}]};
    }
    if ([self.refreshFooter isRefreshing]) {
        [self.refreshFooter endRefreshing];
    }
    [self fillAndReloadDataWithArray:responseObj[result_key]];
}

#pragma mark 解析数据并装载进数据源，刷新显示
- (void)fillAndReloadDataWithArray:(NSArray *)array {
    for (NSDictionary *dict in array) {
        NSError *error;
        ContactModel *model = [[ContactModel alloc] initWithDictionary:dict error:&error];
        if (model) {
            [self.dataSource_mArray addObject:model];
        }
    }
    if (self.dataSource_mArray.count>0) {
        [self hideNoData];
        
        if (array.count < ContactHTTPRequestPerPageSize) {
            [self.refreshFooter endRefreshingWithNoMoreData];
        }
    }
    else {
        [self setNoDataImageName:@"extreme.bundle/no_bill" width:88 height:105];
        self.noDataText = @"没有数据";
        [self showNoData];
    }
    [self.tableView reloadData];
}


#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
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

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource_mArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier;
    cellIdentifier = @"simpleOrder_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    ContactModel *model = self.dataSource_mArray[indexPath.row];
    cell.textLabel.text = model.dataName;
    cell.detailTextLabel.text = model.ContactMobile;
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
