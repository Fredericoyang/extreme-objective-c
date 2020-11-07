//
//  EFBaseTableViewController.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

#import "EFBaseTableViewController.h"
#import "EFBaseViewController.h"
#import "EFMacros.h"
#import "EFUtils.h"
#import "PodHeaders.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@interface EFBaseTableViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation EFBaseTableViewController {
    id<UIGestureRecognizerDelegate> _systemBackDelegate;
    
    UIBarButtonItem *_latestCustomBackButton;
    UIBarButtonItem *_latestCustomCancelButton;
    
    UIView *_customTableFooterView;
    
    UIView *_noDataView;
    CGFloat _noDataViewHeight;
    
    UIImageView *_noDataImageView;
    NSString *_noDataImageExt;
    CGFloat _noDataImageWidth;
    CGFloat _noDataImageHeight;
    
    UILabel *_noDataTextLabel;
    CGFloat _noDataTextWidth;
    NSUInteger _noDataTextLines;
    
    CLLocationManager* _locationManager; // 使用位置信息预授权
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (NAVIGATION_CONTROLLER && [NAVI_CTRL_ROOT_VC isEqual:self] && NAVIGATION_CONTROLLER.originalViewController && UIModalPresentationFullScreen==NAVIGATION_CONTROLLER.modalPresentationStyle) {
        self.customCancel_barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    }
    
    self.refreshEnabled = NO;
    self.MJRefreshEnabled = NO;
    
    if (@available(iOS 11.0, *)) {
        if (!self.automaticallyAdjustsScrollViewInsets) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    } else {
        // Fallback on earlier versions
    }
    if (self.tableView.tableFooterView) {
        _customTableFooterView = self.tableView.tableFooterView;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationBarStyle = EFBarStyleDefault;
    
    if (self.previousViewController && self.useCustomBack) { // 取代系统返回手势的代理
        _systemBackDelegate = NAVIGATION_CONTROLLER.interactivePopGestureRecognizer.delegate;
        NAVIGATION_CONTROLLER.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.previousViewController && self.useCustomBack) { // 恢复系统返回手势的代理
        NAVIGATION_CONTROLLER.interactivePopGestureRecognizer.delegate = _systemBackDelegate;
    }
    
    for (NSURLSessionDataTask *dataTask in self.dataTasks) { // 取消所有数据任务队列
        if (![EFUtils objectIsNullOrEmpty:dataTask]) {
            [dataTask cancel];
        }
    }
}

