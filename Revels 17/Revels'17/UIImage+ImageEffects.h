//
//  UIImage+ImageEffects.h
//  Revels'17
//
//  Created by Abhishek Vora on 17/02/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageEffects)

- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor :(float)radius;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius iterationsCount:(NSInteger)iterationsCount tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

@end
