//
//  EFBaseViewController.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "EFBaseViewController.h"
#import "EFNavigationBar.h"
#import "EFBaseTableViewCell.h"
#import "EFBaseTableViewController.h"
#import "EFUtils.h"
#import "PodHeaders.h"
#import <AVFoundation/AVFoundation.h>

@interface EFBaseViewController ()

@end

@implementation EFBaseViewController {
    id<UIGestureRecognizerDelegate> _systemBackDelegate;
    
    UIBarButtonItem *_normalCancel_barButtonItem;
    UIBarButtonItem *_latestCustomBackButton;
    
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
    
    CLLocationManager *_locationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.5最终版无缝过渡
    if ([USER_DEFAULTS boolForKey:@"disable location"]) {
        [USER_DEFAULTS setBool:YES forKey:@"Disable location"];
        [USER_DEFAULTS removeObjectForKey:@"disable location"];
    }
    if ([USER_DEFAULTS boolForKey:@"disable camera"]) {
        [USER_DEFAULTS setBool:YES forKey:@"Disable camera"];
        [USER_DEFAULTS removeObjectForKey:@"disable camera"];
    }
    
    // 弹出显示自动添加取消
    if (NAVIGATION_CONTROLLER && [NAVI_CTRL_ROOT_VC isEqual:self] && NAVIGATION_CONTROLLER.originalViewController && UIModalPresentationFullScreen==NAVIGATION_CONTROLLER.modalPresentationStyle) {
        _normalCancel_barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
        if (self.navigationItem.leftBarButtonItems.count > 0) {
            NSMutableArray *leftBarButtonItems = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
            [leftBarButtonItems insertObject:_normalCancel_barButtonItem atIndex:0];
            [self.navigationItem setLeftBarButtonItems:leftBarButtonItems animated:YES];
        }
        else {
            [self.navigationItem setLeftBarButtonItems:@[_normalCancel_barButtonItem] animated:YES];
        }
    }
    
    // 导航跳转显示自动添加返回
    if (self.previousViewController) {
        self.navigationItem.leftItemsSupplementBackButton = YES;
    }
    
    // 嵌入的 tableView初始化参数
    _numberOfRows = 0;
    _sections = 1;
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
        if (![EFUtils objectIsNilOrNull:dataTask]) {
            [dataTask cancel];
        }
    }
}

- (void)dealloc {
    if (self.tableView) {
        self.adjustTableViewEdgeInsetsToFitKeyboard = NO;
    }
    
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)removeNotification {
    if (self.tableView) {
        [NOTIFICATION_CENTER removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [NOTIFICATION_CENTER removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
}


#pragma mark - 状态栏与导航

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
    
    if ([self.navigationBar isMemberOfClass:[EFNavigationBar class]]) {
        if (EFBarStyleDefault == navigationBarStyle) {
            self.navigationBar.dark = NO;
        }
        else {
            self.navigationBar.dark = YES;
        }
    }
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
        if (_useCustomBack && self.previousViewController) {
            if (self.navigationItem.leftBarButtonItems.count > 0) {
                NSMutableArray *leftBarButtonItems = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
                if (_latestCustomBackButton) {
                    [leftBarButtonItems replaceObjectAtIndex:0 withObject:_customBack_barButtonItem];
                }
                else {
                    [leftBarButtonItems insertObject:_customBack_barButtonItem atIndex:0];
                }
                [self.navigationItem setLeftBarButtonItems:leftBarButtonItems animated:YES];
            }
            else {
                [self.navigationItem setLeftBarButtonItems:@[_customBack_barButtonItem] animated:YES];
            }
            
            self.navigationItem.leftItemsSupplementBackButton = NO;
            _latestCustomBackButton = _customBack_barButtonItem;
        }
    }
    else {
        if (_useCustomBack) {
            _customBack_barButtonItem = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"extreme.bundle/back") style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
            if (self.previousViewController && self.navigationItem.leftBarButtonItems.count>0) {
                NSMutableArray *leftBarButtonItems = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
                [leftBarButtonItems replaceObjectAtIndex:0 withObject:_customBack_barButtonItem];
                [self.navigationItem setLeftBarButtonItems:leftBarButtonItems animated:YES];
                
                self.navigationItem.leftItemsSupplementBackButton = NO;
                _latestCustomBackButton = _customBack_barButtonItem;
            }
        }
        else {
            if (_latestCustomBackButton) {
                if (self.previousViewController) {
                    if (self.navigationItem.leftBarButtonItems.count > 1) {
                        NSMutableArray *leftBarButtonItems = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
                        [leftBarButtonItems removeObject:_latestCustomBackButton];
                        [self.navigationItem setLeftBarButtonItems:leftBarButtonItems animated:YES];
                    }
                    else {
                        [self.navigationItem setLeftBarButtonItems:nil animated:YES];
                    }
                    
                    self.navigationItem.leftItemsSupplementBackButton = YES;
                    _latestCustomBackButton = nil;
                }
            }
        }
    }
}

