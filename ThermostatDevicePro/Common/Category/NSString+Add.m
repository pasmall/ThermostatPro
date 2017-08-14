//
//  NSString+Add.m
//  HotWindPro
//
//  Created by lyric on 2017/3/29.
//  Copyright © 2017年 lyice. All rights reserved.
//

#import "NSString+Add.h"

@implementation NSString (Add)

- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return result;
}

- (CGFloat)widthForFont:(UIFont *)font {
    CGSize size = [self sizeForFont:font size:CGSizeMake(HUGE, HUGE) mode:NSLineBreakByWordWrapping];
    return size.width;
}

- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width {
    CGSize size = [self sizeForFont:font size:CGSizeMake(width, HUGE) mode:NSLineBreakByWordWrapping];
    return size.height;
}

+ (NSString *)getStringWithSerialID:(long long )seriaID
{
    NSString *seriaIDString = [NSString stringWithFormat:@"%lld",seriaID];
    
    NSMutableString *string = [NSMutableString stringWithString:seriaIDString];
    NSMutableString *newstring = [NSMutableString string];
    NSInteger count = string.length;
    while(count > 4) {
        count -= 4;
        NSRange rang = NSMakeRange(string.length - 4, 4);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"  " atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    
    return newstring;
}

//格式化秒
+ (NSString *)getTimeStringWithTime:(NSInteger)time
{

    NSString *tmphh = [NSString stringWithFormat:@"%ld",time/3600];
    if ([tmphh length] == 1)
    {
        tmphh = [NSString stringWithFormat:@"0%@",tmphh];
    }
    NSString *tmpmm = [NSString stringWithFormat:@"%ld",(time/60)%60];
    if ([tmpmm length] == 1)
    {
        tmpmm = [NSString stringWithFormat:@"0%@",tmpmm];
    }
    NSString *tmpss = [NSString stringWithFormat:@"%ld",time%60];
    if ([tmpss length] == 1)
    {
        tmpss = [NSString stringWithFormat:@"0%@",tmpss];
    }
    return [NSString stringWithFormat:@"%@:%@:%@",tmphh,tmpmm,tmpss];

}

//格式化分
+ (NSString *)getTimeStringWithTimeSecond:(NSInteger)time
{
    NSString *tmphh = [NSString stringWithFormat:@"%ld",time/3600];
    if ([tmphh length] == 1)
    {
        tmphh = [NSString stringWithFormat:@"0%@",tmphh];
    }
    NSString *tmpmm = [NSString stringWithFormat:@"%ld",(time/60)%60];
    if ([tmpmm length] == 1)
    {
        tmpmm = [NSString stringWithFormat:@"0%@",tmpmm];
    }
    return [NSString stringWithFormat:@"%@:%@",tmphh,tmpmm];

}

//字符串转秒
+ (NSInteger)getTimeIntWithTimeString:(NSString *)timeString
{
    NSArray *array = [timeString componentsSeparatedByString:@":"];
    NSInteger time = 0;
    time = [array[0] integerValue] * 3600;
    time = time + [array[1] integerValue] * 60;
    return time;
}

//十进制数字得到二进制字符串
+ (NSString *)decimalTOBinary:(uint16_t)tmpid
{
    NSString *a = @"";
    while (tmpid)
    {
        a = [[NSString stringWithFormat:@"%d",tmpid%2] stringByAppendingString:a];
        if (tmpid/2 < 1)
        {
            break;
        }
        tmpid = tmpid/2 ;
    }
    
    if (a.length <= 8)
    {
        NSMutableString *b = [[NSMutableString alloc]init];;
        for (int i = 0; i < 8 - a.length; i++)
        {
            [b appendString:@"0"];
        }
        
        a = [b stringByAppendingString:a];
    }
    
    return a;

}

@end
