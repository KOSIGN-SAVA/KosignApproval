//
//  UIImage+Scale.h
//
//  Created by Yongjoo Park on 2/16/11.
//  Copyright 2011 Webcash. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (effect)

//이미지 자체의 배율 구조가 아니고 높이와 넓이를 각각 주어야 할 경우 이미지의 해상도 보장이 되지 않는 메소드 
- (UIImage*)scaleToSize:(CGSize)size;

//이미지 자체의 배율 구조로 해상도가 깨지지 않고 진행 할수 있는 함수이다.
// imageWithCGImage:scale:orientation: (Available in iOS 4.0 and later.)
- (UIImage *)imageScale:(CGFloat)scale;


- (UIImage *)croppedImage:(CGRect)bounds;
- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize transparentBorder:(NSUInteger)borderSize cornerRadius:(NSUInteger)cornerRadius interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode bounds:(CGSize)bounds interpolationQuality:(CGInterpolationQuality)quality;



//Alpha관련 Mehtod
- (BOOL)hasAlpha;
- (UIImage *)imageWithAlpha;
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize;


//이미지 라운드 처리 Method
// Original author: Björn Sållarp. Used with permission. See: http://blog.sallarp.com/iphone-uiimage-round-corners/
- (UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize;

@end
