//
//  EFBaseViewController.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFConfig.h"
#import "EFMacros.h"
#import "EFBaseNavigationController.h"
#import <CoreLocation/CoreLocation.h>
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>

@class EFNavigationBar;
@class CLLocationManager;
@class MJRefreshNormalHeader;
@class MJRefreshBackNormalFooter;
@class PHChange;

@interface EFBaseViewController : UIViewController <UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, PHPickerViewControllerDelegate, PHPhotoLibraryChangeObserver, UITableViewDelegate, UITableViewDataSource>

#pragma mark - 状态栏与导航栏 StatusBar and NavigationBar
/**
 状态栏是否隐藏，默认不启用。 (NO as default.)
 */
@property (assign, nonatomic) BOOL statusBarHidden;

/**
 导航栏样式，EFBarStyle于 EFConfig中定义，默认使用 EFBarStyleDefault——等同于 UIBarStyleDefault。 (Set the navigationBarStyle as EFBarStyle defined in EFConfig, EFBarStyleDefault as default, same as UIBarStyleDefault.)
 */
@property (assign, nonatomic) EFBarStyle navigationBarStyle;
/**
 直接访问导航栏(Access the navigation bar directly.)
 */
@property (strong, nonatomic, readonly, nullable) EFNavigationBar *navigationBar;

/**
 使用自定义返回，默认使用 extreme.bundle中名为“back”的图像，默认不启用。(Use custom back on the navigation bar, NO as default, default image as image named "back" in extreme.bundle.)
 */
@property (assign, nonatomic, getter=isUseCustomBack) BOOL useCustomBack;
/**
 可在使用自定义返回时自定义返回按钮。(For custom appearance of the back button when use custom back.)
 */
@property (strong, nonatomic, nullable) UIBarButtonItem *customBack_barButtonItem;
/**
 自定义返回事件回调。(Custom back callback handler use block.)
 */
@property (strong, nonatomic, nullable) void(^customBackHandler)(id _Nonnull sender);

/**
 可在外部调用时用于自定义取消按钮。(For custom appearance of the cancel button when present modally.)
 */
@property (strong, nonatomic, nullable) UIBarButtonItem *customCancel_barButtonItem;
/**
 自定义取消事件回调。(Custom cancel callback handler use block.)
 */
@property (strong, nonatomic, nullable) void(^customCancelHandler)(id _Nonnull sender);

/**
 导航中的上一个控制器。(The previous view controller in navigation controller.)
 */
@property (strong, nonatomic, nonnull) EFBaseViewController *previousViewController;

//MARK: Deprecated
/**
 属性已在极致框架2.0弃用，使用 customBackHandler 来代替。(Use customBackHandler instead, first deprecated in ExtremeFramework 2.0.)
 */
@property (strong, nonatomic, nullable) void(^tapCustomBack)(id _Nonnull sender) EFDeprecated("Use customBackHandler instead, first deprecated in ExtremeFramework 2.0.");
/**
 属性已在极致框架2.0弃用，使用 customCancelHandler 来代替。(Use customCancelHandler instead, first deprecated in ExtremeFramework 2.0.)
 */
@property (strong, nonatomic, nullable) void(^tapCustomCancel)(id _Nonnull sender) EFDeprecated("Use customCancelHandler instead, first deprecated in ExtremeFramework 2.0.");


#pragma mark - 使用位置 Use location
/**
 获得完全访问权限回调。(Callback handler use block, for complete authorization.)
 */
typedef void (^_Nullable AuthorizedHandler)(void);
/**
 访问权限被拒回调。(Callback handler use block, for authorization denied.)
 */
typedef void (^_Nullable DeniedHandler)(void);
/**
 发起请求位置成功回调。(Success callback handler use block when request location.)
 
 @param locationManager locationManager实例
 */
typedef void (^_Nullable LocationSuccessHandler)(CLLocationManager *_Nonnull locationManager);
/**
 发起请求位置失败回调。(Failure callback handler use block when request location.)
 
 @param locationManager locationManager实例
 @param authorizationStatus 位置授权状态
 */