- (void)dealloc {
    self.adjustTableViewEdgeInsetsToFitKeyboard = NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)removeNotification {
    [NOTIFICATION_CENTER removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [NOTIFICATION_CENTER removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark 状态栏与导航
- (void)setStatusBarHidden:(BOOL)isHidden {
    _statusBarHidden = isHidden;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

- (BOOL)prefersStatusBarHidden {
    return self.statusBarHidden;
}

- (void)setNavigationBarStyle:(EFBarStyle)navigationBarStyle {
    _navigationBarStyle = navigationBarStyle;
    NAVIGATION_CONTROLLER.navigationBarStyle = navigationBarStyle;
}

- (EFNavigationBar *)navigationBar {
    if (NAVIGATION_CONTROLLER) {
        return (EFNavigationBar *)NAVIGATION_CONTROLLER.navigationBar;
    }
    return nil;
}


#pragma mark 自定义返回
- (void)setUseCustomBack:(BOOL)useCustomBack {
    _useCustomBack = useCustomBack;
    if (useCustomBack) {
        if (!_customBack_barButtonItem) {
            self.customBack_barButtonItem = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"extreme.bundle/back") style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
        }
        else {
            self.customBack_barButtonItem = _customBack_barButtonItem;
        }
    }
    else {
        self.customBack_barButtonItem = nil;
    }
}

- (void)setCustomBack_barButtonItem:(UIBarButtonItem *)customBack_barButtonItem {
    _customBack_barButtonItem = customBack_barButtonItem;
    if (_customBack_barButtonItem) {
        if (_useCustomBack) {
            if (self.previousViewController) {
                if (self.navigationItem.leftBarButtonItems.count > 0) {
                    NSMutableArray *leftBarButtonItems = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
                    if (_latestCustomBackButton) {
                        [leftBarButtonItems replaceObjectAtIndex:0 withObject:_customBack_barButtonItem];
                    }
                    else {
                        [leftBarButtonItems insertObject:_customBack_barButtonItem atIndex:0];
                    }
                    self.navigationItem.leftBarButtonItems = leftBarButtonItems;
                }
                else {
                    self.navigationItem.leftBarButtonItems = @[_customBack_barButtonItem];
                }
                _latestCustomBackButton = _customBack_barButtonItem;
            }
        }
    }
    else {
        if (_useCustomBack) {
            _customBack_barButtonItem = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"extreme.bundle/back") style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
            if (self.previousViewController) {
                if (self.navigationItem.leftBarButtonItems.count > 1) {
                    NSMutableArray *leftBarButtonItems = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
                    [leftBarButtonItems replaceObjectAtIndex:0 withObject:_customBack_barButtonItem];
                    self.navigationItem.leftBarButtonItems = leftBarButtonItems;
                }
                else {
                    self.navigationItem.leftBarButtonItems = @[_customBack_barButtonItem];
                }
            }
        }
        else {
            if (_latestCustomBackButton) {
                if (self.previousViewController) {
                    if (self.navigationItem.leftBarButtonItems.count > 1) {
                        NSMutableArray *leftBarButtonItems = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
                        [leftBarButtonItems removeObject:_latestCustomBackButton];
                        self.navigationItem.leftBarButtonItems = leftBarButtonItems;
                        self.navigationItem.leftItemsSupplementBackButton = YES;
                    }
                    else {
                        self.navigationItem.leftBarButtonItems = nil;
                    }
                }
            }
            else {
                if (self.previousViewController) {
                    if (self.navigationItem.leftBarButtonItems.count > 0) {
                        self.navigationItem.leftItemsSupplementBackButton = YES;
                    }
                    else {
                        self.navigationItem.leftBarButtonItems = nil;
                    }
                }
            }
        }
    }
}

- (void)back:(id)sender {
    if (self.tapCustomBack) {
        self.tapCustomBack(sender);
    }
    else {
        [NAVIGATION_CONTROLLER popViewControllerAnimated:YES];
    }
}

#pragma mark 自定义取消
- (void)setCustomCancel_barButtonItem:(UIBarButtonItem *)customCancel_barButtonItem {
    _customCancel_barButtonItem = customCancel_barButtonItem;
    if (_customCancel_barButtonItem) {
        if (!_latestCustomCancelButton) {
            if (NAVIGATION_CONTROLLER && [NAVI_CTRL_ROOT_VC isEqual:self] && NAVIGATION_CONTROLLER.originalViewController && UIModalPresentationFullScreen==NAVIGATION_CONTROLLER.modalPresentationStyle) {
                if (self.navigationItem.leftBarButtonItems.count > 0) {
                    NSMutableArray *leftBarButtonItems = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
                    [leftBarButtonItems insertObject:_customCancel_barButtonItem atIndex:0];
                    self.navigationItem.leftBarButtonItems = leftBarButtonItems;
                }
                else {
                    self.navigationItem.leftBarButtonItems = @[_customCancel_barButtonItem];
                }
                _latestCustomCancelButton = _customCancel_barButtonItem;
            }
        }
        else {
            if (NAVIGATION_CONTROLLER && [NAVI_CTRL_ROOT_VC isEqual:self] && NAVIGATION_CONTROLLER.originalViewController && UIModalPresentationFullScreen==NAVIGATION_CONTROLLER.modalPresentationStyle) {
                if (self.navigationItem.leftBarButtonItems.count > 1) {
                    NSMutableArray *leftBarButtonItems = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
                    [leftBarButtonItems replaceObjectAtIndex:0 withObject:_customCancel_barButtonItem];
                    self.navigationItem.leftBarButtonItems = leftBarButtonItems;
                }
                else {
                    self.navigationItem.leftBarButtonItems = @[_customCancel_barButtonItem];
                }
                _latestCustomCancelButton = _customCancel_barButtonItem;
            }
        }
    }
    else {
        if (_latestCustomCancelButton) {
            if (NAVIGATION_CONTROLLER && [NAVI_CTRL_ROOT_VC isEqual:self] && NAVIGATION_CONTROLLER.originalViewController && UIModalPresentationFullScreen==NAVIGATION_CONTROLLER.modalPresentationStyle) {
                _customCancel_barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
                if (self.navigationItem.leftBarButtonItems.count > 1) {
                    NSMutableArray *leftBarButtonItems = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
                    [leftBarButtonItems replaceObjectAtIndex:0 withObject:_customCancel_barButtonItem];
                    self.navigationItem.leftBarButtonItems = leftBarButtonItems;
                }
                else {
                    self.navigationItem.leftBarButtonItems = @[_customCancel_barButtonItem];
                }
                _latestCustomCancelButton = _customCancel_barButtonItem;
            }
        }
    }
}

- (void)cancel:(id)sender {
    if (self.tapCustomCancel) {
        self.tapCustomCancel(sender);
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - 调整Table view的边距以适应键盘
- (void)setFocusedContentOffset:(CGPoint)focusedContentOffset {
    _focusedContentOffset = focusedContentOffset;
}

- (void)setAdjustTableViewEdgeInsetsToFitKeyboard:(BOOL)isAdjust {
    _adjustTableViewEdgeInsetsToFitKeyboard = isAdjust;
    if (isAdjust) {
        [NOTIFICATION_CENTER addObserver:self
                                selector:@selector(keyboardWillShow:)
                                    name:UIKeyboardWillShowNotification
                                  object:nil];
        [NOTIFICATION_CENTER addObserver:self
                                selector:@selector(keyboardWillHide:)
                                    name:UIKeyboardWillHideNotification
                                  object:nil];
    }
    else {
        [self removeNotification];
    }
}


#pragma mark - 发起定位请求
- (void)requestLocationAuthorization:(BOOL)whenInUse {
    _locationManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled] && kCLAuthorizationStatusNotDetermined==[CLLocationManager authorizationStatus]) {
        if (whenInUse) {
            [_locationManager requestWhenInUseAuthorization];
        }
        else {
            [_locationManager requestAlwaysAuthorization];
        }
    }
}

- (void)requestLocationSuccess:(successHandler)successHandler failure:(failureHandler)failureHandler {
    CLLocationManager* locationManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled]) {
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusRestricted:
            {
                [SVProgressHUD showErrorWithStatus:@"请先到设置中关闭定位的访问限制"];
                if (failureHandler) {
                    failureHandler(locationManager, kCLAuthorizationStatusRestricted);
                }
            }
                break;
            case kCLAuthorizationStatusDenied:
            {
                if (![USER_DEFAULTS boolForKey:@"disable location"]) {
                    NSString *title = @"没有开启定位权限，是否打开设置去开启？";
                    NSString *message = @"也可以稍后从设置中开启定位权限。";
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"不再提示" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
                        [USER_DEFAULTS setBool:YES forKey:@"disable location"];
                        [USER_DEFAULTS synchronize];
                        [alert dismissViewControllerAnimated:YES completion:nil];
                        
                        [SVProgressHUD showErrorWithStatus:@"请先到设置中开启定位权限"];
                        if (failureHandler) {
                            failureHandler(locationManager, kCLAuthorizationStatusDenied);
                        }
                    }];
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"打开设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
                        if (@available(iOS 10.0, *)) {
                            [APPLICATION openURL:
                             [NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                        } else {
                            [APPLICATION openURL:
                             [NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                        }
                    }];
                    [alert addAction:cancle];
                    [alert addAction:ok];
                    if (self.containerViewController) {
                        [self.containerViewController presentViewController:alert animated:YES completion:nil];
                    }
                    else {
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                }
                else {
                    [SVProgressHUD showErrorWithStatus:@"请先到设置中开启定位权限"];
                    if (failureHandler) {
                        failureHandler(locationManager, kCLAuthorizationStatusDenied);
                    }
                }
            }
                break;
            default:
            {
                if (successHandler) {
                    successHandler(locationManager);
                }
            }
                break;
        }
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"请先到设置中开启定位权限"];
        if (failureHandler) {
            failureHandler(locationManager, kCLAuthorizationStatusDenied);
        }
    }
}


