//
//  ZQLeftSlipManager.m
//  HotWindPro
//
//  Created by 聂自强 on 2017/3/23.
//  Copyright © 2017年 lyice. All rights reserved.
//

#import "ZQLeftSlipManager.h"

#define LEFT_VIEW_WIDTH [UIScreen mainScreen].bounds.size.width * 0.7
// 单例对象
static ZQLeftSlipManager *_leftSlipManager = nil;
// 手势轻扫临界速度
CGFloat const DYLeftSlipCriticalVelocity = 800;
// 左滑手势触发距离
CGFloat const DYLeftSlipLeftSlipPanTriggerWidth = 100;


@interface ZQLeftSlipManager ()<UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>
// 用来左滑手势开始判断
@property (nonatomic, assign) CGFloat touchBeganX;
//点击返回的遮罩view
@property (nonatomic, strong) UIView *tapView;
//是否在交互中 /
@property (nonatomic, assign) BOOL interactive;
// present or dismiss /
@property (nonatomic, assign) BOOL present;
// 左滑视图宽度
@property (nonatomic, assign) CGFloat leftViewWidth;

@property (nonatomic, strong) UIViewController *leftVC;
@property (nonatomic, weak) UIViewController *coverVC;

@end


@implementation ZQLeftSlipManager

#pragma mark - 单例方法
+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _leftSlipManager = [[self alloc] init];
        _leftSlipManager.leftViewWidth = WIDTH_FIT(759);
    });
    return _leftSlipManager;
}


#pragma mark - 初始化方法

- (instancetype)init
{
    if (self = [super init]) {
        self.completionCurve = UIViewAnimationCurveLinear;
    }
    return self;
}

#pragma mark - 逻辑处理方法

// 设置左边视图与覆盖视图
- (void)setLeftViewController:(UIViewController *)leftViewController coverViewController:(UIViewController *)coverViewController
{
    self.leftVC = leftViewController;
    self.coverVC = coverViewController;
    
    [self.coverVC.view addSubview:self.tapView];
    
    // 转场代理
    self.leftVC.transitioningDelegate = self;
    // 侧滑手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.coverVC.view addGestureRecognizer:pan];
}

//present左侧控制器
- (void)showLeftView
{
    [self.coverVC presentViewController:self.leftVC animated:YES completion:nil];
}

//dismiss掉左侧控制器
- (void)dismissLeftView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.leftVC dismissViewControllerAnimated:YES completion:nil];
    });
}


#pragma mark - 手势处理方法
- (void)pan:(UIPanGestureRecognizer *)pan
{
    CGFloat offsetX = [pan translationInView:pan.view].x;
    
    // X轴速度
    CGFloat velocityX = [pan velocityInView:pan.view].x;
    
    CGFloat percent;
    if (self.showLeft) {
        percent = MIN(-offsetX / self.leftViewWidth, 1);
    } else {
        percent = MIN(offsetX / self.leftViewWidth, 1);
    }
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (self.showLeft) {
                self.interactive = YES;
                
                [self dismissLeftView];
            } else {
                _touchBeganX = [pan locationInView:pan.view].x;
                
                if (_touchBeganX < DYLeftSlipLeftSlipPanTriggerWidth) {
                    self.interactive = YES;
                    
                    [self showLeftView];
                }
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self updateInteractiveTransition:percent];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            self.interactive = NO;
            
            // 判断是否需要转场
            BOOL shouldTransition = NO;

            if (!self.showLeft) {
                if (velocityX > 0) {
                    if (velocityX > DYLeftSlipCriticalVelocity) {
                        shouldTransition = YES;
                    } else {
                        shouldTransition = percent > 0.5;
                    }
                } else {
                    if (velocityX < -DYLeftSlipCriticalVelocity) {
                        shouldTransition = NO;
                    } else {
                        shouldTransition = percent > 0.5;
                    }
                }
            } else {
                if (velocityX < 0) {
                    if (velocityX < -DYLeftSlipCriticalVelocity) {
                        shouldTransition = YES;
                    } else {
                        shouldTransition = percent > 0.5;
                    }
                } else {
                    if (velocityX > DYLeftSlipCriticalVelocity) {
                        shouldTransition = NO;
                    } else {
                        shouldTransition = percent > 0.5;
                    }
                }
            }
            
            if (shouldTransition) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIViewControllerTransitioningDelegate代理方法
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.present = YES;
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.present = NO;
    return self;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return self.interactive ? self : nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return self.interactive ? self : nil;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return .3f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.present) {
        // 基础操作，获取两个VC并把视图加在容器上
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        
        UIView *containerView = [transitionContext containerView];
        toVC.view.frame = CGRectMake(0, 0, self.leftViewWidth, containerView.frame.size.height);
        [containerView addSubview:toVC.view];
        [containerView sendSubviewToBack:toVC.view];
        
        // 动画block
        void(^animateBlock)() = ^{
            fromVC.view.frame = CGRectMake(self.leftViewWidth, 0, fromVC.view.frame.size.width, fromVC.view.frame.size.height);
            self.tapView.alpha = 1.f;
        };
        
        // 动画完成block
        void(^completeBlock)() = ^{
            if ([transitionContext transitionWasCancelled]) {
                [transitionContext completeTransition:NO];
            } else {
                [transitionContext completeTransition:YES];
                [containerView addSubview:fromVC.view];
                
                // 加上点击dismiss的View
                //                [fromVC.view addSubview:self.tapView];
                self.showLeft = YES;
            }
        };
        
        // 手势和普通动画做区别
        if (self.interactive) {
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                animateBlock();
            } completion:^(BOOL finished) {
                completeBlock();
            }];
        } else {
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                animateBlock();
            } completion:^(BOOL finished) {
                completeBlock();
            }];
            
        }
    } else {
        
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        UIView *containerView = [transitionContext containerView];
        [containerView addSubview:toVC.view];
        
        // 动画block
        void(^animateBlock)() = ^{
            toVC.view.frame = CGRectMake(0, 0, toVC.view.frame.size.width, toVC.view.frame.size.height);
            self.tapView.alpha = 0.f;
        };
        
        // 动画完成block
        void(^completeBlock)() = ^{
            if ([transitionContext transitionWasCancelled]) {
                [transitionContext completeTransition:NO];
            } else {
                [transitionContext completeTransition:YES];
                self.showLeft = NO;
                
                // 去除点击dismiss的View
                //                [self.tapView removeFromSuperview];
            }
        };
        
        
        if (self.interactive) {

            [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                animateBlock();
            } completion:^(BOOL finished) {
                completeBlock();
            }];
        } else {
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                animateBlock();
            } completion:^(BOOL finished) {
                completeBlock();
            }];
        }
    }
}

#pragma mark - setter/getter方法
- (UIView *)tapView
{
    if (!_tapView) {
        _tapView = [[UIView alloc] initWithFrame:self.coverVC.view.bounds];
        _tapView.backgroundColor = [UIColor colorWithWhite:0 alpha:.0f];
        _tapView.alpha = 0.f;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissLeftView)];
        [_tapView addGestureRecognizer:tapGesture];
    }
    return _tapView;
}



@end
