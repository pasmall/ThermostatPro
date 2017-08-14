//
//  BaseTabarViewController.m
//  HotWindPro
//
//  Created by 聂自强 on 2017/3/23.
//  Copyright © 2017年 lyice. All rights reserved.
//

#import "BaseTabarViewController.h"

@interface BaseTabarViewController ()

@end

@implementation BaseTabarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.shadowOpacity = 0.4;
    self.view.layer.shadowOffset = CGSizeMake(-4, 0);
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowRadius = 4;

}


@end