- (void)back:(id)sender {
    if (self.customBackHandler) {
        self.customBackHandler(sender);
    }
    else if (self.tapCustomBack) {
        self.tapCustomBack(sender);
        NSLog(@"[WARNING]tapCustomBack is deprecated, use customBackHandler instead.");
    }
    else {
        [NAVIGATION_CONTROLLER popViewControllerAnimated:YES];
    }
}

#pragma mark 自定义取消

- (void)setCustomCancel_barButtonItem:(UIBarButtonItem *)customCancel_barButtonItem {
    _customCancel_barButtonItem = customCancel_barButtonItem;
    
    if (_customCancel_barButtonItem) {
        if (NAVIGATION_CONTROLLER && [NAVI_CTRL_ROOT_VC isEqual:self] && NAVIGATION_CONTROLLER.originalViewController && UIModalPresentationFullScreen==NAVIGATION_CONTROLLER.modalPresentationStyle) {
            if (self.navigationItem.leftBarButtonItems.count > 0) {
                NSMutableArray *leftBarButtonItems = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
                [leftBarButtonItems replaceObjectAtIndex:0 withObject:_customCancel_barButtonItem];
                [self.navigationItem setLeftBarButtonItems:leftBarButtonItems animated:YES];
            }
        }
    }
    else {
        if (NAVIGATION_CONTROLLER && [NAVI_CTRL_ROOT_VC isEqual:self] && NAVIGATION_CONTROLLER.originalViewController && UIModalPresentationFullScreen==NAVIGATION_CONTROLLER.modalPresentationStyle) {
            if (self.navigationItem.leftBarButtonItems.count > 0) {
                NSMutableArray *leftBarButtonItems = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
                [leftBarButtonItems replaceObjectAtIndex:0 withObject:_normalCancel_barButtonItem];
                [self.navigationItem setLeftBarButtonItems:leftBarButtonItems animated:YES];
            }
        }
    }
}

- (void)cancel:(id)sender {
    if (self.customCancelHandler) {
        self.customCancelHandler(sender);
    }
    else if (self.tapCustomCancel) {
        self.tapCustomCancel(sender);
        NSLog(@"[WARNING]tapCustomCancel is deprecated, use customCancelHandler instead.");
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - 发起定位请求

- (void)requestLocationAuthorization:(BOOL)whenInUse {
    _locationManager = [[CLLocationManager alloc] init];
    CLAuthorizationStatus locationAuthorizationStatus;
    if (@available(iOS 14, *)) {
        locationAuthorizationStatus = [_locationManager authorizationStatus];
    } else {
        locationAuthorizationStatus = [CLLocationManager authorizationStatus];
    }
    if ([CLLocationManager locationServicesEnabled] && kCLAuthorizationStatusNotDetermined==locationAuthorizationStatus) {
        if (whenInUse) {
            [_locationManager requestWhenInUseAuthorization];
        }
        else {
            [_locationManager requestAlwaysAuthorization];
        }
    }
}

- (void)requestLocationTemporaryFullAccuracyAuthorizationWithPurposeKey:(NSString *_Nonnull)purposeKey authorizedHandler:(AuthorizedHandler)authorizedHandler deniedHandler:(DeniedHandler)deniedHandler {
    if (!_locationManager) {
        LOG_FORMAT(@"Use -requestLocationAuthorization: on the -viewDidLoad: first.");
        return;
    }
    if (CLAccuracyAuthorizationReducedAccuracy == _locationManager.accuracyAuthorization) {
        [_locationManager requestTemporaryFullAccuracyAuthorizationWithPurposeKey:purposeKey completion:^(NSError *_Nullable error) {
            if (!error) {
                if (CLAccuracyAuthorizationFullAccuracy == self->_locationManager.accuracyAuthorization) {
                    if (authorizedHandler) {
                        authorizedHandler();
                    }
                } else {
                    if (deniedHandler) {
                        deniedHandler();
                    }
                }
            }
        }];
    } else {
        if (authorizedHandler) {
            authorizedHandler();
        }
    }
}

- (void)requestLocationSuccessHandler:(LocationSuccessHandler)locationSuccessHandler failureHandler:(LocationFailureHandler)locationFailureHandler {
    _locationManager = _locationManager?:[[CLLocationManager alloc] init];
    CLAuthorizationStatus locationAuthorizationStatus;
    if (@available(iOS 14, *)) {
        locationAuthorizationStatus = [_locationManager authorizationStatus];
    } else {
        locationAuthorizationStatus = [CLLocationManager authorizationStatus];
    }
    if ([CLLocationManager locationServicesEnabled]) {
        switch (locationAuthorizationStatus) {
            case kCLAuthorizationStatusNotDetermined:
            {
                while (kCLAuthorizationStatusNotDetermined == locationAuthorizationStatus) {
                    [_locationManager requestWhenInUseAuthorization];
                    if (@available(iOS 14, *)) {
                        locationAuthorizationStatus = [_locationManager authorizationStatus];
                    } else {
                        locationAuthorizationStatus = [CLLocationManager authorizationStatus];
                    }
                }
                [self requestLocationSuccessHandler:locationSuccessHandler failureHandler:locationFailureHandler];
            }
                break;
            case kCLAuthorizationStatusRestricted:
            {
                [SVProgressHUD showErrorWithStatus:@"请先到设置中关闭定位的访问限制"];
                if (locationFailureHandler) {
                    locationFailureHandler(_locationManager, kCLAuthorizationStatusRestricted);
                }
            }
                break;
            case kCLAuthorizationStatusDenied:
            {
                if (![USER_DEFAULTS boolForKey:@"Disable location"]) {
                    NSString *title = @"没有开启定位权限，是否打开设置去开启？";
                    NSString *message = @"也可以稍后从设置中开启定位权限。";
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"不再提示" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
                        [USER_DEFAULTS setBool:YES forKey:@"Disable location"];
                        [USER_DEFAULTS synchronize];
                        [alert dismissViewControllerAnimated:YES completion:nil];
                        
                        [SVProgressHUD showErrorWithStatus:@"请先到设置中开启定位权限"];
                        if (locationFailureHandler) {
                            locationFailureHandler(self->_locationManager, kCLAuthorizationStatusDenied);
                        }
                    }];
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"打开设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
                        [APPLICATION openURL:
                             [NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                    }];
                    [alert addAction:cancle];
                    [alert addAction:ok];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                else {
                    [SVProgressHUD showErrorWithStatus:@"请先到设置中开启定位权限"];
                    if (locationFailureHandler) {
                        locationFailureHandler(_locationManager, kCLAuthorizationStatusDenied);
                    }
                }
            }
                break;
            default:
            {
                if (locationSuccessHandler) {
                    locationSuccessHandler(_locationManager);
                }
            }
                break;
        }
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"请先到设置中开启定位权限"];
        if (locationFailureHandler) {
            locationFailureHandler(_locationManager, kCLAuthorizationStatusDenied);
        }
    }
}