typedef void (^_Nullable LocationFailureHandler)(CLLocationManager *_Nonnull locationManager, CLAuthorizationStatus authorizationStatus);

/**
 先在使用位置的基于 EFBaseViewController控制器中的 -viewDidLoad 调用以获取使用位置授权。(Use -requestLocationAuthorization: on the -viewDidLoad in the EFBaseViewController based controller first who requested location.)

 @param whenInUse Request location whenInUse or always.
 */
- (void)requestLocationAuthorization:(BOOL)whenInUse;
/**
 未开启精确定位，需要临时请求开启时调用。 (If full accuracy location disabled, request full accuracy location temporary.)

 @param purposeKey 权限申请弹框显示的功能说明所属的 Key
 @param authorizedHandler 获得精确定位临时访问权限回调
 @param deniedHandler 精确定位临时访问权限被拒回调
 */
- (void)requestLocationTemporaryFullAccuracyAuthorizationWithPurposeKey:(NSString *_Nonnull)purposeKey authorizedHandler:(AuthorizedHandler)authorizedHandler deniedHandler:(DeniedHandler)deniedHandler API_AVAILABLE(ios(14));

/**
 发起请求定位。 (Just request location.)

 @param locationSuccessHandler 成功回调
 @param locationFailureHandler 失败回调
 */
- (void)requestLocationSuccessHandler:(LocationSuccessHandler)locationSuccessHandler failureHandler:(LocationFailureHandler)locationFailureHandler;

//MARK: Deprecated
/**
 类型已在极致框架2.0弃用，使用 LocationSuccessHandler 来代替。(Use LocationSuccessHandler instead, first deprecated in ExtremeFramework 2.0.)
 */
typedef void(^_Nullable successHandler)(CLLocationManager *_Nonnull locationManager) EFDeprecated("Use LocationSuccessHandler instead, first deprecated in ExtremeFramework 2.0.");
/**
 类型已在极致框架2.0弃用，使用 LocationFailureHandler 来代替。(Use LocationFailureHandler instead, first deprecated in ExtremeFramework 2.0.)
 */
typedef void(^_Nullable failureHandler)(CLLocationManager *_Nonnull locationManager, CLAuthorizationStatus authorizationStatus) EFDeprecated("Use LocationFailureHandler instead, first deprecated in ExtremeFramework 2.0.");

/**
 方法已在极致框架2.0弃用，使用 -requestLocationSuccessHandler:failureHandler: 来代替。(Use -requestLocationSuccessHandler:failureHandler: instead, first deprecated in ExtremeFramework 2.0.)
 */
- (void)requestLocationSuccess:(successHandler)successHandler failure:(failureHandler)failureHandler EFDeprecated("Use -requestLocationSuccessHandler:failureHandler: instead, first deprecated in ExtremeFramework 2.0.");


#pragma mark - 获取照片 Photo picker
/**
 操作回调。(Callback handler use block.)
 */
typedef void (^_Nullable CompletionHandler)(void);
/**
 获得受限照片权限回调。(Callback handler use block, for limited photos authorization.)
 */
typedef void (^_Nullable LimitedPhotosHandler)(void);
/**
 获取隐私-相机权限。(Authorization for privacy use camera.)
 
 @param completionHandler 操作回调
 */
- (void)privacyCameraAuthorizationWithCompletionHandler:(CompletionHandler)completionHandler;
/**
 获取隐私-照片图库权限(iOS13或更早系统)。(Authorization for privacy use photo library, prior to iOS 14.)
 
 @param completionHandler 操作回调
 */
- (void)privacyPhotoLibraryAuthorizationWithCompletionHandler:(CompletionHandler)completionHandler;
/**
 获取隐私-照片图库权限(iOS14及更新系统)。(Authorization for privacy use photo library, iOS 14 and future versions.)
 
 @param limitedPhotosHandler 获得受限照片权限回调
 @param authorizedHandler 获得照片图库完全访问权限回调
 */
