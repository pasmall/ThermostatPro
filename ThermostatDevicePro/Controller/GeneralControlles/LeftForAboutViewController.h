//
//  LeftForAboutViewController.h
//  HotWindPro
//
//  Created by 聂自强 on 2017/3/23.
//  Copyright © 2017年 lyice. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, LeftViewActionType) {
    LeftViewActionTypeSetting,
    LeftViewActionTypeAbout,
};

@protocol LeftForAboutViewControllerDelegate <NSObject>

@optional
- (void)didSelectedToPushViewController:(LeftViewActionType )type;

@end

@interface LeftForAboutViewController : BaseViewController

@property(nonatomic ,weak)id<LeftForAboutViewControllerDelegate> delegate;

@end
