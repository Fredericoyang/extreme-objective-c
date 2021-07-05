//
//  ContactList_TVC.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/7/30.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "ContactList_TVC.h"
#import "Model/ContactModel.h"

@interface ContactList_TVC ()

@end

@implementation ContactList_TVC {
    NSMutableArray *_jobs_mArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //TODO: 启用刷新
    self.refreshEnabled = YES;
    
    //TODO: 启用下拉刷新与上拉加载更多，如果没有自定义执行内容，将执行缺省执行内容
//    self.MJRefreshEnabled = YES; // 你可以先启用功能，再自定义执行内容
//    // 或者先自定义执行内容
//    self.refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self.refreshHeader endRefreshing];
//        [SVProgressHUD showInfoWithStatus:@"你触发了自定义下拉刷新"];
//    }];
//    self.refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        [self.refreshFooter endRefreshing];
//        [SVProgressHUD showInfoWithStatus:@"你触发了自定义上拉加载更多"];
//    }];
//    self.MJRefreshEnabled = YES; // 最后再启用功能
    
    NSArray *dataSource_array = @[@{@"dataID": @1, @"dataName": @"子公司1", @"SecondLevel": @[@{@"dataID": @1001, @"dataName": @"职称1001"}, @{@"dataID": @1002, @"dataName": @"职称1002"}, @{@"dataID": @1003, @"dataName": @"职称1003"}]},
                                  @{@"dataID": @2, @"dataName": @"子公司2", @"SecondLevel": @[@{@"dataID": @2001, @"dataName": @"职称2001"}, @{@"dataID": @2002, @"dataName": @"职称2002"}, @{@"dataID": @2003, @"dataName": @"职称2003"}]},
                                  @{@"dataID": @3, @"dataName": @"子公司3", @"SecondLevel": @[@{@"dataID": @3001, @"dataName": @"职称3001"}, @{@"dataID": @3002, @"dataName": @"职称3002"}, @{@"dataID": @3003, @"dataName": @"职称3003"}]},
                                  @{@"dataID": @4, @"dataName": @"子公司4", @"SecondLevel": @[@{@"dataID": @4001, @"dataName": @"职称4001"}, @{@"dataID": @4002, @"dataName": @"职称4002"}, @{@"dataID": @4003, @"dataName": @"职称4003"}]},
                                  @{@"dataID": @5, @"dataName": @"子公司5", @"SecondLevel": @[@{@"dataID": @5001, @"dataName": @"职称5001"}, @{@"dataID": @5002, @"dataName": @"职称5002"}, @{@"dataID": @5003, @"dataName": @"职称5003"}]},
                                  @{@"dataID": @6, @"dataName": @"子公司6", @"SecondLevel": @[@{@"dataID": @6001, @"dataName": @"职称6001"}, @{@"dataID": @6002, @"dataName": @"职称6002"}]},
                                  @{@"dataID": @7, @"dataName": @"子公司7", @"SecondLevel": @[@{@"dataID": @7001, @"dataName": @"职称7001"}, @{@"dataID": @7002, @"dataName": @"职称7002"}]},
                                  @{@"dataID": @8, @"dataName": @"子公司8", @"SecondLevel": @[@{@"dataID": @8001, @"dataName": @"职称8001"}, @{@"dataID": @8002, @"dataName": @"职称8002"}]}];
    _jobs_mArray = [NSMutableArray array];
    for (NSDictionary *dict in dataSource_array) {
        NSError *error;
        LevelOneModel *model = [[LevelOneModel alloc] initWithDictionary:dict error:&error];
        if (model) {
            [_jobs_mArray addObject:model];
        }
    }
    
    [self loadData]; // 加载数据
}