- (void)privacyPhotoLibraryAuthorizationWithLimitedPhotosHandler:(LimitedPhotosHandler)limitedPhotosHandler authorizedHandler:(AuthorizedHandler)authorizedHandler API_AVAILABLE(ios(14));
/**
 弹出受限照片权限选择照片界面。(Select the photos for limited photos authorization.)
 */
- (void)presentLimitedLibraryPicker API_AVAILABLE(ios(14));
/**
 显示选择拍照、选取照片，仅支持选择一张照片。 (Show the camera/photo library selector, photo single selection.)
 
 @param message 提示信息
 */
- (void)showPhotoPickerWithMessage:(NSString *_Nullable)message;
/**
 同显示选择拍照、选取照片，仅支持选择一张照片，可设定拍照默认开启前置还是后置摄像头。(Same as the selector: -showPhotoPickerWithMessage:sourceView:completionHandler:, except: you may set front or rear camera as default when camera is on.)
 
 @param message 提示信息
 @param isCameraDeviceFront YES 前置摄像头 NO 后置摄像头
 */
- (void)showPhotoPickerWithMessage:(NSString *_Nullable)message isCameraDeviceFront:(BOOL)isCameraDeviceFront;
/**
 显示选择拍照、选取照片，支持选择任意张照片。 (Show the camera/photo library selector, no limited photo multi selection.)
 
 @param message 提示信息
 */
- (void)showPhotoPickerNoPhotoSelectionLimitWithMessage:(NSString *_Nullable)message API_AVAILABLE(ios(14));
/**
 显示选择拍照、选取照片，支持选择最多限定张数的照片。 (Show the camera/photo library selector, limited photo multi selection, maximum selection as you set.)
 
 @param message 提示信息
 @param photoSelectionLimit 选择照片的数量限制
 */
- (void)showPhotoPickerWithMessage:(NSString *_Nullable)message photoSelectionLimit:(NSUInteger)photoSelectionLimit API_AVAILABLE(ios(14));
/**
 显示选择拍照、选取照片，仅支持选择一张照片。 (Show the camera/photo library selector, photo single selection.)
 
 @param message 提示信息
 @param sourceView 源视图实例，用于 iPad
 */
- (void)showPhotoPickerWithMessage:(NSString *_Nullable)message sourceView:(UIView *_Nullable)sourceView;
/**
 同显示选择拍照、选取照片，仅支持选择一张照片，可设定拍照默认开启前置还是后置摄像头。(Same as the selector: -showPhotoPickerWithMessage:sourceView:completionHandler:, except: you may set front or rear camera as default when camera is on.)
 
 @param message 提示信息
 @param isCameraDeviceFront YES 前置摄像头 NO 后置摄像头
 @param sourceView 源视图实例，用于 iPad
 */
- (void)showPhotoPickerWithMessage:(NSString *_Nullable)message isCameraDeviceFront:(BOOL)isCameraDeviceFront sourceView:(UIView *_Nullable)sourceView;
/**
 显示选择拍照、选取照片，支持选择任意张照片。 (Show the camera/photo library selector, no limited photo multi selection.)
 
 @param message 提示信息
 @param sourceView 源视图实例，用于 iPad
 */
- (void)showPhotoPickerNoPhotoSelectionLimitWithMessage:(NSString *_Nullable)message sourceView:(UIView *_Nullable)sourceView API_AVAILABLE(ios(14));
/**
 显示选择拍照、选取照片，支持选择最多限定张数的照片。 (Show the camera/photo library selector, limited photo multi selection, maximum selection as you set.)
 
 @param message 提示信息
 @param photoSelectionLimit 选择照片的数量限制
 @param sourceView 源视图实例，用于 iPad
 */
- (void)showPhotoPickerWithMessage:(NSString *_Nullable)message photoSelectionLimit:(NSUInteger)photoSelectionLimit sourceView:(UIView *_Nullable)sourceView API_AVAILABLE(ios(14));
/**
 显示选择拍照、选取照片，仅支持选择一张照片。 (Show the camera/photo library selector, photo single selection.)
 
 @param message 提示信息
 @param completionHandler 操作回调
 */
