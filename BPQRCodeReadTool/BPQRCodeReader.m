//
//  BPQRCodeReader.m
//  BPQRCodeReaderDemo
//
//  Created by milton on 16/7/20.
//  Copyright © 2016年 baoping.zhang. All rights reserved.
//

#import "BPQRCodeReader.h"

#define kScreen_With [UIScreen mainScreen].bounds.size.width
#define kScreen_Height [UIScreen mainScreen].bounds.size.height

@implementation BPQRCodeReader
{
    BPQcodeReaderResult_Block _positionBlock;
}
-(instancetype)initCodeReaderWithDeviceWithMediaType:(NSString *)mediaType scanningResult:(BPQcodeReaderResult_Block)sacnningResult{
    if (self = [super init]) {
        _positionBlock = sacnningResult;
        [self configQRCodeReaderComponentWithType:mediaType];
    }
    return self;
}
#pragma mark - 编辑扫码所用的组件
- (void)configQRCodeReaderComponentWithType:(NSString*)mediaTpye{
    
    NSError *error;
    _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:mediaTpye];//捕捉所应用的设备
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_captureDevice error:&error];//根据捕捉设备初始化输入流
    if (!deviceInput) {
        NSLog(@"%@",error.localizedDescription);
        return;
    }
    _captureSession = [[AVCaptureSession alloc]init];//初始化捕捉会话
    
    _metadataOutput = [[AVCaptureMetadataOutput alloc]init];//初始化输出流
    
    [_captureSession addInput:deviceInput];
    [_captureSession addOutput:_metadataOutput];//将 输入/输出 流添加到捕捉会话
    
    [_metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];//将输出流添加到串行队列中
    [_metadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];//设置输出媒体类型
    
    _videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];//设置预览图的填充方式
    
    [_videoPreviewLayer setFrame:[UIScreen mainScreen].bounds];
    
    [_captureSession startRunning];
}
#pragma mark - 设置扫码区域
-(void)setScanningRect:(CGRect)scanningRect{
    _scanningRect = scanningRect;
    CGFloat scale_X = scanningRect.origin.x / kScreen_With;
    CGFloat scale_Y = scanningRect.origin.y / kScreen_Height;
    CGFloat scale_W = scanningRect.size.width / kScreen_With;
    CGFloat scale_H = scanningRect.size.height / kScreen_Height;
    [_metadataOutput setRectOfInterest:CGRectMake(scale_X, scale_Y, scale_W, scale_H)];//设置扫描区域的大小(是X,Y,W,H与屏幕的比例)
}
-(void)setMetadataObjectTypes:(NSArray<NSString *> *)metadataObjectTypes{
    [_metadataOutput setMetadataObjectTypes:metadataObjectTypes];
}
#pragma mark - 开始扫描
- (void)startScanning{
    [self.captureSession startRunning];
}
#pragma mark - 停止扫描
- (void)stopScanning{
    [self.captureSession stopRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    [metadataObjects enumerateObjectsUsingBlock:^(AVMetadataObject *object, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([object isKindOfClass:[AVMetadataMachineReadableCodeObject class]] && [_metadataOutput.metadataObjectTypes containsObject:object.type]) {
            NSString *scanningResult = [(AVMetadataMachineReadableCodeObject*)object stringValue];
            !_positionBlock ?: _positionBlock(scanningResult);
        }
    }];
}

@end
