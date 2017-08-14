//
//  ZQPickerView.m
//  ThermostatDevicePro
//
//  Created by 聂自强 on 2017/6/8.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import "ZQPickerView.h"

@interface ZQPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    
    UIPickerView *picker;
}


@end


@implementation ZQPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self performSelector:@selector(initPickerView)];
    }
    return self;
}

-(void)initPickerView{
    
    _textColor = [UIColor grayColor];
    NSMutableArray *muArray = [NSMutableArray array];
    float idx = 5;
    while (idx <= 35) {
        
        [muArray addObject:@(idx)];
        idx += 0.5;
    }
    self.dataArray = [muArray copy];
    
    CGAffineTransform rotate = CGAffineTransformMakeRotation(-M_PI/2);
    rotate = CGAffineTransformScale(rotate, 0.1, 1);
    
    picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.height*10, self.frame.size.width)];
    [picker setTag: 666];
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = NO;
    [picker setBackgroundColor:[UIColor clearColor]];
    [self addSubview:picker];
    
    [picker setTransform:rotate];
    picker.frame = CGRectMake(0, 0, picker.frame.size.width, picker.frame.size.height);

    //选择线
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(picker.frame.size.width/2, HEIGHT_FIT(36), 1, HEIGHT_FIT(33))];
    [line1 setBackgroundColor:[UIColor colorWithHexString:@"28aae5"]];
    [self addSubview:line1];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(picker.frame.size.width/2, picker.frame.size.height - HEIGHT_FIT(36) - HEIGHT_FIT(33), 1, HEIGHT_FIT(33))];
    [line2 setBackgroundColor:[UIColor colorWithHexString:@"28aae5"]];
    [self addSubview:line2];
    
    //显示中间的选择线
    for(UIView *single in picker.subviews){
        if (single.frame.size.height < 1){
            [single removeFromSuperview];
        }
    }
    
    
}

#pragma mark -- UIPickerViewDelegate,UIPickerViewDataSource

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_dataArray count];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    CGAffineTransform rotateItem = CGAffineTransformMakeRotation(M_PI/2);
    rotateItem = CGAffineTransformScale(rotateItem, 1, 10);
    UILabel *labelItem = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 240)];
    labelItem.text = [NSString stringWithFormat:@"%.1f℃",[_dataArray[row] floatValue]] ;
    [labelItem setFont:[UIFont boldSystemFontOfSize:HEIGHT_FIT(84)]];
    labelItem.textAlignment = NSTextAlignmentCenter;
    labelItem.textColor = _textColor;
    labelItem.transform = rotateItem;
    
    //显示中间的选择线
    for(UIView *single in pickerView.subviews){
        if (single.frame.size.height < 1){
            [single removeFromSuperview];
        }
    }
    return labelItem;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component __TVOS_PROHIBITED
{
    return self.frame.size.height;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return SCREEN_WIDTH  / 4;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED
{
    NSNumber *number = _dataArray[row];

    if ([self.delegate respondsToSelector:@selector(didSelectValue:)]) {
        [self.delegate didSelectValue:[number floatValue]];
    }
    
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [picker reloadAllComponents];
    
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    [picker reloadAllComponents];
}

- (void)setScrollItem:(float)scrollItem
{
    _scrollItem = scrollItem;
    [_dataArray enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        float num = [obj floatValue];
        if (num == scrollItem) {
            [picker selectRow:idx inComponent:0 animated:NO];
            *stop = YES;
        }
        
    }];

}




@end
