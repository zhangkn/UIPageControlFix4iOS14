//
//  KNLanguageManager.m
//  iUIPageControlFix4iOS14
//
//  Created by mac on 2020/9/25.
//

#import "KNLanguageManager.h"

static NSString * const kSystem      = @"SystemDefault";

static NSString * const kCH          = @"zh-Hans";
static NSString * const kEN          = @"en";


static NSString * const kProj        = @"lproj";
static NSString * const kLanguageSet = @"kLanguageSet";

@interface KNLanguageManager()

@property (nonatomic, strong) NSBundle *bundle;
@property (nonatomic, strong) NSString *languageString;

@end


@implementation KNLanguageManager

+ (instancetype)defaultManager
{
    static dispatch_once_t onceToken;
    static KNLanguageManager *manager;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[KNLanguageManager alloc] init];
        }
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    //取字段看是哪种语言
    NSString *tempStr = [[NSUserDefaults standardUserDefaults] objectForKey:kLanguageSet];
    //    NSString *path;
    
    //假如用户没有设置过语言
    if (!tempStr) {
        tempStr=kSystem;
    }
    
    self.languageString = tempStr;
    
    
    if ([self.languageString isEqualToString:kCH]) {//为中文
        
        self.languageType = KNLanguageTypeChineseSimple;
        
    }else if ([self.languageString isEqualToString:kEN]) {//为英文
        
        self.languageType = KNLanguageTypeEnglish;
        
    }else if([self.languageString isEqualToString:kSystem]){//为系统默认
        
        self.languageType= KNLanguageTypeSystem;
        
        if([self isENLanguage]){//
            self.languageType = KNLanguageTypeEnglish;

        }else{
            self.languageType = KNLanguageTypeChineseSimple;

        }
        
        
    }
    
    //bundle 设置
    [self resetBundle];

    
    NSLog(@"当前的语言    HZLanguageTypeSystem HZLanguageTypeEnglish HZLanguageTypeChineseSimple：%lu",(unsigned long)self.languageType);
    
    return self;
}



- (void)changeLanguageType:(KNLanguageType)type;

{
    if (self.currentLanguageType == type) {
        return;
    }
    
    _languageType = type;
    switch (type) {
            
        case KNLanguageTypeSystem:
            
            self.languageString=kSystem;
            break;
        case KNLanguageTypeEnglish:
            
            self.languageString = kEN;
            break;
        case KNLanguageTypeChineseSimple:
            
            self.languageString = kCH;
            break;

    }
    
    //bundle 设置
    [self resetBundle];
    
    //设置语言，并作记录保存
    [[NSUserDefaults standardUserDefaults] setObject:_languageString forKey:kLanguageSet];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //使用通知更改文字    [[NSNotificationCenter defaultCenter] postNotificationName:kNoticeLanguageChange object:nil];
}

- (void)resetBundle{
    if ([_languageString isEqualToString:kEN] || [_languageString isEqualToString:kCH]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:_languageString ofType:kProj];
        self.bundle = [NSBundle bundleWithPath:path];
    }
}
//if (_bundle)
//{// 修改成为，从另外一个文件找，先从文件找，如果找不到就从文件二找。
- (NSString*)NSLocalizedStringFromTableInBundleWithKey:(NSString *)key table:(NSString *)table{
    NSString* tmp = key;
    if(_bundle){
        
        tmp =NSLocalizedStringFromTableInBundle(key, table, _bundle, nil);

        if([tmp isEqualToString:key]){
            // 继续从备份表查找
            
            NSLog(@"开始从Localizable1 找key:%@", tmp);
            tmp =NSLocalizedStringFromTableInBundle(key, @"Localizable1", _bundle, nil);
//            NSLog([NSString stringWithFormat:@"结束从Localizable1 找key:%@",tmp]);
            NSLog(@"结束从Localizable1 找key:%@", tmp);


        }
    }
    return tmp;

    
    
    
}

