//
//  UIImage+Addtions.m
//  DispathOnLine
//
//  Created by 苏凡 on 16/3/16.
//  Copyright © 2016年 sufan. All rights reserved.
//

#import "UIImage+Addtions.h"

@implementation UIImage(Addtions)

- (UIImage *)fixOrientation{
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp)
        return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


- (NSData *)scaleToSize {
    NSData *imageData = UIImageJPEGRepresentation(self, 1.0);
    if ((float)imageData.length/1024 > 85.0) {
        if (self.size.width < self.size.height) {
            if (self.size.width>780.0) {
                CGFloat s = 780.0/self.size.width;
                CGSize size = CGSizeMake(self.size.width*s, self.size.height*s);
                NSLog(@"size :: %@",NSStringFromCGSize(size));
                // 创建一个bitmap的context
                // 并把它设置成为当前正在使用的context
                UIGraphicsBeginImageContext(size);
                // 绘制改变大小的图片
                [self drawInRect:CGRectMake(0, 0,size.width, size.height)];
                // 从当前context中创建一个改变大小后的图片
                UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
                // 使当前的context出堆栈
                UIGraphicsEndImageContext();
                // 返回新的改变大小后的图片
                imageData = UIImageJPEGRepresentation(scaledImage, 1.0);
                NSLog(@"imagesize : %f",(float)imageData.length/1024);
                if ((float)imageData.length/1024 > 85.0) {
                    CGFloat sss =  SCREEN_HIGHT== 480?0.55:0.45;
                    imageData = UIImageJPEGRepresentation(scaledImage, sss);
                }
            }else{
                if ((float)imageData.length/1024 > 85.0) {
                    CGFloat sss =  SCREEN_HIGHT== 480?0.55:0.45;
                    imageData = UIImageJPEGRepresentation(self, sss);
                }
            }
        }else{
            if (self.size.height > 780.0) {
                CGFloat s = 780.0/self.size.height;
                CGSize size = CGSizeMake(self.size.width*s, self.size.height*s);
                NSLog(@"size :: %@",NSStringFromCGSize(size));
                // 创建一个bitmap的context
                // 并把它设置成为当前正在使用的context
                UIGraphicsBeginImageContext(size);
                // 绘制改变大小的图片
                [self drawInRect:CGRectMake(0, 0,size.width, size.height)];
                // 从当前context中创建一个改变大小后的图片
                UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
                // 使当前的context出堆栈
                UIGraphicsEndImageContext();
                // 返回新的改变大小后的图片
                imageData = UIImageJPEGRepresentation(scaledImage, 1.0);
                NSLog(@"imagesize : %f",(float)imageData.length/1024);
                if ((float)imageData.length/1024 > 85.0) {
                    CGFloat sss =  SCREEN_HIGHT== 480?0.55:0.45;
                    imageData = UIImageJPEGRepresentation(scaledImage, sss);
                }
            }else{
                if ((float)imageData.length/1024 > 85.0) {
                    CGFloat sss =  SCREEN_HIGHT== 480?0.55:0.45;
                    imageData = UIImageJPEGRepresentation(self, sss);
                }
            }
            
            
        }
    }
    return imageData;
}

@end