#pragma mark - 显示照片选择器
- (void)privacyCameraAuthorizationWithCompletion:(completion)completion {
    // 判断相机是否获取授权
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:
        {
            // 许可对话框没有出现，发起授权许可
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (granted) {
                        if (completion) {
                            completion();
                        }
                    }
                    else {
                        [SVProgressHUD showErrorWithStatus:@"请先到设置中开启相机权限"];
                    }
                });
            }];
        }
            break;
        case AVAuthorizationStatusRestricted:
        {
            [SVProgressHUD showErrorWithStatus:@"请先到设置中关闭相机的访问限制"];
        }
            break;
        case AVAuthorizationStatusDenied:
        {
            if (![USER_DEFAULTS boolForKey:@"disable camera"]) {
                NSString *title = @"没有开启相机权限，是否打开设置去开启？";
                NSString *message = @"也可以稍后从设置中开启相机权限。";
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"不再提示" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
                    [USER_DEFAULTS setBool:YES forKey:@"disable camera"];
                    [USER_DEFAULTS synchronize];
                    [alert dismissViewControllerAnimated:YES completion:nil];
                }];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"打开设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
                    if (@available(iOS 10.0, *)) {
                        [APPLICATION openURL:
                         [NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                    } else {
                        [APPLICATION openURL:
                         [NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    }
                }];
                [alert addAction:cancle];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else {
                [SVProgressHUD showErrorWithStatus:@"请先到设置中开启相机权限"];
            }
        }
            break;
        case AVAuthorizationStatusAuthorized:
        {
            if (completion) {
                completion();
            }
        }
            break;
        default:
            break;
    }
}

