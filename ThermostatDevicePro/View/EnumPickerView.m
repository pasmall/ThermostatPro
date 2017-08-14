//
//  EnumPickerView.m
//  ThermostatDevicePro
//
//  Created by lyric on 2017/6/13.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import "EnumPickerView.h"

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#define ROW_HEIGHT 50

@interface EnumPickerView()<UIPickerViewDelegate, UIPickerViewDataSource>{
    
    NSInteger _row0;
    NSInteger _row1;
}


@property (weak,nonatomic)UIView *backgroundView;    //屏幕下方看不到的view
@property (weak,nonatomic)UILabel *titleLabel;      //中间显示的标题lab
@property (weak,nonatomic) UIPickerView *pickerView;
@property (weak,nonatomic)UIButton *cancelButton;
@property (weak,nonatomic)UIButton *doneButton;
@property (strong,nonatomic)NSArray *dataArray;   // 用来记录传递过来的数组数据
@property (strong,nonatomic)NSString *headerTitle;  //传递过来的标题头字符串

@end


@implementation EnumPickerView

//选择器
+(instancetype)sheetStringPickerWithTitleStrings:(NSArray *)strings andHeaderTitle:(NSString *)headerTitle andSubObjectCom:(NSInteger)subValueCom andSubObjectRow:(NSInteger)subValueRow andPickerType:(PickerViewType)type  andcall:(EnumPickerViewBlock)callBack
{
    
    EnumPickerView *pickerView = [[EnumPickerView alloc]initWithFrame:[UIScreen mainScreen].bounds andTitleStrings:strings andHeaderTitle:headerTitle andSubObjectCom:subValueCom andSubObjectRow:subValueRow andType:type];
    pickerView.choiceBack = callBack;
    return pickerView;
    
}

- (instancetype)initWithFrame:(CGRect)frame andTitleStrings:(NSArray*)strings andHeaderTitle:(NSString *)headerTitle andSubObjectCom:(NSInteger)subValueCom andSubObjectRow:(NSInteger)subValueRow andType:(PickerViewType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataArray = strings;
        _headerTitle = headerTitle;
        _row0 = subValueCom;
        _row1 = subValueRow;
        _pickerType = type;
        [self setUI];
    }
    return self;
}

- (void)setUI
{
    //self
    self.backgroundColor = [UIColor whiteColor];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    [self setFrame: CGRectMake(0, SCREEN_SIZE.height,SCREEN_SIZE.width , HEIGHT_FIT(969))];
    
    //首先创建一个位于屏幕下方看不到的view
    UIView* bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.45];
    bgView.alpha = 0.0f;
    UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDismiss)];
    [bgView addGestureRecognizer:g];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:bgView];
    self.backgroundView = bgView;
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, HEIGHT_FIT(171))];
    titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(60)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:COLOR(133, 133, 133)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:_headerTitle];
    [titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    
    //选择器
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(titleLabel.frame) , SCREEN_SIZE.width,HEIGHT_FIT(969) - CGRectGetMaxY(titleLabel.frame) -  HEIGHT_FIT(171))];
    [pickerView setDelegate:self];
    [pickerView setDataSource:self];
    pickerView.showsSelectionIndicator = YES;
    [self addSubview:pickerView];
    self.pickerView = pickerView;
    
    //初始跳转TODO
    for (int i = 0; i < _dataArray.count; i ++) {
        if (i == 0) {
            [self.pickerView selectRow:_row0 inComponent:0 animated:NO];
        }else if (i == 1){
            [self.pickerView selectRow:_row1 inComponent:1 animated:NO];
        }
        
    }
    
    

    
    
    //取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, self.height - HEIGHT_FIT(171)  , SCREEN_SIZE.width*0.5, HEIGHT_FIT(171));
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:LANGUE_STRING(@"取消") attributes:
                                      @{ NSForegroundColorAttributeName: NAVIGATIONBAR_COLOR,
                                         NSFontAttributeName :           [UIFont systemFontOfSize:PX_TO_PT(51)],
                                         NSUnderlineStyleAttributeName : @(NSUnderlineStyleNone) }];
    [cancelButton setAttributedTitle:attrString forState:UIControlStateNormal];
    cancelButton.adjustsImageWhenHighlighted = NO;
    cancelButton.backgroundColor = [UIColor clearColor];
    cancelButton.layer.borderWidth = 0.5;
    cancelButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [cancelButton addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    self.cancelButton = cancelButton;
    
    //完成按钮
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(SCREEN_SIZE.width*0.5,self.height - HEIGHT_FIT(171) , SCREEN_SIZE.width*0.5, HEIGHT_FIT(171));
    NSAttributedString *attrString2 = [[NSAttributedString alloc] initWithString:LANGUE_STRING(@"确定") attributes:
                                       @{ NSForegroundColorAttributeName: NAVIGATIONBAR_COLOR,
                                          NSFontAttributeName :           [UIFont systemFontOfSize:PX_TO_PT(51)],
                                          NSUnderlineStyleAttributeName : @(NSUnderlineStyleNone) }];
    [doneButton setAttributedTitle:attrString2 forState:UIControlStateNormal];
    doneButton.adjustsImageWhenHighlighted = NO;
    doneButton.backgroundColor = [UIColor clearColor];
    doneButton.layer.borderWidth = 0.5;
    doneButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [doneButton addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:doneButton];
    self.doneButton = doneButton;
}


