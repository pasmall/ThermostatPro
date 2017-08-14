//
//  BorderTextField.m
//  HotWindPro
//
//  Created by lyric on 2017/3/29.
//  Copyright © 2017年 lyice. All rights reserved.
//

#import "BorderTextField.h"

@implementation BorderTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.borderStyle = UITextBorderStyleRoundedRect;
        self.layer.borderWidth = HEIGHT_FIT(3);
        UIColor *borderColor = COLOR_HEXSTRING(@"#cccccc");
        self.layer.borderColor = borderColor.CGColor ;
        self.layer.cornerRadius = HEIGHT_FIT(15);
        self.layer.masksToBounds = YES;
    }
    
    return self;
}

-(NSRange)selectedRange
{
    UITextPosition *beginning = self.beginningOfDocument;
    
    UITextRange *selectedRange = self.selectedTextRange;
    UITextPosition *selectionStart = selectedRange.start;
    UITextPosition *selectionEnd = selectedRange.end;
    
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}

-(void)setSelectedRange:(NSRange)range
{
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition *endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange *selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    [self setSelectedTextRange:selectionRange];
}

@end