- (void)privacyPhotoLibraryAuthorizationWithCompletion:(completion)completion {
    // 判断照片是否获取授权
    PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
    switch (photoAuthorStatus) {
        case PHAuthorizationStatusNotDetermined:
        {
            // 许可对话框没有出现，发起授权许可
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status == PHAuthorizationStatusAuthorized) {
                        if (completion) {
                            completion();
                        }
                    } else {
                        [SVProgressHUD showErrorWithStatus:@"请先到设置中开启照片权限"];
                    }
                });
            }];
        }
            break;
        case PHAuthorizationStatusRestricted:
        {
            [SVProgressHUD showErrorWithStatus:@"请先到设置中关闭照片的访问限制"];
        }
            break;
        case PHAuthorizationStatusDenied:
        {
            if (![USER_DEFAULTS boolForKey:@"disable camera"]) {
                NSString *title = @"没有开启照片权限，是否打开设置去开启？";
                NSString *message = @"也可以稍后从设置中开启照片权限。";
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"不再提示" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
                    [USER_DEFAULTS setBool:YES forKey:@"disable camera"];
                    [USER_DEFAULTS synchronize];
                    [alert dismissViewControllerAnimated:YES completion:nil];
                }];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"打开设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
                    if (@available(iOS 10.0, *)) {
                        [APPLICATION openURL:
                         [NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                    } else {
                        [APPLICATION openURL:
                         [NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    }
                }];
                [alert addAction:cancle];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else {
                [SVProgressHUD showErrorWithStatus:@"请先到设置中开启照片权限"];
            }
        }
            break;
        case PHAuthorizationStatusAuthorized:
        {
            if (completion) {
                completion();
            }
        }
            break;
        default:
            break;
    }
}

- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType isFront:(BOOL)isFront {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = sourceType;
    imagePicker.mediaTypes = [NSArray arrayWithObjects:@"public.image", nil];
    if (UIImagePickerControllerSourceTypeCamera == sourceType) {
        imagePicker.cameraDevice = isFront?UIImagePickerControllerCameraDeviceFront:UIImagePickerControllerCameraDeviceRear;
    }
    if (self.containerViewController) {
        [self.containerViewController presentViewController:imagePicker animated:YES completion:nil];
    }
    else {
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)showPhotoPickerWithMessage:(NSString *_Nullable)message sourceView:(UIView *_Nonnull)sourceView completion:(completion)completion {
    [self showPhotoPickerWithMessage:message isFront:NO sourceView:sourceView completion:completion];
}

- (void)showPhotoPickerWithMessage:(NSString *_Nullable)message isFront:(BOOL)isFront sourceView:(UIView *_Nonnull)sourceView completion:(completion)completion {
    UIAlertController *alertSheet = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        if (completion) {
            completion();
        }
        [self privacyCameraAuthorizationWithCompletion:^{
            [self showImagePicker:UIImagePickerControllerSourceTypeCamera isFront:isFront];
        }];
    }];
    UIAlertAction *photo_library = [UIAlertAction actionWithTitle:@"选取照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        if (completion) {
            completion();
        }
        [self privacyPhotoLibraryAuthorizationWithCompletion:^{
            [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary isFront:isFront];
        }];
    }];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        if (completion) {
            completion();
        }
    }];
    [alertSheet addAction:camera];
    [alertSheet addAction:photo_library];
    [alertSheet addAction:cancelAction];
    
    UIPopoverPresentationController *popover = alertSheet.popoverPresentationController;
    if (popover) {
        popover.sourceView = sourceView;
        popover.sourceRect = sourceView.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    if (self.containerViewController) {
        [self.containerViewController presentViewController:alertSheet animated:YES completion:nil];
    }
    else {
        [self presentViewController:alertSheet animated:YES completion:nil];
    }
}

#pragma mark - Image picker controller delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    if (self.photoPickerResult) {
        self.photoPickerResult(picker, info);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.tapCustomBack) {
        self.tapCustomBack(self.customBack_barButtonItem);
        return NO;
    }
    return self.previousViewController!=nil;
}


#pragma mark - API调用与数据源
#pragma mark API调用任务对象集
- (NSMutableArray *)dataTasks {
    if (!_dataTasks) {
        _dataTasks = [NSMutableArray array];
    }
    return _dataTasks;
}

#pragma mark 添加下拉刷新，如果支持的话
- (void)setRefreshEnabled:(BOOL)refreshEnabled {
    _refreshEnabled = refreshEnabled;
    if (refreshEnabled) {
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
        self.refreshControl = refreshControl;
    }
    else {
        self.refreshControl = nil;
    }
}
- (void)refresh:(id)sender {}

- (void)setMJRefreshEnabled:(BOOL)MJRefreshEnabled {
    _MJRefreshEnabled = MJRefreshEnabled;
    if (MJRefreshEnabled) {
        if (!_refreshHeader) {
            _refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [self loadData];
            }];
        }
        self.tableView.mj_header = _refreshHeader;
    }
    else {
        self.tableView.mj_header = nil;
    }
}
- (void)setRefreshHeader:(MJRefreshNormalHeader *)refreshHeader {
    _refreshHeader = refreshHeader;
    
    if (_MJRefreshEnabled) {
        self.tableView.mj_header = _refreshHeader;
    }
    else {
        self.tableView.mj_header = nil;
    }
}
- (void)setRefreshFooter:(MJRefreshBackNormalFooter *)refreshFooter {
    _refreshFooter = refreshFooter;
    
    if (_MJRefreshEnabled) {
        self.tableView.mj_footer = _refreshFooter;
    }
    else {
        self.tableView.mj_footer = nil;
    }
}
- (void)loadData {}
- (void)loadMoreDataWithPageNumber:(NSUInteger)pageNumber {}