- (void)showPhotoPickerWithMessage:(NSString *_Nullable)message completionHandler:(CompletionHandler)completionHandler;
/**
 同显示选择拍照、选取照片，仅支持选择一张照片，可设定拍照默认开启前置还是后置摄像头。(Same as the selector: -showPhotoPickerWithMessage:sourceView:completionHandler:, except: you may set front or rear camera as default when camera is on.)
 
 @param message 提示信息
 @param isCameraDeviceFront YES 前置摄像头 NO 后置摄像头
 @param completionHandler 操作回调
 */
- (void)showPhotoPickerWithMessage:(NSString *_Nullable)message isCameraDeviceFront:(BOOL)isCameraDeviceFront completionHandler:(CompletionHandler)completionHandler;
/**
 显示选择拍照、选取照片，支持选择任意张照片。 (Show the camera/photo library selector, no limited photo multi selection.)
 
 @param message 提示信息
 @param completionHandler 操作回调
 */
- (void)showPhotoPickerNoPhotoSelectionLimitWithMessage:(NSString *_Nullable)message completionHandler:(CompletionHandler)completionHandler API_AVAILABLE(ios(14));
/**
 显示选择拍照、选取照片，支持选择最多限定张数的照片。 (Show the camera/photo library selector, limited photo multi selection, maximum selection as you set.)
 
 @param message 提示信息
 @param photoSelectionLimit 选择照片的数量限制
 @param completionHandler 操作回调
 */
- (void)showPhotoPickerWithMessage:(NSString *_Nullable)message photoSelectionLimit:(NSUInteger)photoSelectionLimit completionHandler:(CompletionHandler)completionHandler API_AVAILABLE(ios(14));
/**
 显示选择拍照、选取照片，仅支持选择一张照片。 (Show the camera/photo library selector, photo single selection.)
 
 @param message 提示信息
 @param sourceView 源视图实例，用于 iPad
 @param completionHandler 操作回调
 */
- (void)showPhotoPickerWithMessage:(NSString *_Nullable)message sourceView:(UIView *_Nullable)sourceView completionHandler:(CompletionHandler)completionHandler;
/**
 同显示选择拍照、选取照片，仅支持选择一张照片，可设定拍照默认开启前置还是后置摄像头。(Same as the selector: -showPhotoPickerWithMessage:sourceView:completionHandler:, except: you may set front or rear camera as default when camera is on.)
 
 @param message 提示信息
 @param isCameraDeviceFront YES 前置摄像头 NO 后置摄像头
 @param sourceView 源视图实例，用于 iPad
 @param completionHandler 操作回调
 */
- (void)showPhotoPickerWithMessage:(NSString *_Nullable)message isCameraDeviceFront:(BOOL)isCameraDeviceFront sourceView:(UIView *_Nullable)sourceView completionHandler:(CompletionHandler)completionHandler;
/**
 显示选择拍照、选取照片，支持选择任意张照片。 (Show the camera/photo library selector, no limited photo multi selection.)
 
 @param message 提示信息
 @param sourceView 源视图实例，用于 iPad
 @param completionHandler 操作回调
 */
- (void)showPhotoPickerNoPhotoSelectionLimitWithMessage:(NSString *_Nullable)message sourceView:(UIView *_Nullable)sourceView completionHandler:(CompletionHandler)completionHandler API_AVAILABLE(ios(14));
/**
 显示选择拍照、选取照片，支持选择最多限定张数的照片。 (Show the camera/photo library selector, limited photo multi selection, maximum selection as you set.)
 
 @param message 提示信息
 @param photoSelectionLimit 选择照片的数量限制
 @param sourceView 源视图实例，用于 iPad
 @param completionHandler 操作回调
 */
- (void)showPhotoPickerWithMessage:(NSString *_Nullable)message photoSelectionLimit:(NSUInteger)photoSelectionLimit sourceView:(UIView *_Nullable)sourceView completionHandler:(CompletionHandler)completionHandler API_AVAILABLE(ios(14));
/**
 获取照片回调。(Photo picker callback handler use block.)
 */
@property (strong, nonatomic, nullable) void(^photoPickerFinishHandler)(id _Nonnull photoPicker, NSArray<UIImage *> *_Nonnull selectPhotos);