//MARK: Deprecated

- (void)requestLocationSuccess:(successHandler)successHandler failure:(failureHandler)failureHandler {
    [self requestLocationSuccessHandler:successHandler failureHandler:failureHandler];
}


#pragma mark - 显示照片选择器

- (void)privacyCameraAuthorizationWithCompletionHandler:(CompletionHandler)completionHandler {
    // 判断相机是否获取授权
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:
        {
            // 许可对话框没有出现，发起授权许可
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (granted) {
                        if (completionHandler) {
                            completionHandler();
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
            if (![USER_DEFAULTS boolForKey:@"Disable camera"]) {
                NSString *title = @"没有开启相机权限，是否打开设置去开启？";
                NSString *message = @"也可以稍后从设置中开启相机权限。";
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"不再提示" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
                    [USER_DEFAULTS setBool:YES forKey:@"Disable camera"];
                    [USER_DEFAULTS synchronize];
                    [alert dismissViewControllerAnimated:YES completion:nil];
                }];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"打开设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
                    [APPLICATION openURL:
                         [NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
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
            if (completionHandler) {
                completionHandler();
            }
        }
            break;
        default:
            break;
    }
}

- (void)privacyPhotoLibraryAuthorizationWithCompletionHandler:(CompletionHandler)completionHandler {
    // 判断照片是否获取授权
    PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
    switch (photoAuthorStatus) {
        case PHAuthorizationStatusNotDetermined:
        {
            // 许可对话框没有出现，发起授权许可
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status == PHAuthorizationStatusAuthorized) {
                        [self privacyPhotoLibraryAuthorizationWithCompletionHandler:completionHandler];
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
            if (![USER_DEFAULTS boolForKey:@"Disable photo library"]) {
                NSString *title = @"没有开启照片权限，是否打开设置去开启？";
                NSString *message = @"也可以稍后从设置中开启照片权限。";
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"不再提示" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
                    [USER_DEFAULTS setBool:YES forKey:@"Disable photo library"];
                    [USER_DEFAULTS synchronize];
                    [alert dismissViewControllerAnimated:YES completion:nil];
                }];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"打开设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
                    [APPLICATION openURL:
                         [NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
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
            if (completionHandler) {
                completionHandler();
            }
        }
            break;
        default:
            break;
    }
}

- (void)privacyPhotoLibraryAuthorizationWithLimitedPhotosHandler:(LimitedPhotosHandler)limitedPhotosHandler authorizedHandler:(AuthorizedHandler)authorizedHandler {
    // 判断照片是否获取授权
    PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelReadWrite];
    switch (photoAuthorStatus) {
        case PHAuthorizationStatusNotDetermined:
        {
            // 许可对话框没有出现，发起授权许可
            [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelReadWrite handler:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status==PHAuthorizationStatusAuthorized || status==PHAuthorizationStatusLimited) {
                        [self privacyPhotoLibraryAuthorizationWithLimitedPhotosHandler:limitedPhotosHandler authorizedHandler:authorizedHandler];
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
            if (![USER_DEFAULTS boolForKey:@"Disable photo library"]) {
                NSString *title = @"没有开启照片权限，是否打开设置去开启？";
                NSString *message = @"也可以稍后从设置中开启照片权限。";
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"不再提示" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
                    [USER_DEFAULTS setBool:YES forKey:@"Disable photo library"];
                    [USER_DEFAULTS synchronize];
                    [alert dismissViewControllerAnimated:YES completion:nil];
                }];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"打开设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
                    [APPLICATION openURL:
                         [NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
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
            if (authorizedHandler) {
                authorizedHandler();
            }
        }
            break;
        case PHAuthorizationStatusLimited:
        {
            [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
            
            if (limitedPhotosHandler) {
                limitedPhotosHandler();
            }
        }
            break;
        default:
            break;
    }
}

- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType {
    [self showImagePicker:sourceType isCameraDeviceFront:NO];
}

- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType isCameraDeviceFront:(BOOL)isCameraDeviceFront {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = sourceType;
    if (UIImagePickerControllerSourceTypeCamera == sourceType) {
        imagePicker.cameraDevice = isCameraDeviceFront ? UIImagePickerControllerCameraDeviceFront : UIImagePickerControllerCameraDeviceRear;
        imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    }
    else {
        imagePicker.mediaTypes = [NSArray arrayWithObjects:@"public.image", nil];
    }
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)presentLimitedLibraryPicker {
    [[PHPhotoLibrary sharedPhotoLibrary] presentLimitedLibraryPickerFromViewController:self];
}

- (void)showPhotoPickerWithMessage:(NSString *_Nullable)message {
    [self showPhotoPickerWithMessage:message isCameraDeviceFront:NO photoSelectionLimit:1 sourceView:nil completionHandler:nil];
}

- (void)showPhotoPickerWithMessage:(NSString *_Nullable)message isCameraDeviceFront:(BOOL)isCameraDeviceFront {
    [self showPhotoPickerWithMessage:message isCameraDeviceFront:isCameraDeviceFront photoSelectionLimit:1 sourceView:nil completionHandler:nil];
}

- (void)showPhotoPickerNoPhotoSelectionLimitWithMessage:(NSString *_Nullable)message {
    [self showPhotoPickerWithMessage:message isCameraDeviceFront:NO photoSelectionLimit:0 sourceView:nil completionHandler:nil];
}

- (void)showPhotoPickerWithMessage:(NSString *_Nullable)message photoSelectionLimit:(NSUInteger)photoSelectionLimit {
    [self showPhotoPickerWithMessage:message isCameraDeviceFront:NO photoSelectionLimit:photoSelectionLimit sourceView:nil completionHandler:nil];
}

- (void)showPhotoPickerWithMessage:(NSString *_Nullable)message sourceView:(UIView *_Nullable)sourceView {
    [self showPhotoPickerWithMessage:message isCameraDeviceFront:NO photoSelectionLimit:1 sourceView:sourceView completionHandler:nil];
}

- (void)showPhotoPickerWithMessage:(NSString *_Nullable)message isCameraDeviceFront:(BOOL)isCameraDeviceFront sourceView:(UIView *_Nullable)sourceView {
    [self showPhotoPickerWithMessage:message isCameraDeviceFront:isCameraDeviceFront photoSelectionLimit:1 sourceView:sourceView completionHandler:nil];
}

- (void)showPhotoPickerNoPhotoSelectionLimitWithMessage:(NSString *_Nullable)message sourceView:(UIView *_Nullable)sourceView {
    [self showPhotoPickerWithMessage:message isCameraDeviceFront:NO photoSelectionLimit:0 sourceView:sourceView completionHandler:nil];
}

- (void)showPhotoPickerWithMessage:(NSString *_Nullable)message photoSelectionLimit:(NSUInteger)photoSelectionLimit sourceView:(UIView *_Nullable)sourceView {
    [self showPhotoPickerWithMessage:message isCameraDeviceFront:NO photoSelectionLimit:photoSelectionLimit sourceView:sourceView completionHandler:nil];
}

- (void)showPhotoPickerWithMessage:(NSString *_Nullable)message completionHandler:(CompletionHandler)completionHandler {
    [self showPhotoPickerWithMessage:message isCameraDeviceFront:NO photoSelectionLimit:1 sourceView:nil completionHandler:completionHandler];
}

- (void)showPhotoPickerWithMessage:(NSString *_Nullable)message isCameraDeviceFront:(BOOL)isCameraDeviceFront completionHandler:(CompletionHandler)completionHandler {
    [self showPhotoPickerWithMessage:message isCameraDeviceFront:isCameraDeviceFront photoSelectionLimit:1 sourceView:nil completionHandler:completionHandler];
}

- (void)showPhotoPickerNoPhotoSelectionLimitWithMessage:(NSString *_Nullable)message completionHandler:(CompletionHandler)completionHandler {
    [self showPhotoPickerWithMessage:message isCameraDeviceFront:NO photoSelectionLimit:0 sourceView:nil completionHandler:completionHandler];
}

- (void)showPhotoPickerWithMessage:(NSString *_Nullable)message photoSelectionLimit:(NSUInteger)photoSelectionLimit completionHandler:(CompletionHandler)completionHandler {
    [self showPhotoPickerWithMessage:message isCameraDeviceFront:NO photoSelectionLimit:photoSelectionLimit sourceView:nil completionHandler:completionHandler];
}

- (void)showPhotoPickerWithMessage:(NSString *_Nullable)message sourceView:(UIView *_Nullable)sourceView completionHandler:(CompletionHandler)completionHandler {
    [self showPhotoPickerWithMessage:message isCameraDeviceFront:NO photoSelectionLimit:1 sourceView:sourceView completionHandler:completionHandler];
}

- (void)showPhotoPickerWithMessage:(NSString *_Nullable)message isCameraDeviceFront:(BOOL)isCameraDeviceFront sourceView:(UIView *_Nullable)sourceView completionHandler:(CompletionHandler)completionHandler {
    [self showPhotoPickerWithMessage:message isCameraDeviceFront:isCameraDeviceFront photoSelectionLimit:1 sourceView:sourceView completionHandler:completionHandler];
}

- (void)showPhotoPickerNoPhotoSelectionLimitWithMessage:(NSString *_Nullable)message sourceView:(UIView *_Nullable)sourceView completionHandler:(CompletionHandler)completionHandler {
    [self showPhotoPickerWithMessage:message isCameraDeviceFront:NO photoSelectionLimit:0 sourceView:sourceView completionHandler:completionHandler];
}

- (void)showPhotoPickerWithMessage:(NSString *_Nullable)message photoSelectionLimit:(NSUInteger)photoSelectionLimit sourceView:(UIView *_Nullable)sourceView completionHandler:(CompletionHandler)completionHandler {
    [self showPhotoPickerWithMessage:message isCameraDeviceFront:NO photoSelectionLimit:photoSelectionLimit sourceView:sourceView completionHandler:completionHandler];
}

- (void)showPhotoPickerWithMessage:(NSString *_Nullable)message isCameraDeviceFront:(BOOL)isCameraDeviceFront photoSelectionLimit:(NSUInteger)photoSelectionLimit sourceView:(UIView *_Nullable)sourceView completionHandler:(CompletionHandler)completionHandler {
    UIAlertController *alertSheet = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        if (completionHandler) {
            completionHandler();
        }
        
        [self privacyCameraAuthorizationWithCompletionHandler:^{
            [self showImagePicker:UIImagePickerControllerSourceTypeCamera isCameraDeviceFront:isCameraDeviceFront];
        }];
    }];
    UIAlertAction *photoLibrary = [UIAlertAction actionWithTitle:@"选取照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        if (completionHandler) {
            completionHandler();
        }
        
        if (@available(iOS 14, *)) {
            PHPickerConfiguration *configuration = [[PHPickerConfiguration alloc] init];
            configuration.filter = [PHPickerFilter imagesFilter];
            configuration.selectionLimit = photoSelectionLimit;
            PHPickerViewController *pickerViewController = [[PHPickerViewController alloc] initWithConfiguration:configuration];
            pickerViewController.delegate = self;
            pickerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:pickerViewController animated:YES completion:nil];
        } else {
            [self privacyPhotoLibraryAuthorizationWithCompletionHandler:^{
                [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
            }];
        }
    }];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        if (completionHandler) {
            completionHandler();
        }
    }];
    [alertSheet addAction:camera];
    [alertSheet addAction:photoLibrary];
    [alertSheet addAction:cancelAction];
    
    UIPopoverPresentationController *popover = alertSheet.popoverPresentationController;
    if (popover) {
        popover.sourceView = sourceView?:self.view;
        popover.sourceRect = sourceView?sourceView.bounds:CGRectMake(0, 0, FRAME_WIDTH(self.view), CENTER_Y(self.view));
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    [self presentViewController:alertSheet animated:YES completion:nil];
}

