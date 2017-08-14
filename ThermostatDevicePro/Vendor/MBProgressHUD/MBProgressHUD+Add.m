//
//  MBProgressHUD+Add.m
//  HotWindPro
//
//  Created by lyric on 2017/3/29.
//  Copyright © 2017年 lyice. All rights reserved.
//

#import "MBProgressHUD+Add.h"

@implementation MBProgressHUD (Add)

+(void)showTextTip:(NSString *)tip{
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [hud showAnimated:YES];
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = tip;
    hud.label.textColor = [UIColor whiteColor];
    hud.label.font = [UIFont systemFontOfSize:14];
    hud.label.numberOfLines = 0;
    
    hud.bezelView.backgroundColor= [UIColor blackColor];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor clearColor];
    
    [hud hideAnimated:YES afterDelay:2.f];
    
}


@end
