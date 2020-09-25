#import <ReactiveObjC/ReactiveObjC.h>
#define kPingFangHeavyFont(fontSize) [UIFont fontWithName:@"PingFang-SC-Heavy" size:(kAdjustRatio(fontSize))]

#define kPingFangNOkAdjustRatioFont(fontSize) [UIFont fontWithName:@"PingFang-SC-Medium" size:((fontSize))]



#define kBoldFont(fontSize) [UIFont fontWithName:@"Helvetica-Bold" size:(kAdjustRatio(fontSize))]


//  iUIPageControlFix4iOS14
#define HWColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define rgb(r,g,b) HWColor(r,g,b)

#define SCREENH [[UIScreen mainScreen] bounds].size.height
#define SCREENW [[UIScreen mainScreen] bounds].size.width

#define kAdjustRatio(num) (ceil((SCREENW/375.0)*(num)))


#import "KNLanguageManager.h"

#import "KNchangeRootVCTool.h"
#import <Masonry/Masonry.h>


#import "ViewController.h"
#import "UIPageControl+Fix4iOS14.h"

@interface ViewController ()
/**
 中英文lab,用于切换语言：处理切换中英文语言的动作事件

 */
@property (weak, nonatomic) UILabel *languageLab;

/**
 用于测试指定参数顺序： 在%和@中间加上1$,2$等等就可以啦，数字代表参数的顺序。


 */
@property (weak, nonatomic) UILabel *FORMATLab;


@end

@implementation ViewController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    [self languageLab];

    self.view.backgroundColor = UIColor.whiteColor;
    
    
    
    self.FORMATLab.text =   [NSString stringWithFormat:KNLocal(@"FORMAT", nil), @"csdn", @"https://kunnan.blog.csdn.net/article/details/103733872"];
    
    
    
    
    
    

    
    [self testUIPageControl];
}


- (void)testUIPageControl{
    
    
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




- (UILabel *)FORMATLab{
    if (!_FORMATLab) {
        UILabel *tmp = [[UILabel alloc]init];
        
        _FORMATLab = tmp;
        
        tmp.textColor = rgb(51,51,51);
        
        tmp.font = kBoldFont(15);
        
        tmp.numberOfLines = 0;
        
        
        tmp.textAlignment = NSTextAlignmentCenter;
        

        
        
        [self.view addSubview:tmp];
        
        __weak __typeof__(self) weakSelf = self;

        [tmp mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.equalTo(weakSelf.view).offset(kAdjustRatio(-80));
            

            make.centerX.equalTo(weakSelf.view).offset(-kAdjustRatio(0));
            
            make.left.equalTo(weakSelf.view).offset(-kAdjustRatio(10));
            make.right.equalTo(weakSelf.view).offset(-kAdjustRatio(10));

            
//            make.size.mas_equalTo(CGSizeMake(kAdjustRatio(100), kAdjustRatio(40)));
                        
            
            
        }];
        
        
        
    }
    return _FORMATLab;
}



- (UILabel *)languageLab{
    if (!_languageLab) {
        UILabel *tmp = [[UILabel alloc]init];
        
        
        
        _languageLab = tmp;
        
        _languageLab.textColor = rgb(51,51,51);
        
        _languageLab.font = kBoldFont(15);
        
        
        
        _languageLab.textAlignment = NSTextAlignmentRight;
        
        

        
        //设置选中的语言
        if ([KNLanguageManager defaultManager].currentLanguage==KNLanguageTypeSystem) {
            
            
            
            
        }
       else if ([KNLanguageManager defaultManager].currentLanguage==KNLanguageTypeChineseSimple) {
           
           _languageLab.text = @"English";


        }
       else  if ([KNLanguageManager defaultManager].currentLanguage==KNLanguageTypeEnglish) {
           
           
           
//
           
           _languageLab.text = @"简体中文";

       }else{
           

           
       }
        
        
        
        _languageLab.userInteractionEnabled = YES;
        
        
        
        
        
        
        [self.view addSubview:_languageLab];
        
        __weak __typeof__(self) weakSelf = self;

        [_languageLab mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(weakSelf.view).offset(kAdjustRatio(20));
            

            make.right.equalTo(weakSelf.view).offset(-kAdjustRatio(16));
            
            
            make.size.mas_equalTo(CGSizeMake(kAdjustRatio(100), kAdjustRatio(40)));
                        
            
            
        }];
        
        
        
        UITapGestureRecognizer *cutTap = [[UITapGestureRecognizer alloc] init];
        
        [[cutTap rac_gestureSignal] subscribeNext:^(id x) {
            
            

            switch ([KNLanguageManager defaultManager].currentLanguage) {
                case KNLanguageTypeSystem:
                    {
                        
                    }
                    break;
                    
                case KNLanguageTypeEnglish:
                {
                    
                    [[KNLanguageManager defaultManager] changeLanguageType: KNLanguageTypeChineseSimple];

                    weakSelf.languageLab.text = @"简体中文";

                }
                    break;
                    
                case KNLanguageTypeChineseSimple:
                {
                    [[KNLanguageManager defaultManager] changeLanguageType: KNLanguageTypeEnglish];

                    weakSelf.languageLab.text = @"English";

                }
                    break;
                    

                    
                default:
                {
                    
                }
                    break;
            }
            
            // 刷新界面
            [ KNchangeRootVCTool rootViewController4nil];
            
            
            
            
            
        }];
        [_languageLab addGestureRecognizer:cutTap];

        
    }
    return _languageLab;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;

    
}


@end