#pragma mark - 加载数据并显示
//MARK: 模拟数据
- (NSDictionary *)responseObj {
    NSInteger rowsCount = 48;
    NSMutableArray *results_mArray = [NSMutableArray array];
    NSInteger n = rowsCount>self.pageNumber*contactHTTPRequestPerPageSize ? contactHTTPRequestPerPageSize : rowsCount%contactHTTPRequestPerPageSize;
    for (NSInteger i = 1; i <= n; i++) {
        NSDictionary *result_dictionary = @{@"ContactID":@(i+(self.pageNumber-1)*10),
                                            @"ContactName":STRING_FORMAT(@"王某某%@", @(i+(self.pageNumber-1)*10)),
                                            @"ContactMobile":STRING_FORMAT(@"136782345%@", @(i+(self.pageNumber-1)*10)),
                                            @"ContactInfo":@[@{@"dataID":@(i+(self.pageNumber-1)*10+100),
                                                               @"dataName":@"地址",
                                                               @"dataContent":STRING_FORMAT(@"南京市江宁区%@号", @(1+(self.pageNumber-1)*10))},
                                                             @{@"dataID":@(i+(self.pageNumber-1)*10+200),
                                                               @"dataName":@"邮箱",
                                                               @"dataContent":STRING_FORMAT(@"xxx_%@@126.com", @(self.pageNumber-1))}]};
        [results_mArray addObject:result_dictionary];
    }
    NSDictionary *responseObj = @{@"code":@0,
                                  @"msg":@"Success",
                                  @"totalCount":@(rowsCount),
                                  @"result":results_mArray};
    return responseObj;
}

#pragma mark 加载数据

- (void)loadData {
    self.pageNumber = 1;
    
    if (!self.dataSource_mArray) {
        self.dataSource_mArray = [NSMutableArray array];
    }
    else {
        [self.dataSource_mArray removeAllObjects];
    }
    [self.tableView reloadData];
    
    self.noDataText = @"加载中";
    [self setNoDataImageName:@"car_animated" noDataImageExt:@"gif" width:90 height:90];
    [self showNoData];
    
    RUN_AFTER(0.5, ^{
        if (self.isRefreshEnabled) {
            [self.refreshControl endRefreshing];
        }
        /// MJRefresh Enabled
//        if ([self.refreshHeader isRefreshing]) {
//            [self.refreshHeader endRefreshing];
//        }
//        if ([self.refreshFooter isRefreshing]) {
//            [self.refreshFooter endRefreshing];
//        }
//        else if (MJRefreshStateNoMoreData == self.refreshFooter.state) {
//            [self.refreshFooter endRefreshing];
//        }
//
//        self.rowsCount = [[self responseObj][@"totalCount"] integerValue];
        ///
        
        [self fillAndReloadDataWithArray:[self responseObj][result_key]];
    });
}

/// MJRefresh Enabled
//#pragma mark 加载更多数据
//- (void)loadMoreDataWithPageNumber:(NSUInteger)pageNumber {
//    self.pageNumber = pageNumber;
//
//    RUN_AFTER(0.5, ^{
//        if ([self.refreshFooter isRefreshing]) {
//            [self.refreshFooter endRefreshing];
//        }
//
//        [self fillAndReloadDataWithArray:[self responseObj][result_key]];
//    });
//}
///

#pragma mark 解析数据并装载进数据源，刷新显示

- (void)fillAndReloadDataWithArray:(NSArray *)array {
    for (NSDictionary *dict in array) {
        NSError *error;
        ContactModel *model = [[ContactModel alloc] initWithDictionary:dict error:&error];
        if (model) {
            [self.dataSource_mArray addObject:model];
        }
    }
    if (self.dataSource_mArray.count > 0) {
        [self hideNoData];
        
        /// MJRefresh Enabled
//        if (self.dataSource_mArray.count == self.rowsCount) {
//            [self.refreshFooter endRefreshingWithNoMoreData];
//        }
        ///
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return 0;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
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
    cell.detailTextLabel.text = model.contactName;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     [super prepareForSegue:segue sender:sender];
     
     id dest_VC = [segue destinationViewController];
     if ([dest_VC isKindOfClass:[UINavigationController class]]) {
         EFBaseViewController *root_VC = [((EFBaseNavigationController *)dest_VC).viewControllers firstObject];
         if ([root_VC isKindOfClass:[EFBaseModalDialogViewController class]]) {
             if ([segue.identifier isEqualToString:@"levelSelector_segue"]) {
                 LevelSelector_VC *level_selector = (LevelSelector_VC *)root_VC;
                 level_selector.navigationBarDark = YES;
                 level_selector.iconImageName = @"extreme.bundle/icon-default-modal";
                 level_selector.titleText = @"显示筛选";
                 level_selector.dataSource_mArray = [_jobs_mArray copy];
                 @WeakObject(level_selector);
                 @WeakObject(self);
                 level_selector.OKHandler = ^(NSNumber * _Nonnull dataID, NSString * _Nonnull dataText) {
                     @StrongObject(level_selector);
                     @StrongObject(self);
                     [SVProgressHUD showInfoWithStatus:dataText];
                     [self loadData];
                     [level_selector closeModalDialog];
                 };
             }
         }
     }
 }

@end
