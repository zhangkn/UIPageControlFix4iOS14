//
//  KNchangeRootVCTool.m
//  iUIPageControlFix4iOS14
//
//  Created by mac on 2020/9/25.
#import "ViewController.h"


#import "KNchangeRootVCTool.h"


@implementation KNchangeRootVCTool


+ (void) rootViewController4nil{
    
    
    
    //销毁 root
    UIWindow *oldWindow=[UIApplication sharedApplication].keyWindow;
    
    
    oldWindow.rootViewController=nil;
    
    
    
    
    //新 root
    UIWindow *newWindow = [UIApplication sharedApplication].keyWindow;
    
    
    
    
    ViewController *VC = [[ViewController alloc]init];
    
    
    
    UINavigationController *NA = [[UINavigationController alloc]initWithRootViewController:VC];
    
    
    [self.class restoreRootViewController:NA newWindow:newWindow];
    
    

}

/**
 UIModalTransitionStyleCoverVertical = 0, //从下到上盖上进入
 
 UIModalTransitionStyleFlipHorizontal, //水平翻转
 
 UIModalTransitionStyleCrossDissolve, //渐变出现
 
 #if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_2
 
 UIModalTransitionStylePartialCurl, //类似翻页的卷曲
 


 @param rootViewController <#rootViewController description#>
 @param newWindow <#newWindow description#>
 https://github.com/codeRiding/CRProject/blob/165886b8426fa43b52e76e659b8e18496e2fa8c8/CRProject/Classes/Expand/Tool/CRChangeVC.m
 */
+ (void)restoreRootViewController:(UIViewController *)rootViewController newWindow:(UIWindow*)newWindow

{
    
    typedef void (^Animation)(void);
    UIWindow* window =  newWindow;
//
    rootViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;


    Animation animation = ^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
//                        [newWindow switchWithRootViewController:rootViewController];
        newWindow.rootViewController = rootViewController;
        
        

        [UIView setAnimationsEnabled:oldState];
    };
    //
    
    
    [UIView transitionWithView:window
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:animation
                    completion:nil];

}

@end
