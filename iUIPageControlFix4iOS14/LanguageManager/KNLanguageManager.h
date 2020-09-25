//
//  KNLanguageManager.h
//  iUIPageControlFix4iOS14
//
//  Created by mac on 2020/9/25.
//

#import <Foundation/Foundation.h>

#define KNLocalizedString(key, comment)               KNLocalizedStringFromTable(key, @"Localizable", nil)
#define KNLocalizedStringFromTable(key, tbl, comment) [[KNLanguageManager defaultManager] stringWithKey:key table:tbl]

static NSString * const kNoticeLanguageChange = @"kNoticeLanguageChange";

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, KNLanguageType) {
    KNLanguageTypeSystem,
    KNLanguageTypeEnglish,
    KNLanguageTypeChineseSimple,
};


@interface KNLanguageManager : NSObject

@property (nonatomic, assign, getter=currentLanguageType) KNLanguageType languageType;

+ (instancetype)defaultManager;

- (void)changeLanguageType:(KNLanguageType)type;

/**
 国际化：Localizable 最好拆开成两个文件
 @param key
 @param table Localizable
 @return
 */
- (NSString *)stringWithKey:(NSString *)key table:(NSString *)table;
- (KNLanguageType)currentLanguage;

+ (BOOL )isEN;



@end

NS_ASSUME_NONNULL_END