#pragma mark Action
- (void)tapDismiss
{
    [self dismissPicker];
}

- (void)clicked:(UIButton *)sender
{
    if ([sender isEqual:self.cancelButton]) {
        [self dismissPicker];
    }else{
        if (self.choiceBack) {
            self.choiceBack(_row0,_row1);
            [self dismissPicker];
            
        }
    }
}

#pragma mark  UIPickerViewDataSource & UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return self.dataArray.count;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *subArray = self.dataArray[component];
    return subArray.count;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    if (_pickerType == PickerViewTypeHaveImage) {
        return ROW_HEIGHT;
    }else{
        return PX_TO_PT(105);
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        _row0 = row;
    }else{
        _row1 = row;
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component __TVOS_PROHIBITED
{
    if (_dataArray.count == 1) {
        return self.width;
    }else{
        return self.width/5;
    }
}

- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UIView *cellView = [[UIView alloc]init];
    NSArray *subArray = self.dataArray[component];
    if (_pickerType == PickerViewTypeHaveImage) {
        cellView.frame = CGRectMake(0, 0, SCREEN_SIZE.width, ROW_HEIGHT);
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_SIZE.width * 0.5 -(ROW_HEIGHT - 20) * 2.4 , 10, (ROW_HEIGHT - 20) * 1.2, ROW_HEIGHT - 20 )];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:subArray[row]];
        [cellView addSubview:imageView];
        
        
        UILabel *titleLable  = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + WIDTH_FIT(18), 10, SCREEN_SIZE.width * 0.4, ROW_HEIGHT - 20)];
        titleLable.textColor = [UIColor blackColor];
        titleLable.textAlignment = NSTextAlignmentLeft;
        titleLable.text = subArray[row];
        [cellView addSubview:titleLable];
        
    }else{
        cellView.frame = CGRectMake(0, 0, SCREEN_SIZE.width, PX_TO_PT(105));
        UILabel *titleLable  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width , PX_TO_PT(105))];
        titleLable.textColor = [UIColor blackColor];
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.text = subArray[row];
        [cellView addSubview:titleLable];
        
    }
    //显示中间的选择线
    for(UIView *single in pickerView.subviews){
        if (single.frame.size.height < 1){
            single.backgroundColor = [UIColor lightGrayColor];
        }
    }
    return cellView;
}

- (void)showPicker
{
    
    [UIView animateWithDuration:0.8f delay:0 usingSpringWithDamping:0.9f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews animations:^{
        
        [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
        self.backgroundView.alpha = 1.0;
        
        self.frame = CGRectMake(0, SCREEN_SIZE.height-HEIGHT_FIT(969), SCREEN_SIZE.width, HEIGHT_FIT(969));
    } completion:NULL];
}

- (void)dismissPicker
{
    
    [UIView animateWithDuration:0.8f delay:0 usingSpringWithDamping:0.9f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews animations:^{
        self.backgroundView.alpha = 0.0;
        self.frame = CGRectMake(0, SCREEN_SIZE.height,SCREEN_SIZE.width , HEIGHT_FIT(969));
        
    } completion:^(BOOL finished) {
        [self.backgroundView removeFromSuperview];
        [self removeFromSuperview];
        
    }];
}

@end