//MARK: Deprecated
/**
 类型已在极致框架2.0弃用，使用 CompletionHandler 来代替。(Use CompletionHandler instead, first deprecated in ExtremeFramework 2.0.)
 */
typedef void (^_Nullable completion)(void) EFDeprecated("Use CompletionHandler instead, first deprecated in ExtremeFramework 2.0.");
/**
 方法已在极致框架2.0弃用，使用 -privacyCameraAuthorizationWithCompletionHandler: 来代替。(Use -privacyCameraAuthorizationWithCompletionHandler: instead, first deprecated in ExtremeFramework 2.0.)
 */
- (void)privacyCameraAuthorizationWithCompletion:(completion)completion EFDeprecated("Use -privacyCameraAuthorizationWithCompletionHandler: instead, first deprecated in ExtremeFramework 2.0.");
/**
 方法已在极致框架2.0弃用，使用 -privacyPhotoLibraryAuthorizationWithCompletionHandler: 来代替。(Use -privacyPhotoLibraryAuthorizationWithCompletionHandler: instead, first deprecated in ExtremeFramework 2.0.)
 */
- (void)privacyPhotoLibraryAuthorizationWithCompletion:(completion)completion EFDeprecated("Use -privacyPhotoLibraryAuthorizationWithCompletionHandler: instead, first deprecated in ExtremeFramework 2.0.");
/**
 方法已在极致框架2.0弃用，使用 -showPhotoPickerWithMessage:sourceView:completionHandler: 来代替。(Use -showPhotoPickerWithMessage:sourceView:completionHandler: instead, first deprecated in ExtremeFramework 2.0.)
 */
- (void)showPhotoPickerWithMessage:(NSString *_Nullable)message sourceView:(UIView *_Nonnull)sourceView completion:(completion)completion EFDeprecated("Use -showPhotoPickerWithMessage:sourceView:completionHandler: instead, first deprecated in ExtremeFramework 2.0.");
/**
 方法已在极致框架2.0弃用，使用 -showPhotoPickerWithMessage:isCameraDeviceFront:sourceView:completionHandler: 来代替。(Use -showPhotoPickerWithMessage:isCameraDeviceFront:sourceView:completionHandler: instead, first deprecated in ExtremeFramework 2.0.)
 */
- (void)showPhotoPickerWithMessage:(NSString *_Nullable)message isFront:(BOOL)isFront sourceView:(UIView *_Nonnull)sourceView completion:(completion)completion EFDeprecated("Use -showPhotoPickerWithMessage:isCameraDeviceFront:sourceView:completionHandler: instead, first deprecated in ExtremeFramework 2.0.");
/**
 属性已在极致框架2.0弃用，使用 photoPickerFinishHandler 来代替。(Use photoPickerFinishHandler instead, first deprecated in ExtremeFramework 2.0.)
 */
@property (strong, nonatomic, nullable) void(^photoPickerResult)(UIImagePickerController *_Nonnull imagePicker, NSDictionary *_Nonnull mediaInfo) EFDeprecated("Use photoPickerFinishHandler instead, first deprecated in ExtremeFramework 2.0.");


#pragma mark - 录音是否授权
/**
获取隐私-麦克风权限。(Authorization for privacy use microphone.)

@param completionHandler 操作回调
 */
- (void)privacyMicrophoneAuthorizationWithCompletionHandler:(CompletionHandler)completionHandler;


#pragma mark - API调用与数据源 HTTPRequest and manager
/**
 如果调用了 HTTPTool，每一个数据任务都要都手动添加到这里。(Add every data task you've been created to the dataTasks.)
 */
@property (strong, nonatomic, nullable) NSMutableArray<NSURLSessionDataTask *> *dataTasks;

