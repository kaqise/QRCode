//
//  BPQRCodeReader.h
//  BPQRCodeReaderDemo
//
//  Created by milton on 16/7/20.
//  Copyright © 2016年 baoping.zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

typedef void(^BPQcodeReaderResult_Block)(NSString *resultStr);

@interface BPQRCodeReader : NSObject<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic)CGRect scanningRect;//扫描区域frame

@property (nonatomic, strong)NSArray<NSString*> *metadataObjectTypes;//设置媒体输出类型
@property (nonatomic, strong)AVCaptureDevice *captureDevice;

@property (nonatomic, strong)AVCaptureSession *captureSession;//会话

@property (nonatomic, strong)AVCaptureMetadataOutput *metadataOutput;//输出流
@property (nonatomic, strong)AVCaptureVideoPreviewLayer *videoPreviewLayer;
-(instancetype)initCodeReaderWithDeviceWithMediaType:(NSString*)mediaType scanningResult:(BPQcodeReaderResult_Block)sacnningResult;
- (void)startScanning;
- (void)stopScanning;
@end
