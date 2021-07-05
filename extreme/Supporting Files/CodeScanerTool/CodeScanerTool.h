//
//  CodeScanerTool.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/10/12.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "CodeScanerConfig.h"

@interface CodeScanerTool : EFBaseViewController

@property (weak, nonatomic, readwrite, nullable) IBOutlet UIImageView *imageLine;
@property (weak, nonatomic, readwrite, nullable) IBOutlet UIImageView *imageFrame;
@property (weak, nonatomic, nullable) IBOutlet NSLayoutConstraint *imageFrameTopSpace;

/**
 扫一扫回调。
 */
@property (strong, nonatomic, nullable) void (^callbackHandler)(NSString *_Nullable result);

//MARK: Deprecated
/**
 属性已在极致框架2.0弃用，使用 callbackHandler 来代替。(Use callbackHandler instead, first deprecated in ExtremeFramework 2.0.)
 */
@property (strong, nonatomic, nullable) void(^Callback)(NSString *_Nullable result) EFDeprecated("Use callbackHandler instead, first deprecated in ExtremeFramework 2.0.");

@end