#pragma mark 用于嵌入的 tableView，需要先在基于 EFBaseViewController的控制器中的 -viewDidLoad 初始化 tableView 属性。(Use for added tableView, setup the tableView property on the -viewDidLoad in EFBaseViewController based controller first.)
/**
 一个添加以备使用的 tableView——类似于 tableViewController中的 tableView。(A tableView added to a normal viewController like tableView of tableViewController.)
 
 关于静态表格：(About tableView with staticCells:)
 cell的 identifier按指定命名规则命名即可实现类似 tableViewController中 tableView的 staticCells效果。(Follow the naming rules of cell's identifier, you may get the staticCells of tableView feature in viewController, just like in tableViewController.)
 cell的 identifier命名规则如下：单个 section，依次按照'c'+indexPath.row命名，譬如 c0,c1,c2,...以此类推，如果是多个 section，依次按照's'+indexPath.section+'c'+indexPath.row命名，譬如 s0c0,s0c1,s0c2,s1c0,s1c1,s2c0,...。(Naming rules of cell's identifier is here: a single section, named as 'c'+indexPath.row, like as c0, c1, c2,...etc. similarly, if multiple sections, named as 's'+indexpath.section+'c'+indexpath.row, like as s0c0,s0c1,s0c2,s1c0,s1c1,s2c0,...etc.)
 */
@property (weak, nonatomic, nullable) UITableView *tableView;
/**
 提供静态 cell时，单个 section需要配置 numberOfRows，而多个 section的话，需要在基于 EFBaseViewController的控制器中实现 -tableView:numberOfRowsInSection: 代理方法。(When providing static cells, setup the numberOfRows property needed for default single section, for more than one section please responds selector -tableView:numberOfRowsInSection: in EFBaseViewController based controller.)
 */
@property (assign, nonatomic) NSUInteger numberOfRows;
/**
 提供静态 cell时，如果有多个 section则要配置 sections。(When providing static cells, setup the sections property if there are more than one section.)
 */
@property (assign, nonatomic) NSUInteger sections;

#pragma mark 数据源 Data source for view controller embed table view
/**
 数据源，一般应以基于 BaseDataModel的 model为元素。(The data source, element is BaseDataModel based model.)
 */
@property (strong, nonatomic, nullable) NSMutableArray *dataSource_mArray;


#pragma mark - 无数据提示 Show icon/text when no data
/**
 自定义没有数据提示的图像文件名，宽高默认 100。(Use image for no data view, width/height 100 as default.)
 */
@property (copy, nonatomic, nullable) NSString *noDataImageName;
/**
 自定义没有数据提示的图像文件名，以及图像宽度、高度。(Use image for no data view, and custom width/height.)
 
 @param noDataImageName 图像文件名
 @param width 图像宽度
 @param height 图像高度
 */
- (void)setNoDataImageName:(NSString *_Nonnull)noDataImageName width:(CGFloat)width height:(CGFloat)height;
/**
 自定义没有数据提示的图像文件名、扩展名，目前主要用于 gif图像，宽高默认 100。(Use gif image for no data view, width/height 100 as default.)
 
 @param noDataImageName 图像文件名
 @param noDataImageExt 图像扩展名，目前支持 gif (gif supported)
 */
- (void)setNoDataImageName:(NSString *_Nonnull)noDataImageName noDataImageExt:(NSString *_Nonnull)noDataImageExt;
/**
 自定义没有数据提示的图像文件名、扩展名，以及图像宽度、高度，目前主要用于 gif图像。(Use gif image for no data view, and custom width/height.)
 
 @param noDataImageName 图像文件名
 @param noDataImageExt 图像扩展名，目前支持 gif (gif supported)
 @param width 图像宽度
 @param height 图像高度
 */
- (void)setNoDataImageName:(NSString *_Nonnull)noDataImageName noDataImageExt:(NSString *_Nullable)noDataImageExt width:(CGFloat)width height:(CGFloat)height;

/// 自定义没有数据提示的文字字体。(For custom text's font of no data view.)
@property (strong, nonatomic, nullable) UIFont *noDataTextFont;
/// 自定义没有数据提示的文字颜色。(For custom text's color of no data view.)
@property (strong, nonatomic, nullable) UIColor *noDataTextColor;
/**
 自定义没有数据提示的文字，宽度默认 160，行数默认 1。(Use text for no data view, width 160 as default, 1 line as default.)
 */