#pragma mark - 没有数据提示显示与隐藏（添加上拉加载更多，如果支持的话）
- (void)showNoData {
    if (self.containerViewController) {
        _noDataViewHeight = self.tableViewHeight;
    }
    else {
        _noDataViewHeight = FRAME_HEIGHT(self.tableView) - TOP_LAYOUT_HEIGHT;
    }
    if (self.tableView.tableHeaderView) {
        _noDataViewHeight -= FRAME_HEIGHT(self.tableView.tableHeaderView);
    }
    if (@available(iOS 11.0, *)) {
        _noDataViewHeight -= SAFEAREA_INSETS.bottom;
    }
    
    if (!_noDataView) {
        _noDataView = [[UIView alloc] init];
        _noDataView.backgroundColor = COLOR_RGB_ALPHA(0xFFFFFF, 0);
    }
    if (!_noDataImageView) {
        _noDataImageView = [[UIImageView alloc] init];
        [_noDataView addSubview:_noDataImageView];
    }
    if (!_noDataTextLabel) {
        _noDataTextLabel = [[UILabel alloc] init];
        _noDataTextLabel.text = @"没有数据显示";
        _noDataTextLabel.font = FONT_SIZE(14);
        _noDataTextLabel.textColor = COLOR_RGB(0x999999);
        _noDataTextLabel.textAlignment = NSTextAlignmentCenter;
        [_noDataView addSubview:_noDataTextLabel];
    }
    
    [self updateNoDataImageAndText];
}

- (void)hideNoData {
    self.tableView.tableFooterView = _customTableFooterView;
    if (_MJRefreshEnabled) {
        if (!_refreshFooter) {
            _refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                if (self.dataSource_mArray.count < self.rowsCount) {
                    self.pageNumber++;
                    [self loadMoreDataWithPageNumber:self.pageNumber];
                }
                else {
                    [self.refreshFooter endRefreshingWithNoMoreData];
                }
            }];
        }
        self.tableView.mj_footer = _refreshFooter;
    }
    else {
        self.tableView.mj_footer = nil;
    }
}

