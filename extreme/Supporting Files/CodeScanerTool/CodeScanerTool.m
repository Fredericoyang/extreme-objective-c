//
//  CodeScanerTool.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/10/12.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

#import "CodeScanerTool.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface CodeScanerTool () <AVCaptureMetadataOutputObjectsDelegate>

@property (assign, nonatomic) BOOL isScaned;
@property (strong, nonatomic, nullable)NSString *resultString;

@end

@implementation CodeScanerTool {
    AVCaptureSession *session;//获取输入的中间桥梁
    AVCaptureDevice *device; //获取摄像头
    AVCaptureDeviceInput *input;//创建输入流
    AVCaptureMetadataOutput *outPut;//创建输出流
    AVCaptureVideoPreviewLayer *layer;//扫描窗口
    
    SystemSoundID _soundID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self privacyCameraAuthorizationWithCompletion:^{
        [self initScanningContent];
        [self sessionStartRunning];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationBarStyle = EFBarStyleBlack;
    self.navigationBar.dark = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationBarStyle = EFBarStyleDefault;
    self.navigationBar.dark = NO;
}


- (void)initScanningContent{
    session = [[AVCaptureSession alloc] init];
    //获取摄像头设备
    device  = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //输出流
    NSError *inputError;
    input  = [AVCaptureDeviceInput deviceInputWithDevice:device error:&inputError];
    //创建输出流
    outPut = [[AVCaptureMetadataOutput alloc] init];
    //设置代理，主线程刷新
    [outPut setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([session canAddInput:input]) {
        [session addInput:input];
    }
    if ([session canAddOutput:outPut]) {
        [session addOutput:outPut];
    }
    
    
    //设置扫描支持的编码格式
    [outPut setMetadataObjectTypes:[outPut availableMetadataObjectTypes]];
    layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    //相机设置可见范围
    CGRect cameraRect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    layer.frame = cameraRect;
    [self.view.layer addSublayer:layer];
    
    //开始捕捉
    [session startRunning];
    
    //设置扫描作用区域范围
    CGRect scanerRect = CGRectMake(SCREEN_CENTER.x-FRAME_WIDTH(_imageFrame)/2, SCREEN_CENTER.y-TOP_LAYOUT_HEIGHT/2, FRAME_WIDTH(_imageFrame), FRAME_HEIGHT(_imageFrame));
    CGRect intertRect = [layer metadataOutputRectOfInterestForRect:scanerRect];
    outPut.rectOfInterest = intertRect;
    
    //添加全屏的黑色半透明蒙版
    CGRect maskRect = CGRectMake(0, TOP_LAYOUT_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-TOP_LAYOUT_HEIGHT);
    UIView *maskView = [[UIView alloc] initWithFrame:maskRect];
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.view addSubview:maskView];
    [self.view addSubview:_imageLine];
    CGRect scanerFrameRect = CGRectMake(SCREEN_CENTER.x-FRAME_WIDTH(_imageFrame)/2, SCREEN_CENTER.y-TOP_LAYOUT_HEIGHT/2-FRAME_HEIGHT(_imageFrame)/2, FRAME_WIDTH(_imageFrame), FRAME_HEIGHT(_imageFrame));
    _imageFrameTopSpace.constant = scanerFrameRect.origin.y;
    [self.view addSubview:_imageFrame];
    
    //从蒙版中扣出扫描框那一块
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.view.bounds];
    [maskPath appendPath:[[UIBezierPath bezierPathWithRoundedRect:scanerFrameRect cornerRadius:1] bezierPathByReversingPath]];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = maskPath.CGPath;
    maskView.layer.mask = maskLayer;
}

- (void)sessionStartRunning{
    if (session!=nil) {
        [session startRunning];
        //开始动画
        [self performSelectorOnMainThread:@selector(timerFired) withObject:nil waitUntilDone:NO];
    }
}

/**
 *  加载动画
 */
-(void)timerFired {
    [self.imageLine.layer addAnimation:[self moveY:3 Y:[NSNumber numberWithFloat:_imageFrame.size.height-9]] forKey:nil];
}

- (void)resetImageY{
    [self.imageLine.layer performSelectorOnMainThread:@selector(removeAllAnimations) withObject:nil waitUntilDone:YES];
}

/**
 *  扫描线动画
 *
 *  @param time 单次滑动完成时间
 *  @param y    滑动距离
 *
 *  @return 返回动画
 */
-(CABasicAnimation *)moveY:( float )time Y:( NSNumber *)y {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath : @"transform.translation.y" ]; ///.y 的话就向下移动。
    animation.toValue = y;
    animation.duration = time;
    animation.removedOnCompletion = NO ;
    animation.repeatCount = MAXFLOAT ;
    animation.fillMode = kCAFillModeForwards ;
    return animation;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
/**
 *  获取扫描到的结果
 *
 *  @param captureOutput   输出
 *  @param metadataObjects 结果
 *  @param connection      连接
 */
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (!_isScaned) {
        if (metadataObjects.count>0) {
            [session stopRunning];
            AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
            if ([metadataObject isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
                if (![EFUtils stringIsNullOrEmpty:metadataObject.stringValue]) {
                    _isScaned = YES;
                    //处理条形/二维码
                    if (_Callback) {
                        _Callback(metadataObject.stringValue);
                        RUN_AFTER(SVShowStatusDelayTime, ^{
                            self->_isScaned = NO;
                            [self->session startRunning];
                        });
                    }
                    else {
                        self->_isScaned = NO;
                        [self->session startRunning];
                    }
                }
                else {
                    self->_isScaned = NO;
                    [self->session startRunning];
                }
            }
            else {
                self->_isScaned = NO;
                [self->session startRunning];
            }
        }
    }
}

- (void)playSound {
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:@"ding" ofType:@"wav"];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    //1.获得系统声音ID
    _soundID = 0;
    /**
     * inFileUrl:音频文件url
     * outSystemSoundID:声音id（此函数会将音效文件加入到系统音频服务中并返回一个长整形ID）
     */
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &_soundID);
    //如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
    AudioServicesAddSystemSoundCompletion(_soundID, NULL, NULL, soundCompleteCallback, NULL);
    //2.播放音频
    AudioServicesPlaySystemSound(_soundID);//播放音效
//    AudioServicesPlayAlertSound(_soundID);//播放音效并震动
}

- (void)disposeSound {
    //3.销毁声音
    AudioServicesDisposeSystemSoundID(_soundID);
}

/**
 *  播放完成回调函数
 *
 *  @param soundID    系统声音ID
 *  @param clientData 回调时传递的数据
 */
void soundCompleteCallback(SystemSoundID soundID,void * clientData){
    
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

