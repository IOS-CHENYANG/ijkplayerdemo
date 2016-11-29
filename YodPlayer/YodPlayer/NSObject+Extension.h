/*****************************************************************
 文件名称：NSObject+Extension.h
 作   者：陈阳阳
 备   注：分类大全
 创建时间：2015-12-10
 版权声明：Copyright (c) 2015 陈阳阳. All rights reserved.
 *****************************************************************/

#import <UIKit/UIKit.h>

#pragma mark ***************************UIColor********************************

@interface UIColor (Extension)

// 使用十六进制色值 0xC8C8C8
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
// 十六进制字符串  @"#C8C8C8"
+ (UIColor *) ColorWithHexString:(NSString*)hexString;
// RGB  200.0f 200.0f 200.0f
+ (UIColor *) R:(CGFloat)r G:(CGFloat)g B:(CGFloat)b;

@end

#pragma mark ***************************NSString********************************

@interface NSString (Extension)

// 毫秒字符串转日期字符串 @"1449743795000" -> @"2015-12-10"
+ (NSString *)changeToDateStr:(NSString *)dateStr;

@end

#pragma mark ***************************UIView********************************

@interface UIView (Extension)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat maxX;
@property (nonatomic, assign) CGFloat maxY;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;

@end

#pragma mark ***************************NSDictionary********************************

@interface NSDictionary (Extension)

// 将所有的NSNull类型转化成@""
+(id)changeType:(id)myObj;

@end

#pragma mark ***************************UILabel********************************

@interface UILabel (Extension)

// 初始化一个标签
+ (UILabel *)initWithText:(NSString *)text textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment font:(UIFont *)font frame:(CGRect)frame;

@end

#pragma mark ***************************UIButton********************************

@interface UIButton (Extension)

// 初始化一个按钮
+ (UIButton *)buttonWithTitle:(NSString *)title addTarget:(id)target action:(SEL)action norImage:(NSString *)norImage selImage:(NSString *)selImage frame:(CGRect)frame;

@end

#pragma mark ***************************NSObject********************************

@interface NSObject (Extension)

@end
