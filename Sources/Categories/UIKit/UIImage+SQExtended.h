//
//  UIImage+SQExtended.h
//  VseMayki
//
//  Created by Sequenia on 17/05/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SQExtended)

- (UIImage *)sq_imageBlendWithColor:(UIColor *)color;

/**
 * Создает изображение, залитое указанным цветом
 */
+ (UIImage *)sq_imageWithColor:(UIColor *)color;

/**
 * Создает изображение, залитое цветом
 * color UIColor - цвет заливки
 * rect CGRect - размер выходного изображения
 */
+ (UIImage *)sq_imageFromColor:(UIColor *)color
                     inRect:(CGRect)rect;

/**
 * Масштабирует картинку
 * width CGFloat - ширина выходной картинки (высота высчитывается пропорционально)
 * Рекомендуется запускать в background-потоке
 */
- (UIImage *)sq_scaleProportionalToWidth:(CGFloat)width;

/**
 * Масштабирует картинку
 * width CGFloat - размер максимальной стороны выходной картинки (минимальная сторона высчитывается пропроционально)
 * Рекомендуется запускать в background-потоке
 */
- (UIImage *)sq_scaleProportionalToMaxSide:(CGFloat)width;

/**
 * Масштабирует картинку
 * size CGSize - размер, в который будет вписана выходная картинка
 * Рекомендуется запускать в background-потоке
 */
- (UIImage *)sq_scaleProportionalToSize:(CGSize)size;

- (UIImage *)sq_scaleProportionalToSize:(CGSize)size
             screenScale:(CGFloat)screenScale;

/**
 * Вырезает из середины картинки фрагмент
 * image UIImage - картинка для обрезки
 * size CGSize - размер фрагмента
 * Рекомендуется запускать в background-потоке
 */
- (UIImage *)sq_cropToSize:(CGSize)size;

/**
 * Корректирует ориентацию картинки
 * Рекомендуется запускать в background-потоке
 */
- (UIImage *)sq_fixOrientation;


/**
 * Накладывает размытие указанного радиуса на картинку
 * Рекомендуется запускать в background-потоке
 */
- (UIImage *)sq_blurWithRadius:(CGFloat)radius;

@end
