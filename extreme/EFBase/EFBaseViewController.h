//
//  EFBaseViewController.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFConfig.h"
#import <CoreLocation/CoreLocation.h>

@class EFNavigationBar;
@class CLLocationManager;

@interface EFBaseViewController : UIViewController

#pragma mark - 状态栏与导航栏 StatusBar and NavigationBar
/**
 状态栏是否隐藏，默认不启用。 (NO as default.)
 */
@property (assign, nonatomic) BOOL statusBarHidden;

/**
 导航栏样式，基于 EFConfig中的 EFBarStyle，默认使用 EFBarStyleDefault样式：等同于 UIBarStyleDefault。 (Set the navigationBarStyle as EFBarStyle defined in EFConfig, EFBarStyleDefault as default: same to the UIBarStyleDefault.)
 */
@property (assign, nonatomic) EFBarStyle navigationBarStyle;
/**
 直接访问导航栏(Access the navigation bar directly.)
 */
@property (strong, nonatomic, readonly, nullable) EFNavigationBar *navigationBar;

/**
 使用自定义返回，默认使用 extreme.bundle中的图像“back”，默认不启用。(Use custom back on the NavigationBar, the default image is image named "back" in extreme.bundle, NO as default.)
 */
@property (assign, nonatomic, getter=isUseCustomBack) BOOL useCustomBack;
/**
 可在使用自定义返回时自定义返回按钮。(For custom appearance of back button when use custom back.)
 */
@property (strong, nonatomic, nullable) UIBarButtonItem *customBack_barButtonItem;
/**
 自定义返回事件回调。(Custom back callback use block.)
 */
@property (strong, nonatomic, nullable) void(^tapCustomBack)(id _Nonnull sender);

/**
 可在外部调用时用于自定义取消按钮。(For custom appearance of cancel button when present modally.)
 */
@property (strong, nonatomic, nullable) UIBarButtonItem *customCancel_barButtonItem;
/**
 自定义取消事件回调。(Custom cancel callback use block.)
 */
@property (strong, nonatomic, nullable) void(^tapCustomCancel)(id _Nonnull sender);

/**
 导航中的上一个控制器。(Previous viewController in navigation controller.)
 */
@property (strong, nonatomic, nonnull) EFBaseViewController *previousViewController;

/**
 被嵌入时，嵌入容器的控制器。(The controller who embed this controller.)
 */
@property (strong, nonatomic, nonnull) EFBaseViewController *containerViewController;


#pragma mark - 使用位置 Use location
/**
 发起请求位置成功回调。(Success callback use block when request location.)
 
 @param locationManager locationManager实例
 */
typedef void(^_Nullable successHandler)(CLLocationManager *_Nonnull locationManager);
/**
 发起请求位置失败回调。(Failure callback use block when request location.)
 
 @param locationManager locationManager实例
 @param authorizationStatus 位置授权状态
 */
typedef void(^_Nullable failureHandler)(CLLocationManager *_Nonnull locationManager, CLAuthorizationStatus authorizationStatus);
/**
 在使用位置的控制器 viewDidLoad中先调用以获取使用位置授权。(Use requestLocationAuthorization: on the viewDidLoad: in the controller who requested location.)

 @param whenInUse Request location whenInUse or always.
 */
- (void)requestLocationAuthorization:(BOOL)whenInUse;
/**
 发起请求位置，并弹框提示用户允许定位权限。 (Just request location.)

 @param successHandler 成功回调
 @param failureHandler 失败回调
 */
- (void)requestLocationSuccess:(successHandler)successHandler failure:(failureHandler)failureHandler;


#pragma mark - 获取照片 Photo picker
/**
 ImagePicker 操作回调，适用于任一操作：拍照、选取照片以及取消。(ImagePicker callback use block, for each action: take a picture from camera or library or cancel.)
 */
typedef void (^_Nullable completion)(void);
/**
 获取隐私-相机权限。(Authorization for privacy use camera.)
 
 @param completion 操作回调
 */
- (void)privacyCameraAuthorizationWithCompletion:(completion)completion;
/**
 获取隐私-照片权限。(Authorization for privacy use photo library.)
 
 @param completion 操作回调
 */
- (void)privacyPhotoLibraryAuthorizationWithCompletion:(completion)completion;
/**
 显示选择拍照、选取照片。 (Show the camera/photo library selector.)
 
 @param message 提示信息
 @param sourceView 源视图实例，用于iPad
 @param completion 操作回调
 */
- (void)showPhotoPickerWithMessage:(NSString *_Nullable)message sourceView:(UIView *_Nonnull)sourceView completion:(completion)completion;
/**
 同显示选择拍照、选取照片，可设定拍照默认开启前置还是后置摄像头。(Same as the previous selector: showPhotoPickerWithMessage:sourceView:completion:, set front or rear camera as default when camera on.)
 
 @param message 提示信息
 @param isFront YES 前置摄像头 NO 后置摄像头
 @param sourceView 源视图实例，用于iPad
 @param completion 操作回调
 */
- (void)showPhotoPickerWithMessage:(NSString *_Nullable)message isFront:(BOOL)isFront sourceView:(UIView *_Nonnull)sourceView completion:(completion)completion;
/**
 获取照片回调。(Photo picker callback use block.)
 */
@property (strong, nonatomic, nullable) void(^photoPickerResult)(UIImagePickerController *_Nonnull imagePicker, NSDictionary *_Nonnull mediaInfo);


#pragma mark - API调用与数据源 HTTPRequest and manager
/**
 如果调用了HTTPTool，每一个数据任务都要都手动添加到这里。(Add every data task you've been created.)
 */
@property (strong, nonatomic, nullable) NSMutableArray<NSURLSessionDataTask *> *dataTasks;

@end
