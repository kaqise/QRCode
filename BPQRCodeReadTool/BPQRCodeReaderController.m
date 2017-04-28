//
//  BPQRCodeReaderController.m
//  Demo_QRCodeScanning
//
//  Created by milton on 16/7/18.
//  Copyright © 2016年 milton. All rights reserved.
//

#import "BPQRCodeReaderController.h"
#import <AVFoundation/AVFoundation.h>
#import "BPQRCodeReaderView.h"
#import "BPQRCodeReader.h"

@interface BPQRCodeReaderController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
/**扫描二维码的视图*/
@property (nonatomic, strong)BPQRCodeReaderView *readerView;
@property (nonatomic, strong)BPQRCodeReader *readerManager;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, strong)AVAudioPlayer *audioPlayer;
@property (nonatomic, strong)CIDetector *detector;
@end

@implementation BPQRCodeReaderController
{
    void(^_positionBlock)(NSString *scanningResult);
}

#pragma mark - LazyLoad 懒加载
-(BPQRCodeReaderView *)readerView{
    if (!_readerView) {
        _readerView = [[BPQRCodeReaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width * 0.6, self.view.bounds.size.width * 0.6)];
        CGPoint center = self.view.center;
        center.y -= self.view.bounds.size.height * 0.1;
        _readerView.center = center;
    }
    return _readerView;
}
- (UILabel *)scanningLabel{
    if (!_scanningLabel) {
        _scanningLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 21)];
        CGPoint center = self.readerView.center;
        center.y += self.readerView.bounds.size.height * 0.75;
        _scanningLabel.center =center;
        _scanningLabel.textAlignment = NSTextAlignmentCenter;
        _scanningLabel.font = [UIFont systemFontOfSize:18];
        _scanningLabel.textColor = [UIColor grayColor];
        _scanningLabel.text = @"将二维码放入框中 即可扫描";
    }
    return _scanningLabel;
}
-(UIImageView *)scanningLine{
    if (!_scanningLine) {
        _scanningLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, self.readerView.bounds.size.width, 2)];
        _scanningLine.contentMode = UIViewContentModeScaleAspectFill;
        _scanningLine.image = [UIImage imageNamed:@"QRCodeScanLine@2x.png"];
    }
    return _scanningLine;
}
- (BPQRCodeReader *)readerManager{
    if (!_readerManager) {
        __weak typeof(self) weakSelf = self;
        _readerManager = [[BPQRCodeReader alloc]initCodeReaderWithDeviceWithMediaType:AVMediaTypeVideo scanningResult:^(NSString *resultStr) {
            _positionBlock(resultStr);
            [weakSelf.audioPlayer play];
            [weakSelf.readerManager stopScanning];
            [weakSelf.timer invalidate];

        }];
    }
    return _readerManager;
}
-(AVAudioPlayer *)audioPlayer{
    if (!_audioPlayer) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"wav"];
        NSData *data = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:nil];
        _audioPlayer = [[AVAudioPlayer alloc]initWithData:data error:nil];
    }
    return _audioPlayer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"QRCode Scanning";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(rightBarButtonItemClick:)];
    [self configScanningComponent];
}
#pragma mark - pickerView跳转
- (void)rightBarButtonItemClick:(UIBarButtonItem*)item{
    self.detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    UIImagePickerController *pickerViewController = [[UIImagePickerController alloc]init];
    pickerViewController.delegate = self;
    pickerViewController.allowsEditing = NO;
    pickerViewController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.navigationController presentViewController:pickerViewController animated:YES completion:nil];
}
#pragma mark - pickerView代理方法

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }

    NSArray *features = [self.detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count >=1) {
        CIQRCodeFeature *feature = [features objectAtIndex:0];
        NSString *scannedResult = feature.messageString;
        if (_positionBlock) {
            [self.audioPlayer play];
            _positionBlock(scannedResult);
        }
    }

}
#pragma mark - 重写init方法
-(instancetype)initWithScanningResult:(void (^)(NSString *))qrCodeReaderResult_Block{
    self = [super init];
    if (self) {
        _positionBlock = qrCodeReaderResult_Block;
        
    }
    return self;
}
#pragma mark - 扫描线位置更新
- (void)updateScanningLine{
    __weak typeof(self)weakSelf = self;
    weakSelf.scanningLine.frame = CGRectMake(0, 3, weakSelf.readerView.bounds.size.width, 2);
    
    [UIView animateWithDuration:2 animations:^{
        weakSelf.scanningLine.frame = CGRectMake(0, weakSelf.readerView.bounds.size.height - 3, weakSelf.readerView.bounds.size.width, 2);
    }];
}
#pragma mark - 编辑扫码所用的组件
- (void)configScanningComponent{
    [self.view.layer addSublayer:self.readerManager.videoPreviewLayer];
    [self.view addSubview:self.readerView];
    [self.view addSubview:self.scanningLabel];
    [self.readerView addSubview:self.scanningLine];
    [self updateScanningLine];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(updateScanningLine) userInfo:nil repeats:YES];
    [self.readerManager startScanning];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
    [self.readerManager stopScanning];
}

@end