//MARK: Deprecated

- (void)privacyCameraAuthorizationWithCompletion:(completion)completion {
    [self privacyCameraAuthorizationWithCompletionHandler:completion];
}

- (void)privacyPhotoLibraryAuthorizationWithCompletion:(completion)completion {
    [self privacyPhotoLibraryAuthorizationWithCompletionHandler:completion];
}

- (void)showPhotoPickerWithMessage:(NSString *_Nullable)message sourceView:(UIView *_Nonnull)sourceView completion:(completion)completion {
    [self showPhotoPickerWithMessage:message sourceView:sourceView completionHandler:completion];
}

- (void)showPhotoPickerWithMessage:(NSString *_Nullable)message isFront:(BOOL)isFront sourceView:(UIView *_Nonnull)sourceView completion:(completion)completion {
    [self showPhotoPickerWithMessage:message isCameraDeviceFront:isFront sourceView:sourceView completionHandler:completion];
}


#pragma mark - Image picker controller delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *selectPhoto = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (self.photoPickerFinishHandler) {
        self.photoPickerFinishHandler(picker, @[selectPhoto]);
    }
    else if (self.photoPickerResult) {
        self.photoPickerResult(picker, info);
        NSLog(@"[WARNING]photoPickerResult is deprecated, use photoPickerFinishHandler instead.");
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - PHPicker view controller delegate

- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results API_AVAILABLE(ios(14)){
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (!results || !results.count) {
        return;
    }
    if (results.count > 1) {
        NSMutableArray *selectedPhotos = [NSMutableArray array];
        dispatch_group_t asyncGroup = dispatch_group_create();
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [results enumerateObjectsUsingBlock:^(PHPickerResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                dispatch_group_enter(asyncGroup);
                NSItemProvider *itemProvider = obj.itemProvider;
                if ([itemProvider canLoadObjectOfClass:UIImage.class]) {
                    [itemProvider loadObjectOfClass:UIImage.class completionHandler:^(__kindof id<NSItemProviderReading> _Nullable object, NSError *_Nullable error) {
                        if ([object isKindOfClass:UIImage.class]) {
                            [selectedPhotos addObject:object];
                            dispatch_group_leave(asyncGroup);
                        }
                    }];
                }
            }];
            dispatch_group_wait(asyncGroup, DISPATCH_TIME_FOREVER);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.photoPickerFinishHandler) {
                    self.photoPickerFinishHandler(picker, [selectedPhotos copy]);
                }
            });
        });
    } else {
        NSItemProvider *itemProvider = results.firstObject.itemProvider;
        if ([itemProvider canLoadObjectOfClass:UIImage.class]) {
            @WeakObject(self);
            [itemProvider loadObjectOfClass:UIImage.class completionHandler:^(__kindof id<NSItemProviderReading> _Nullable object, NSError *_Nullable error) {
                if ([object isKindOfClass:UIImage.class]) {
                    @StrongObject(self);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (self.photoPickerFinishHandler) {
                            self.photoPickerFinishHandler(picker, @[object]);
                        }
                    });
                }
            }];
        }
    }
}