@property (copy, nonatomic, nullable) NSString *noDataText;
/**
 自定义没有数据提示的文字与宽度，行数默认 1。(Use text for no data view, and custom width, 160<width<SCREEN_WIDTH, 1 line as default.)
 
 @param noDataText 没有数据提示的文字
 @param width 宽度，160<width<SCREEN_WIDTH
 */
- (void)setNoDataText:(NSString *_Nonnull)noDataText width:(CGFloat)width;
/**
 自定义没有数据提示的文字与行数，宽度默认 160。(Use text for no data view, and custom lines, 0<lines<4, width 160 as default.)
 
 @param noDataText 没有数据提示的文字
 @param lines 行数，0<lines<4
 */
- (void)setNoDataText:(NSString *_Nonnull)noDataText lines:(NSUInteger)lines;
/**
 自定义没有数据提示的文字、宽度与行数。(Use text for no data view, and custom lines and width, 0<lines<4, 160<width<SCREEN_WIDTH.)
 
 @param noDataText 没有数据提示的文字
 @param width 宽度，160<width<SCREEN_WIDTH
 @param lines 行数，0<lines<4
 */
- (void)setNoDataText:(NSString *_Nonnull)noDataText width:(CGFloat)width lines:(NSUInteger)lines;

/**
 启用调试图层。(Enable debug layer.)
 */
@property (assign, nonatomic) BOOL enableNoDataDebug;
/**
 显示没有数据提示。
 */
- (void)showNoData;
/**
 隐藏没有数据提示。
 */
- (void)hideNoData;


#pragma mark - 刷新与分页支持 Refresh and pageable
/**
 启用原生下拉刷新，YES 启用 NO 不启用，启用后需要实现 -refresh:方法，默认不启用。(NO as default, if setup YES, override -refresh: method.)
 */
@property (assign, nonatomic, getter=isRefreshEnabled) BOOL refreshEnabled;

/**
 等同于 tableViewController中的 refreshControl。(Like refreshControl in tableViewController.)
 */
@property (strong, nonatomic, nullable) UIRefreshControl *refreshControl;

/**
 启用下拉刷新与上拉加载更多，YES 启用 NO 不启用，启用后需要实现 -loadData和 -loadMoreDataWithPageNumber:方法，默认不启用。(NO as default, if setup YES, override -loadData and -loadMoreDataWithPageNumber: methods.)
 */
@property (assign, nonatomic, getter=isMJRefreshEnabled) BOOL MJRefreshEnabled;
/**
 下拉刷新视图，默认调用 -loadData方法，可以自定义执行方法。(Perform method -loadData as default, custom a new method if you need.)
 */
@property (strong, nonatomic, nullable) MJRefreshNormalHeader *refreshHeader;
/**
 上拉加载更多视图，默认调用 -loadMoreDataWithPageNumber:方法，可以自定义执行方法。(Perform method -loadMoreDataWithPageNumber: if can load more data as default, custom a new method if you need.)
 */
@property (strong, nonatomic, nullable) MJRefreshBackNormalFooter *refreshFooter;

/**
 当前页码，数据加载成功后初始值为 1。(1 as default.)
 */
@property (assign, nonatomic) NSUInteger pageNumber;

/**
 记录总数。
 */
@property (assign, nonatomic) NSUInteger rowsCount;


#pragma mark - 输入聚焦，用于嵌入的 tableView，需要先在基于 EFBaseViewController的控制器中的 -viewDidLoad 初始化 tableView 属性。(Use for added tableView input focus, setup the tableView property on the -viewDidLoad in EFBaseViewController based controller first.)
/**
 聚焦的控件。(Setup the focusedControl if you want scroll to it. )
 */
@property (strong, nonatomic, nullable) UIView *focusedControl;
/**
 调整 tableView的边距以适应键盘，如果设置了 focusedContentOffset还将滚动到指定位置。(Adjust content insets of the tableView to fit keyboard, if the focusedContentOffset property setup, then scroll to it.)
 */
@property (assign, nonatomic) BOOL adjustTableViewEdgeInsetsToFitKeyboard;

@end
