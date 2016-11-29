/*****************************************************************
 文件名称：NSObject+Extension.h
 作   者：陈阳阳
 备   注：分类大全
 创建时间：2015-12-10
 版权声明：Copyright (c) 2015 陈阳阳. All rights reserved.
 *****************************************************************/

#import "NSObject+Extension.h"

@implementation UIColor (Extension)

+ (UIColor *)ColorWithHexString:(NSString *)hex
{
    hex= [[hex uppercaseString] substringFromIndex:1];
    CGFloat valueArray[3];
    NSArray *strArray=[NSArray arrayWithObjects:[hex substringWithRange:NSMakeRange(0, 2)],[hex substringWithRange:NSMakeRange(2, 2)],[hex substringWithRange:NSMakeRange(4, 2)] ,nil];
    for( int i=0;i<strArray.count;i++){
        hex=strArray[i];
        CGFloat value=([hex characterAtIndex:0]>'9'?[hex characterAtIndex:0]-'A'+10:[hex characterAtIndex:0]-'0')*16.0f+([hex characterAtIndex:1]>'9'?[hex characterAtIndex:1]-'A'+10:[hex characterAtIndex:1]-'0');
        valueArray[i]=value;
    }
    return [UIColor colorWithRed:valueArray[0]/255 green:valueArray[1]/255 blue:valueArray[2]/255 alpha:1];
}

+ (UIColor *) R:(CGFloat)r G:(CGFloat)g B:(CGFloat)b
{
    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f];
}

@end

@implementation NSString (Extension)

+ (NSString *)changeToDateStr:(NSString *)dateStr
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateStr.doubleValue / 1000.0];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    return [dateFormat stringFromDate:date];
}

@end

@implementation UIView (Extension)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setMaxX:(CGFloat)maxX
{
    self.x = maxX - self.width;
}

- (CGFloat)maxX
{
    return CGRectGetMaxX(self.frame);
}

- (void)setMaxY:(CGFloat)maxY
{
    self.y = maxY - self.height;
}

- (CGFloat)maxY
{
    return CGRectGetMaxY(self.frame);
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

@end

@implementation NSDictionary (Extension)

+ (NSDictionary *)nullDic:(NSDictionary *)myDic
{
    NSArray *keyArr = [myDic allKeys];
    NSMutableDictionary *resDic = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < keyArr.count; i ++)
    {
        id obj = [myDic objectForKey:keyArr[i]];
        obj = [self changeType:obj];
        [resDic setObject:obj forKey:keyArr[i]];
    }
    return resDic;
}

+ (NSArray *)nullArr:(NSArray *)myArr
{
    NSMutableArray *resArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < myArr.count; i ++)
    {
        id obj = myArr[i];
        obj = [self changeType:obj];
        [resArr addObject:obj];
    }
    return resArr;
}

+ (NSString *)stringToString:(NSString *)string
{
    return string;
}

+ (NSString *)nullToString
{
    return @"";
}

+ (id)changeType:(id)myObj
{
    if ([myObj isKindOfClass:[NSDictionary class]])
    {
        return [self nullDic:myObj];
    }
    else if([myObj isKindOfClass:[NSArray class]])
    {
        return [self nullArr:myObj];
    }
    else if([myObj isKindOfClass:[NSString class]])
    {
        return [self stringToString:myObj];
    }
    else if([myObj isKindOfClass:[NSNull class]])
    {
        return [self nullToString];
    }
    else
    {
        return myObj;
    }
}

@end

@implementation UILabel (Extension)

+ (UILabel *)initWithText:(NSString *)text textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment font:(UIFont *)font frame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = text;
    label.font = font;
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    return label;
}

@end

@implementation UIButton (Extension)

+ (UIButton *)buttonWithTitle:(NSString *)title addTarget:(id)target action:(SEL)action norImage:(NSString *)norImage selImage:(NSString *)selImage frame:(CGRect)frame
{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:norImage] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selImage] forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    return button;
}

@end

@implementation NSObject (Extension)

@end
