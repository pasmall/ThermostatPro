//
//  SheetEditDeviceView.m
//  HotWindPro
//
//  Created by lyric on 2017/3/28.
//  Copyright © 2017年 lyice. All rights reserved.
//

#import "SheetEditDeviceView.h"
#import "EditDeviceCollectionViewCell.h"

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
static NSString *cellIdentifer = @"edit_cell";

@interface SheetEditDeviceView()<UICollectionViewDelegate , UICollectionViewDataSource>{
    NSArray *imageNames;
    NSArray *titleStrings;

}

@property (weak,nonatomic)UIView *backgroundView; //屏幕下方看不到的view
@property (weak,nonatomic)UILabel *titleLabel; //中间显示的标题lab
@property (weak,nonatomic)UICollectionView *editCollectionView;

@end


@implementation SheetEditDeviceView

+ (instancetype)initWithThermostatDevice:(ThermostatDeviceModel *)device andcall:(SheetEditDeviceViewBlock)callBack
{
    SheetEditDeviceView *editView = [[SheetEditDeviceView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    editView.callBack = callBack;
    editView.currentDevice = device;
    return editView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
        
    }
    return self;
}

//创建UI
- (void)setUI
{
    
    //首先创建一个位于屏幕下方看不到的view
    UIView* bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.45];
    bgView.alpha = 0.0f;
    UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDismiss)];
    [bgView addGestureRecognizer:g];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:bgView];
    self.backgroundView = bgView;
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEIGHT_FIT(114))];
    titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(45)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    titleLabel.textColor = COLOR_HEXSTRING(@"#808080");
    [titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), SCREEN_WIDTH, HEIGHT_FIT(2))];
    lineView.backgroundColor = COLOR_HEXSTRING(@"#d1d1d1");
    [self addSubview:lineView];
    
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
    flowlayout.minimumLineSpacing = 0;
    flowlayout.minimumInteritemSpacing = 0;
    flowlayout.itemSize = CGSizeMake(HEIGHT_FIT(261), HEIGHT_FIT(261));
    flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, lineView.y + HEIGHT_FIT(2), SCREEN_WIDTH, HEIGHT_FIT(261)) collectionViewLayout:flowlayout];
    [collectionView registerClass:[EditDeviceCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifer];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:collectionView];
    self.editCollectionView = collectionView;
    

    //self
    self.backgroundColor = [UIColor whiteColor];
    [self setFrame: CGRectMake(0, SCREEN_SIZE.height,SCREEN_SIZE.width , HEIGHT_FIT(375))];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
 
}

//设置当前操作的设备
- (void)setCurrentDevice:(ThermostatDeviceModel *)currentDevice
{
    _currentDevice = currentDevice;
    [_titleLabel setText:[NSString getStringWithSerialID:_currentDevice.deviceSerialID]];
    
    //设置titile
    if (_currentDevice.deviceNetState == DeviceNetStateTypeUnknow || _currentDevice.deviceNetState == DeviceNetStateTypeOff) {
        imageNames = @[@"删除"];
        titleStrings = @[LANGUE_STRING(@"删除")];
    }else{
        imageNames = @[@"修改昵称",@"修改密码",@"删除"];
        titleStrings = @[LANGUE_STRING(@"修改昵称"),LANGUE_STRING(@"修改密码"),LANGUE_STRING(@"删除")];
    }
    
    [self.editCollectionView reloadData];
}


#pragma mark Action
- (void)tapDismiss
{
    [self dismissEditDeviceView];
}

#pragma mark  UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return imageNames.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EditDeviceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
    [cell setTitile:titleStrings[indexPath.row] andImageName:imageNames[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_currentDevice.deviceNetState == DeviceNetStateTypeUnknow || _currentDevice.deviceNetState == DeviceNetStateTypeOff) {
        
        self.callBack(self ,TapViewEditTypeDelete);
        
    }else{
    switch (indexPath.row) {
        case TapViewEditTypeName:
            self.callBack(self ,TapViewEditTypeName);
            break;
        case TapViewEditTypePassword:
            self.callBack(self ,TapViewEditTypePassword);
            break;
        case TapViewEditTypeDelete:
            self.callBack(self ,TapViewEditTypeDelete);
            break;
        default:
            break;
    }
    }
}


#pragma mark show&dissmiss
//显示
- (void)showEditDeviceView
{
    
    [UIView animateWithDuration:0.8f delay:0 usingSpringWithDamping:0.9f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews animations:^{
        
        [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
        self.backgroundView.alpha = 1.0;
        
        self.frame = CGRectMake(0, SCREEN_SIZE.height-HEIGHT_FIT(375), SCREEN_SIZE.width, HEIGHT_FIT(357));
    } completion:NULL];
}

//移除
- (void)dismissEditDeviceView
{
    
    [UIView animateWithDuration:0.8f delay:0 usingSpringWithDamping:0.9f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews animations:^{
        self.backgroundView.alpha = 0.0;
        self.frame = CGRectMake(0, SCREEN_SIZE.height,SCREEN_SIZE.width , HEIGHT_FIT(357));
        
    } completion:^(BOOL finished) {
        [self.backgroundView removeFromSuperview];
        [self removeFromSuperview];
        
    }];
}


@end





