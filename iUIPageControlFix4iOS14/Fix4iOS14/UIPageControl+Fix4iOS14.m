//
//  UIPageControl+Fix4iOS14.m
//  iUIPageControlFix4iOS14
//
//  Created by mac on 2020/9/24.
////iOS14 适配:【KVC 不允许访问 UIPageControl的pageImage解决方案】借助新增API：preferredIndicatorImage 修改指示器小圆点的大小及形状（两种方案）
//https://kunnan.blog.csdn.net/article/details/108116874

#import "UIPageControl+Fix4iOS14.h"
#import <objc/runtime.h>


@interface UIPageControl ()


@property (nonatomic, strong) UIImage *KN_currentImage;

@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, UIImageView *> *KN_indicatorImages;


@end

@implementation UIPageControl (Fix4iOS14)


static BOOL KN_shouldTreatImageAsTemplate(UIImageView *obj, SEL sel, id arg1) {
    
    UIPageControl *pageControl = (id)obj;
    while ((pageControl = (id)pageControl.superview)) {
        if ([pageControl isKindOfClass:[UIPageControl class]]) {
            if (pageControl.KN_currentImage) {
                [pageControl.KN_indicatorImages setValue:obj forKeyPath:[[obj valueForKeyPath:@"_page"] description]];
                return NO;
            } else {
                break;
            }
        }
    }
    // 默认走系统的实现
    return ((BOOL (*)(UIView *, SEL, id))class_getMethodImplementation(obj.superclass, sel))(obj, sel, arg1);
}

+ (void)load {
    if (@available(iOS 14, *)) {
        Class clazz = NSClassFromString(@"_UIPageIndicatorView");
        SEL sel = NSSelectorFromString(@"_shouldTreatImageAsTemplate:");
        class_addMethod(clazz, sel, (IMP)KN_shouldTreatImageAsTemplate, method_getTypeEncoding(class_getInstanceMethod(clazz, sel)));
        method_exchangeImplementations(class_getInstanceMethod(self, @selector(setCurrentPage:)),
                                       class_getInstanceMethod(self, @selector(KN_setCurrentPage:)));
        method_exchangeImplementations(class_getInstanceMethod(self, @selector(setNumberOfPages:)),
                                       class_getInstanceMethod(self, @selector(KN_setNumberOfPages:)));
    }
}

- (void)KN_setCurrentPage:(NSInteger)currentPage {
    [self KN_setCurrentPage:currentPage];
    [self KN_pageControlValueChange];
}

- (void)KN_setNumberOfPages:(NSInteger)numberOfPages {
    NSInteger currentPage = self.currentPage;
    [self KN_setNumberOfPages:numberOfPages];
    
    if (numberOfPages <= currentPage) {
        [self setIndicatorImage:self.KN_currentImage forPage:self.currentPage];
    }
    [self KN_refreshIndicatorTintColor];
}

- (void)setKN_currentImage:(UIImage *)KN_currentImage {
    objc_setAssociatedObject(self, @selector(KN_currentImage), KN_currentImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)KN_currentImage {
    return objc_getAssociatedObject(self, _cmd);
}

- (NSMutableDictionary<NSString *, UIImageView *> *)KN_indicatorImages {
    if (!objc_getAssociatedObject(self, _cmd)) {
        objc_setAssociatedObject(self, _cmd, [NSMutableDictionary dictionary], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, _cmd);
}

/** 设置page control图片 */
- (void)kn_SetCurrentImage:(UIImage *)currentImage pageImage:(UIImage *)pageImage {
    if (@available(iOS 14, *)) {
        self.KN_currentImage = currentImage;
        self.preferredIndicatorImage = pageImage;
        [self removeTarget:self
                    action:@selector(KN_pageControlValueChange)
          forControlEvents:UIControlEventValueChanged];
        [self addTarget:self
                 action:@selector(KN_pageControlValueChange)
       forControlEvents:UIControlEventValueChanged];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self KN_refreshIndicatorTintColor];
        });
    } else {
        [self setValue:currentImage forKeyPath:@"_currentPageImage"];
        [self setValue:pageImage forKeyPath:@"_pageImage"];
    }
}

- (void)KN_pageControlValueChange {
    for (NSInteger i = 0; i < self.numberOfPages; i++) {
        if (i == self.currentPage) {
            [self setIndicatorImage:self.KN_currentImage forPage:self.currentPage];
        } else {
            [self setIndicatorImage:self.preferredIndicatorImage forPage:i];
        }
    }
}

- (void)KN_refreshIndicatorTintColor {
    for (NSInteger i = 0; i < self.numberOfPages; i++) {
        [self.KN_indicatorImages[@(i).description] tintColorDidChange];
    }
}



@end
