//
//  UIPageControl+Fix4iOS14.h
//  iUIPageControlFix4iOS14
//
//  Created by mac on 2020/9/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 结合runtime 自定义UIPageControl
 */
@interface UIPageControl (Fix4iOS14)


/** 设置page control图片 */
- (void)kn_SetCurrentImage:(UIImage *)currentImage pageImage:(UIImage *)pageImage;


@end

NS_ASSUME_NONNULL_END
