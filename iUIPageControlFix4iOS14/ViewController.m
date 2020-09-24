//
//  ViewController.m
//  iUIPageControlFix4iOS14
//
//  Created by mac on 2020/9/24.
#import <Masonry/Masonry.h>


#import "ViewController.h"
#import "UIPageControl+Fix4iOS14.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    UIPageControl *pc = [[UIPageControl alloc] initWithFrame:CGRectMake(10, 100, 375, 30)];
    
    [self.view addSubview:pc];
    
    [pc mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.offset(0);
        
        make.left.offset(10);
        make.right.offset(-10);

    }];

    
    pc.backgroundColor = UIColor.grayColor;
    
    [pc kn_SetCurrentImage:[UIImage imageNamed:@"csdn4CurrentImage"] pageImage:[UIImage systemImageNamed:@"cart"]];
    pc.numberOfPages = 5;
        

    
    pc.currentPage = 0;
//
}


@end
