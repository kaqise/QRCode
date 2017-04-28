//
//  BPQRCodeManager.m
//  Demo2
//
//  Created by 张保平 on 16/7/9.
//  Copyright © 2016年 baoping.zhang. All rights reserved.
//

#import "BPQRCodeManager.h"

@implementation BPQRCodeManager
/**生成二维码*/
+(UIImage *)bp_GetQRCodeImageWithText:(NSString *)qrStr andSize:(CGSize)size andColor:(UIColor *)color andBackGroundColor:(UIColor *)backGroundColor codeStyle:(CIQRCodeStyle)codeStyle{
    // 1.实例化二维码滤镜
    CIFilter *filter;
    switch (codeStyle) {
        case CIQRCodeStyleGenerator:
            filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];//二维码
            break;
        case CIQRCodeStyle128BarcodeGenerator:
            filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];//条形码
            break;
        default:
            break;
    }
    // 2.恢复滤镜的默认属性 (因为滤镜有可能保存上一次的属性)
    [filter setDefaults];
    
    // 3.将字符串转换成NSdata
    NSData *data  = [qrStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
    // 4.通过KVO设置滤镜, 传入data, 将来滤镜就知道要通过传入的数据生成二维码
    [filter setValue:data forKey:@"inputMessage"];
    // 颜色滤镜
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"];
    // 5.将生成的二维码图片放到颜色滤镜下处理
    [colorFilter setValue:filter.outputImage forKey:@"inputImage"];
    // 6.当二维码颜色没设置时，默认使用黑色二维码
    if (!color) {
        color = [UIColor blackColor];
    }
    [colorFilter setValue:[CIColor colorWithCGColor:color.CGColor] forKey:@"inputColor0"];
    // 7.当二维码背景颜色没有设置时，默认使用白色背景颜色
    if (!backGroundColor) {
        backGroundColor = [UIColor whiteColor];
    }
    [colorFilter setValue:[CIColor colorWithCGColor:backGroundColor.CGColor] forKey:@"inputColor1"];
    
    // 8.生成二维码
    CIImage *outputImage = colorFilter.outputImage;
    // 9.二维码变清晰
    CIImage *image1 = [outputImage imageByApplyingTransform:(CGAffineTransformScale(CGAffineTransformIdentity, size.width/outputImage.extent.size.width, outputImage.extent.size.height))];
    
    UIImage *image2 = [UIImage imageWithCIImage:image1];
    return image2;
    
}

/**调整画布摆放的位置*/
+ (UIImage *)imageWithCIImage:(CIImage *)aCIImage orientation: (UIImageOrientation)anOrientation
{
    if (!aCIImage) return nil;
    
    CGImageRef imageRef = [[CIContext contextWithOptions:nil] createCGImage:aCIImage fromRect:aCIImage.extent];
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:anOrientation];
    CFRelease(imageRef);
    
    return image;
}
/**配置画布质量及尺寸*/
+ (UIImage *)resizeImageWithoutInterpolation:(UIImage *)sourceImage size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(), kCGInterpolationNone);
    [sourceImage drawInRect:(CGRect){.size = size}];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}
@end
