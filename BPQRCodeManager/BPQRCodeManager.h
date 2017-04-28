//
//  BPQRCodeManager.h
//  Demo2
//
//  Created by 张保平 on 16/7/9.
//  Copyright © 2016年 baoping.zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum{
    CIQRCodeStyleGenerator,
    CIQRCodeStyle128BarcodeGenerator
}CIQRCodeStyle;
@interface BPQRCodeManager : NSObject
/**根据字符串生成二维码*/
+(UIImage*)bp_GetQRCodeImageWithText:(NSString*)qrStr andSize:(CGSize)size andColor:(UIColor*)color andBackGroundColor:(UIColor*)backGroundColor codeStyle:(CIQRCodeStyle)codeStyle;
/**根据字符串生成条形码*/

@end
