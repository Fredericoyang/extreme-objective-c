//
//  CodeScanerTool.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/10/12.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface CodeScanerTool : EFBaseViewController

@property (weak, nonatomic, readwrite) IBOutlet UIImageView *imageLine;
@property (weak, nonatomic, readwrite) IBOutlet UIImageView *imageFrame;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageFrameTopSpace;

/**
 扫一扫回调。
 */
@property (strong, nonatomic, nullable) void (^Callback)(NSString *result);

@end

NS_ASSUME_NONNULL_END