- (NSString *)stringWithKey:(NSString *)key table:(NSString *)table
{
    //假如为跟随系统
    if (self.languageType==KNLanguageTypeSystem) {
        return  NSLocalizedString(key, nil);
    }
    
    //返回对应国际化文字
    if (_bundle) {// 修改成为，从另外一个文件找，先从文件找，如果找不到就从文件二找。
        //NSLocalizedStringFromTableInBundleWithKey
        return [self NSLocalizedStringFromTableInBundleWithKey:key table:table];
        return  NSLocalizedStringFromTableInBundle(key, table, _bundle, nil);
        
        
        
    }
    return NSLocalizedStringFromTable(key, table, nil);
}

-(KNLanguageType)currentLanguage{
    //获取当前语言
    //  NSString *tempStr = [[NSUserDefaults standardUserDefaults] objectForKey:kLanguageSet];
    //    if ([tempStr rangeOfString:@"zh"].length) {
    ////        tempStr = kCH;
    //        return HZLanguageTypeChineseSimple;
    //    }else if([tempStr isEqualToString:kEN]){
    ////        tempStr = kEN;
    //        return HZLanguageTypeEnglish;
    //    }else {//if([tempStr isEqualToString:kSystem])
    //
    //        return HZLanguageTypeSystem;
    //    }
    return    self.languageType;
}


+ (NSArray *)english {
    return @[@"en", @"en-CN"];
}

+ (NSArray *)chineseHans {
    return @[@"zh-Hans", @"zh-Hans-CN"];
}

+ (NSArray *)chineseHant {
    return @[@"zh-Hant", @"zh-Hant-CN"];
}




/**
 (lldb) po [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"]
 <__NSCFArray 0x2833357a0>(
 zh-Hans-AM,
 en-AM,
 en-GB,
 ru-AM,
 zh-Hant-AM,
 zh-Hant-HK
 )
 
第一个就是用户设置的语言

 @return
 */
- (BOOL )isENLanguage {
//    NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:GHLLanguageKey];
    
//    if (){
//    if ([HZLanguageManager defaultManager].currentLanguage==HZLanguageTypeEnglish) {

    if (self.currentLanguage == KNLanguageTypeEnglish) {

    return YES;
    }
    
    
    
//    if () {
        NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
        NSString *language =  languages.firstObject;
        
//    }
    
//    if([[HZLanguageManager chineseHans] containsObject:language] || [[HZLanguageManager chineseHant] containsObject:language] ){
        if([language containsString:@"zh-Hans"] || [language containsString:@"zh-Hant"] ){

        
        return NO;
        }else{
            return YES;

        }
    
}


// 设置当前语言
//+ (void)setUserlanguage:(NSString *)language {
//    if ([[GHLLocalizable userLanguage] isEqualToString:language]) return;
//    [[NSUserDefaults standardUserDefaults] setObject:language forKey:GHLLanguageKey];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    [NSBundle setLanguage:language];
//    [[NSNotificationCenter defaultCenter] postNotificationName:GHLNotificationLanguageChanged object:currentLanguage];
//}
//
//// 获取应用当前语言
//+ (NSString *)userLanguage {
//    NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:GHLLanguageKey];
//    if (language.length <= 0) {
//        NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
//        return languages.firstObject;
//    }
//    return language;
//}
//


+ (BOOL )isEN{
    
    if([KNLanguageManager defaultManager].currentLanguage == KNLanguageTypeEnglish ){
        //                make.width.mas_equalTo(kAdjustRatio(73 * 3));
        return YES;
        
    }else{
        //                make.width.mas_equalTo(kAdjustRatio(50 * 3));
//        make.left.equalTo(weakSelf.contentView).offset(kAdjustRatio(20));
//        make.right.equalTo(weakSelf.contentView).offset(- kAdjustRatio(20));
//
        return NO;

    }

}


@end