#pragma mark - Photo library change observer

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    
}


#pragma mark - 录音是否授权

- (void)privacyMicrophoneAuthorizationWithCompletionHandler:(CompletionHandler)completionHandler {
    // 判断录音是否获取授权
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:
        {
            // 许可对话框没有出现，发起授权许可
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (granted) {
                        if (completionHandler) {
                            completionHandler();
                        }
                    }
                    else {
                        [SVProgressHUD showErrorWithStatus:@"请先到设置中开启麦克风权限"];
                    }
                });
            }];
        }
            break;
        case AVAuthorizationStatusRestricted:
        {
            [SVProgressHUD showErrorWithStatus:@"请先到设置中关闭麦克风的访问限制"];
        }
            break;
        case AVAuthorizationStatusDenied:
        {
            if (![USER_DEFAULTS boolForKey:@"Disable microphone"]) {
                NSString *title = @"没有开启麦克风权限，是否打开设置去开启？";
                NSString *message = @"也可以稍后从设置中开启麦克风权限。";
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"不再提示" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
                    [USER_DEFAULTS setBool:YES forKey:@"Disable microphone"];
                    [USER_DEFAULTS synchronize];
                    [alert dismissViewControllerAnimated:YES completion:nil];
                }];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"打开设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
                    [APPLICATION openURL:
                         [NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                }];
                [alert addAction:cancle];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else {
                [SVProgressHUD showErrorWithStatus:@"请先到设置中开启麦克风权限"];
            }
        }
            break;
        case AVAuthorizationStatusAuthorized:
        {
            if (completionHandler) {
                completionHandler();
            }
        }
            break;
        default:
            break;
    }
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.customBackHandler) {
        self.customBackHandler(self.customBack_barButtonItem);
        return NO;
    } if (self.tapCustomBack) {
        self.tapCustomBack(self.customBack_barButtonItem);
        NSLog(@"[WARNING]tapCustomBack is deprecated, use customBackHandler instead.");
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

- (UIRefreshControl *)refreshControl {
    return self.tableView.refreshControl;
}
- (void)setRefreshControl:(UIRefreshControl *)refreshControl {
    self.tableView.refreshControl = refreshControl;
}
- (void)setRefreshEnabled:(BOOL)refreshEnabled {
    if (self.tableView) {
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
    else {
        [SVProgressHUD showErrorWithStatus:@"属性 refreshEnabled仅用于嵌入的 tableView。(The refreshEnabled property only use for added tableView, setup the tableView property first.)"];
    }
}
- (void)refresh:(id)sender {
    [self loadData];
}

- (void)setMJRefreshEnabled:(BOOL)MJRefreshEnabled {
    if (self.tableView) {
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
    else {
        [SVProgressHUD showErrorWithStatus:@"属性 MJRefreshEnabled仅用于嵌入的 tableView。(The MJRefreshEnabled property only use for added tableView, setup the tableView property first.)"];
    }
}
- (void)setRefreshHeader:(MJRefreshNormalHeader *)refreshHeader {
    if (self.tableView) {
        _refreshHeader = refreshHeader;
        
        if (_MJRefreshEnabled) {
            self.tableView.mj_header = _refreshHeader;
        }
        else {
            self.tableView.mj_header = nil;
        }
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"属性 refreshHeader仅用于嵌入的 tableView。(The refreshHeader property only use for added tableView, setup the tableView property first.)"];
    }
}
- (void)setRefreshFooter:(MJRefreshBackNormalFooter *)refreshFooter {
    if (self.tableView) {
        _refreshFooter = refreshFooter;
        
        if (_MJRefreshEnabled) {
            self.tableView.mj_footer = _refreshFooter;
        }
        else {
            self.tableView.mj_footer = nil;
        }
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"属性 refreshFooter仅用于嵌入的 tableView。(The refreshFooter property only use for added tableView, setup the tableView property first.)"];
    }
}
- (void)loadData {}
- (void)loadMoreDataWithPageNumber:(NSUInteger)pageNumber {}

#pragma mark - 没有数据提示显示与隐藏

- (void)initImageViewWithImage {
    if (!_noDataView) {
        _noDataView = [[UIView alloc] init];
    }
    if (!_noDataImageView) {
        _noDataImageView = [[UIImageView alloc] init];
        [_noDataView addSubview:_noDataImageView];
    }
    if (_noDataImageExt && [_noDataImageExt isEqualToString:@"gif"]) {
        NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
        UIImage *image = [UIImage imageWithContentsOfFile:STRING_FORMAT(@"%@/%@.%@", resourcePath, _noDataImageName, _noDataImageExt)];
        NSData *image_data = [NSData dataWithContentsOfFile:STRING_FORMAT(@"%@/%@@%.0fx.%@", resourcePath, _noDataImageName, image.scale, _noDataImageExt)];
        UIImage *animated_image = [UIImage sd_imageWithGIFData:image_data];
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
    if (self.tableView) {
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
    else {
        [SVProgressHUD showErrorWithStatus:@"-setNoDataImageName:noDataImageExt:width:height: 仅用于嵌入的 tableView。(The -setNoDataImageName:noDataImageExt:width:height: only use for added tableView, setup the tableView property first.)"];
    }
}

- (void)initTextLabelWithText {
    if (!_noDataView) {
        _noDataView = [[UIView alloc] init];
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
    _noDataTextLabel.font = _noDataTextFont?:FONT_SIZE(14);
    _noDataTextLabel.textColor = _noDataTextColor?:COLOR_HEXSTRING(@"#999999");
    _noDataTextLabel.textAlignment = NSTextAlignmentCenter;
    _noDataTextLabel.numberOfLines = _noDataTextLines;
    
    [self updateNoDataImageAndText];
}
- (void)setNoDataTextFont:(UIFont *)noDataTextFont {
    _noDataTextFont = noDataTextFont;
    
    [self initTextLabelWithText];
}
- (void)setNoDataTextColor:(UIColor *)noDataTextColor {
    _noDataTextColor = noDataTextColor;
    
    [self initTextLabelWithText];
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
    if (self.tableView) {
        _noDataText = noDataText;
        _noDataTextWidth = width;
        if (lines > 0) {
            _noDataTextLines = lines;
        }
        [self initTextLabelWithText];
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"-setNoDataText:width:lines: 仅用于嵌入的 tableView。(The -setNoDataText:width:lines: only use for added tableView, setup the tableView property first.)"];
    }
}

- (void)updateNoDataImageAndText {
    if (!_noDataViewHeight) {
        _noDataViewHeight = FRAME_HEIGHT(self.tableView) - TOP_LAYOUT_HEIGHT;
        if (self.tableView.tableHeaderView) {
            _noDataViewHeight -= FRAME_HEIGHT(self.tableView.tableHeaderView);
        }
        if (self.tableView.tableFooterView) {
            _noDataViewHeight -= FRAME_HEIGHT(self.tableView.tableFooterView);
        }
        _noDataViewHeight -= SAFEAREA_INSETS.bottom;
    }
    
    if (!_customTableFooterView) {
        if (self.tableView.tableFooterView) {
            _customTableFooterView = self.tableView.tableFooterView;
        }
        else {
            _customTableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FRAME_WIDTH(self.tableView), 0.5)];
            _customTableFooterView.backgroundColor = COLOR_HEXSTRING_ALPHA(@"#FFFFFF", 0);
        }
    }
    
    self.tableView.tableFooterView = _noDataView;
    _noDataView.backgroundColor = _enableNoDataDebug ? COLOR_HEXSTRING_ALPHA(@"#FF0000", 0.5) : COLOR_HEXSTRING_ALPHA(@"#FFFFFF", 1);
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
            
            self->_noDataImageView.backgroundColor = self->_enableNoDataDebug ? COLOR_HEXSTRING_ALPHA(@"#00FF00", 0.5) : COLOR_HEXSTRING_ALPHA(@"#FFFFFF", 0);
            self->_noDataTextLabel.backgroundColor = self->_enableNoDataDebug ? COLOR_HEXSTRING_ALPHA(@"#0000FF", 0.5) : COLOR_HEXSTRING_ALPHA(@"#FFFFFF", 0);
            
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
            
            self->_noDataImageView.backgroundColor = self->_enableNoDataDebug ? COLOR_HEXSTRING_ALPHA(@"#00FF00", 0.5) : COLOR_HEXSTRING_ALPHA(@"#FFFFFF", 0);
            
            [self->_noDataImageView updateLayout];
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
            
            self->_noDataTextLabel.backgroundColor = self->_enableNoDataDebug ? COLOR_HEXSTRING_ALPHA(@"#0000FF", 0.5) : COLOR_HEXSTRING_ALPHA(@"#FFFFFF", 0);
            
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
            
            self->_noDataTextLabel.backgroundColor = self->_enableNoDataDebug ? COLOR_HEXSTRING_ALPHA(@"#0000FF", 0.5) : COLOR_HEXSTRING_ALPHA(@"#FFFFFF", 0);
            
            [self->_noDataTextLabel updateLayout];
        }];
    }
}