- (void)updateNoDataImageAndText {
    self.tableView.tableFooterView = _noDataView;
    _noDataView.sd_layout
    .heightIs(_noDataViewHeight);
    
    if (_MJRefreshEnabled) {
        self.tableView.mj_footer = nil;
    }
    
    if (_noDataImageName && _noDataText) {
        [UIView animateWithDuration:0.2f animations:^{
            self->_noDataImageView.hidden = NO;
            self->_noDataTextLabel.hidden = NO;
            
            self->_noDataImageView.sd_layout
            .centerXEqualToView(self->_noDataView)
            .centerYIs((self->_noDataViewHeight/2)-((self->_noDataImageHeight>0?self->_noDataImageHeight:100)/2)-5)
            .widthIs(self->_noDataImageWidth>0?self->_noDataImageWidth:100)
            .heightIs(self->_noDataImageHeight>0?self->_noDataImageHeight:100);
            
            self->_noDataTextLabel.sd_layout
            .centerXEqualToView(self->_noDataView)
            .centerYIs(self->_noDataView.centerY_sd+30*(self->_noDataTextLines>0?self->_noDataTextLines:1)/2+5)
            .widthIs(self->_noDataTextWidth>0?self->_noDataTextWidth:160)
            .heightIs(30*(self->_noDataTextLines>0?self->_noDataTextLines:1));
            
            [self->_noDataImageView updateLayout];
            [self->_noDataTextLabel updateLayout];
        }];
    }
    else if (_noDataImageName && !_noDataText) {
        [UIView animateWithDuration:0.2f animations:^{
            self->_noDataImageView.hidden = NO;
            self->_noDataTextLabel.hidden = YES;
            self->_noDataImageView.sd_layout
            .centerXEqualToView(self->_noDataView)
            .centerYIs(self->_noDataViewHeight/2)
            .widthIs(self->_noDataImageWidth>0?self->_noDataImageWidth:100)
            .heightIs(self->_noDataImageHeight>0?self->_noDataImageHeight:100);
            
            [self->_noDataImageView updateLayout];
            [self->_noDataTextLabel updateLayout];
        }];
    }
    else if (!_noDataImageName && _noDataText) {
        [UIView animateWithDuration:0.2f animations:^{
            self->_noDataImageView.hidden = YES;
            self->_noDataTextLabel.hidden = NO;
            self->_noDataTextLabel.sd_layout
            .centerXEqualToView(self->_noDataView)
            .centerYIs(self->_noDataViewHeight/2)
            .widthIs(self->_noDataTextWidth>0?self->_noDataTextWidth:160)
            .heightIs(30*(self->_noDataTextLines>0?self->_noDataTextLines:1));
            
            [self->_noDataImageView updateLayout];
            [self->_noDataTextLabel updateLayout];
        }];
    }
    else {
        [UIView animateWithDuration:0.2f animations:^{
            self->_noDataImageView.hidden = YES;
            self->_noDataTextLabel.hidden = NO;
            self->_noDataTextLabel.sd_layout
            .centerXEqualToView(self->_noDataView)
            .centerYIs(self->_noDataViewHeight/2)
            .widthIs(160)
            .heightIs(30);
            
            [self->_noDataImageView updateLayout];
            [self->_noDataTextLabel updateLayout];
        }];
    }
}

#pragma mark 没有数据提示自定义项
- (void)initImageViewWithImage {
    if (!_noDataView) {
        _noDataView = [[UIView alloc] init];
        _noDataView.backgroundColor = COLOR_RGB_ALPHA(0xFFFFFF, 0);
    }
    if (!_noDataImageView) {
        _noDataImageView = [[UIImageView alloc] init];
        [_noDataView addSubview:_noDataImageView];
    }
    if (_noDataImageExt && [_noDataImageExt isEqualToString:@"gif"]) {
        NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
        UIImage *image = [UIImage imageWithContentsOfFile:FORMAT_STRING(@"%@/%@.%@", resourcePath, _noDataImageName, _noDataImageExt)];
        NSData *image_data = [NSData dataWithContentsOfFile:FORMAT_STRING(@"%@/%@@%.0fx.%@", resourcePath, _noDataImageName, image.scale, _noDataImageExt)];
        UIImage *animated_image = [UIImage sd_animatedGIFWithData:image_data];
        _noDataImageView.image = animated_image;
    }
    else {
        UIImage *noDataImage = IMAGE(_noDataImageName);
        _noDataImageView.image = noDataImage;
    }
    if (!_noDataTextLabel) {
        _noDataTextLabel = [[UILabel alloc] init];
        [_noDataView addSubview:_noDataTextLabel];
    }
    
    [self updateNoDataImageAndText];
}
- (void)setNoDataImageName:(NSString *)noDataImageName {
    [self setNoDataImageName:noDataImageName noDataImageExt:nil width:0 height:0];
}
- (void)setNoDataImageName:(NSString *)noDataImageName width:(CGFloat)width height:(CGFloat)height {
    [self setNoDataImageName:noDataImageName noDataImageExt:nil width:width height:height];
}
- (void)setNoDataImageName:(NSString *)noDataImageName noDataImageExt:(NSString *)noDataImageExt {
    [self setNoDataImageName:noDataImageName noDataImageExt:noDataImageExt width:0 height:0];
}
- (void)setNoDataImageName:(NSString *)noDataImageName noDataImageExt:(NSString *)noDataImageExt width:(CGFloat)width height:(CGFloat)height {
    _noDataImageName = noDataImageName;
    _noDataImageExt = noDataImageExt;
    if (width > 0) {
        _noDataImageWidth = width;
    }
    if (height > 0) {
        _noDataImageHeight = height;
    }
    [self initImageViewWithImage];
}

