//
//  BPQRCodeReaderController.h
//  Demo_QRCodeScanning
//
//  Created by milton on 16/7/18.
//  Copyright © 2016年 milton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BPQRCodeReaderController : UIViewController
/**扫描框下方的label*/
@property (nonatomic, strong)UILabel *scanningLabel;
/**扫描线*/
@property (nonatomic, strong)UIImageView *scanningLine;
/**默认只扫描二维码*/

-(instancetype)initWithScanningResult:(void(^)(NSString *scanningResult ))qrCodeReaderResult_Block;
@end