- (void)showNoData {
    if (self.tableView) {
        if (!_noDataView) {
            _noDataView = [[UIView alloc] init];
        }
        if (!_noDataImageView) {
            _noDataImageView = [[UIImageView alloc] init];
            [_noDataView addSubview:_noDataImageView];
        }
        if (!_noDataTextLabel) {
            _noDataTextLabel = [[UILabel alloc] init];
            _noDataTextLabel.text = @"没有数据显示";
            _noDataTextLabel.font = _noDataTextFont?:FONT_SIZE(14);
            _noDataTextLabel.textColor = _noDataTextColor?:COLOR_HEXSTRING(@"#999999");
            _noDataTextLabel.textAlignment = NSTextAlignmentCenter;
            [_noDataView addSubview:_noDataTextLabel];
        }
        
        [self updateNoDataImageAndText];
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"-showNodata 仅用于嵌入的 tableView。(The -showNodata only use for added tableView, setup the tableView property first.)"];
    }
}

- (void)hideNoData {
    if (self.tableView) {
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
    else {
        [SVProgressHUD showErrorWithStatus:@"-hideNodata 仅用于嵌入的 tableView。(The -hideNodata only use for added tableView, setup the tableView property first.)"];
    }
}


#pragma mark - Table view delegate

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

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_numberOfRows > 0) {
        return _numberOfRows;
    }
    [SVProgressHUD showErrorWithStatus:@"提供静态 cell时，sections>1则需要在基于 BaseViewController的控制器中实现 -tableView:numberOfRowsInSection:依次返回numberOfRows。(When providing static cells, for more than one section please responds selector -tableView:numberOfRowsInSection: in EFBaseViewController based controller to return every section's numberOfRows.)"];
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier;
    if (_sections > 1) {
        cellIdentifier = STRING_FORMAT(@"s%ldc%ld", (long)indexPath.section, (long)indexPath.row);
    }
    else {
        cellIdentifier = STRING_FORMAT(@"c%ld", (long)indexPath.row);
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_sections > 1) {
        return _sections;
    }
    return 1;
}