- (void)initTextLabelWithText {
    if (!_noDataView) {
        _noDataView = [[UIView alloc] init];
        _noDataView.backgroundColor = COLOR_RGB_ALPHA(0xFFFFFF, 0);
    }
    if (!_noDataImageView) {
        _noDataImageView = [[UIImageView alloc] init];
        [_noDataView addSubview:_noDataImageView];
    }
    if (!_noDataTextLabel) {
        _noDataTextLabel = [[UILabel alloc] init];
        [_noDataView addSubview:_noDataTextLabel];
    }
    _noDataTextLabel.text = _noDataText?:@"没有数据显示";
    _noDataTextLabel.font = FONT_SIZE(14);
    _noDataTextLabel.textColor = COLOR_RGB(0x999999);
    _noDataTextLabel.textAlignment = NSTextAlignmentCenter;
    _noDataTextLabel.numberOfLines = _noDataTextLines;
    
    [self updateNoDataImageAndText];
}
- (void)setNoDataText:(NSString *)noDataText {
    [self setNoDataText:noDataText width:0 lines:1];
}
- (void)setNoDataText:(NSString *)noDataText width:(CGFloat)width {
    [self setNoDataText:noDataText width:width lines:1];
}
- (void)setNoDataText:(NSString *)noDataText lines:(NSUInteger)lines {
    [self setNoDataText:noDataText width:0 lines:lines];
}
- (void)setNoDataText:(NSString *)noDataText width:(CGFloat)width lines:(NSUInteger)lines {
    _noDataText = noDataText;
    _noDataTextWidth = width;
    if (lines > 0) {
        _noDataTextLines = lines;
    }
    [self initTextLabelWithText];
}


#pragma mark - Keyboard notification
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    if (_focusedContentOffset.y > 0) {
        [self.tableView setContentOffset:CGPointMake(0, _focusedContentOffset.y-10)];
    }
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [self.tableView setContentInset:UIEdgeInsetsZero];
}


#pragma mark - 导航
// 弹出或者推基于 storyboard 的控制器，过程中可能需要在这里做一点点处理
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    id srcViewController = segue.sourceViewController;
    id destViewController = segue.destinationViewController;
    
    if ([destViewController isKindOfClass:[EFBaseNavigationController class]]) { // dest present modally
        EFBaseNavigationController *presented_NC = (EFBaseNavigationController *)destViewController;
        if (((EFBaseViewController *)srcViewController).containerViewController) { // src embed
            presented_NC.originalViewController = ((EFBaseViewController *)srcViewController).containerViewController;
        }
        else {
            presented_NC.originalViewController = srcViewController;
        }
    }
    else if ([destViewController isKindOfClass:[EFBaseViewController class]]) {
        EFBaseViewController *baseVC = destViewController;
        if (((EFBaseViewController *)srcViewController).containerViewController) { // src embed
            baseVC.previousViewController = ((EFBaseViewController *)srcViewController).containerViewController;
        }
        else {
            baseVC.previousViewController = srcViewController;
        }
    }
    else if ([destViewController isKindOfClass:[EFBaseTableViewController class]]) {
        EFBaseViewController *baseVC = destViewController;
        if (srcViewController == sender) { // dest embed
            baseVC.containerViewController = srcViewController;
        }
        else {
            if (((EFBaseViewController *)srcViewController).containerViewController) { // src embed
                baseVC.previousViewController = ((EFBaseViewController *)srcViewController).containerViewController;
            }
            else {
                baseVC.previousViewController = srcViewController;
            }
        }
    }
}

@end