#pragma mark - 调整 tableView的边距以适应键盘

- (void)setFocusedControl:(id)focusedControl {
    if (self.tableView) {
        _focusedControl = focusedControl;
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"属性 focusedContentOffset仅用于嵌入的 tableView。(The focusedContentOffset property only use for added tableView, setup the tableView property first.)"];
    }
}

- (void)setAdjustTableViewEdgeInsetsToFitKeyboard:(BOOL)isAdjust {
    if (self.tableView) {
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
    else {
        [SVProgressHUD showErrorWithStatus:@"属性 adjustTableViewEdgeInsetsToFitKeyboard仅用于嵌入的 tableView。(The adjustTableViewEdgeInsetsToFitKeyboard property only use for added tableView, setup the tableView property first.)"];
    }
}


#pragma mark - Keyboard notification

- (void)keyboardWillShow:(NSNotification *)aNotification {
    if (self.tableView) {
        NSDictionary *userInfo = [aNotification userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        CGFloat keyboardHeight = keyboardRect.size.height;
        CGFloat contentInsetBottom = _focusedControl? self.tableView.contentSize.height-([_focusedControl.superview convertPoint:FRAME_ORIGIN(_focusedControl) toView:self.tableView].y+FRAME_HEIGHT(_focusedControl)+(FRAME_HEIGHT(_focusedControl.superview)-FRAME_HEIGHT(_focusedControl))/2): self.tableView.contentInset.bottom;
        self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top, self.tableView.contentInset.left, contentInsetBottom>keyboardHeight? keyboardHeight: contentInsetBottom, self.tableView.contentInset.right);
    }
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    if (self.tableView) {
        [self.tableView setContentInset:UIEdgeInsetsZero];
    }
}


#pragma mark - 导航

// 弹出或者推基于 storyboard 的控制器，过程中可能需要在这里做一点点处理
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    id srcViewController = segue.sourceViewController;
    id destViewController = segue.destinationViewController;
    
    if ([destViewController isKindOfClass:[EFBaseNavigationController class]]) { // dest present modally
        EFBaseNavigationController *presented_NC = (EFBaseNavigationController *)destViewController;
        presented_NC.originalViewController = srcViewController;
    }
    else if ([destViewController isKindOfClass:[EFBaseViewController class]] || [destViewController isKindOfClass:[EFBaseTableViewController class]]) {
        EFBaseViewController *baseVC = destViewController;
        baseVC.previousViewController = srcViewController;
    }
}

@end

