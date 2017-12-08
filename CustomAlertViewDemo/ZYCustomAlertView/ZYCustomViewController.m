//
//  ZYCustomViewController.m
//
//  Created by zhaoying on 2017/12/5.
//  Copyright © 2017年 zhaoying. All rights reserved.
//
#define WEAKSELF __weak typeof(self) weakSelf = self;
#define STRONGSELF __strong typeof(weakSelf) strongSelf = weakSelf;
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define MAIN_COLOR  [UIColor colorWithRed:213.0f / 255.0f green:184.0f / 255.0f blue:119.0f / 255.0f alpha:1.0f]
#define CANCEL_COLOR   [UIColor lightGrayColor]

#define TITLE_TEXT_COLOR   [UIColor blackColor]
#define CONTENT_TEXT_COLOR   [UIColor blackColor]
#define TITLE_TEXT_FONT  [UIFont systemFontOfSize:16]
#define CONTENT_TEXT_FONT  [UIFont systemFontOfSize:14]

#import "ZYCustomViewController.h"
#import <Masonry/Masonry.h>

@implementation ZYPopupPresentAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.4;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    [self bounceAnimationWithContext:transitionContext];
}

- (void)bounceAnimationWithContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    ZYCustomViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.alertView.alpha = 0;
    toVC.alertView.transform = CGAffineTransformMakeScale(0, 0);
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         toVC.alertView.alpha = 1;
                         toVC.alertView.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
}

@end

@implementation ZYPopupDismissAnimator
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.15;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    [self fadeOutAnimationWithContext:transitionContext];
}

- (void)fadeOutAnimationWithContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration
                     animations:^{
                         fromVC.view.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
}

@end

const static CGFloat kCustomAlertViewDefaultButtonHeight       = 44;
const static CGFloat kCustomAlertViewDefaultButtonSpacerHeight = 1;
const static CGFloat kCustomAlertViewCornerRadius              = 5;

/** 间隙 */
const static CGFloat padding = 15.0;
/** 弹窗总宽度 */
const static CGFloat alertWidth = 270;
/** 内容宽度 */
const static CGFloat containerWidth = alertWidth - 2*padding;
@interface ZYCustomViewController ()<UIViewControllerTransitioningDelegate>

/**标题*/
@property (nonatomic, strong) UILabel *titleLabel;
///**内容说明*/
@property (nonatomic,strong) UITextView *contentTextView;
@property (nonatomic,assign) CGFloat containerViewHeight;
@property (nonatomic,strong) NSMutableArray *btnArray;

////////////////有图片+内容//////
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UIButton *closeBtn;
@end

@implementation ZYCustomViewController
CGFloat btnHeight = 0;
CGFloat btnSpacerHeight = 0;

- (instancetype)init {
    if (self = [super init]) {
        self.transitioningDelegate = self;                          // 设置自己为转场代理
        self.modalPresentationStyle = UIModalPresentationCustom;    // 自定义转场模式
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [self.view addSubview:self.alertView];
    
    if (_type == CustomViewNonCustomization) {
        [self.alertView mas_updateConstraints:^(MASConstraintMaker *make) {
            [make center];
            make.width.offset(alertWidth);
            make.height.offset(self.containerViewHeight +btnHeight);
        }];
    }else{
        [self.alertView addSubview:self.containerView];
    }
    
    [self addButtonsToView:self.alertView];
}
- (void)prepareExternalCustomUI
{
 
    _buttonTitles = @[@"关闭"];
    _type = CustomViewCustomization;
}

- (void)prepareUIWithContentText:(NSString *)content
{
    return [self prepareUIWithTitle:nil contentText:content];
}
- (void)prepareUIWithTitle:(NSString *)title contentText:(NSString *)content
{
   
    _buttonTitles = @[@"关闭"];
    _type = CustomViewNonCustomization;
    
    self.titleLabel.text = title;
    self.contentTextView.text = content;
    
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.contentTextView];
    
    // 添加约束 titleLabel
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(containerWidth);
        make.centerX.equalTo(self.containerView);
        make.top.offset(0);
        make.bottom.equalTo(self.contentTextView.mas_top).offset(-5);
    }];
    
    // 添加约束 contentTextView
    CGFloat textViewHeight = [self.contentTextView sizeThatFits:CGSizeMake(containerWidth, 0)].height;
    CGFloat titleHeight = [self.titleLabel sizeThatFits:CGSizeMake(containerWidth, 0)].height;
    if (textViewHeight > SCREEN_HEIGHT/5) {
        textViewHeight = SCREEN_HEIGHT/5;
    }
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(containerWidth);
        make.centerX.equalTo(self.containerView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.bottom.offset(0);
        make.height.offset(textViewHeight);
    }];
    
    // 添加约束
    self.containerViewHeight = textViewHeight + titleHeight +padding +5;
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.centerX.equalTo(self.alertView);
        make.width.offset(containerWidth);
        make.height.offset(self.containerViewHeight);
    }];
   
}

- (UITextView *)contentTextView
{
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc]init];
        _contentTextView.showsVerticalScrollIndicator = NO;
        _contentTextView.textAlignment = NSTextAlignmentCenter;
        _contentTextView.textColor = CONTENT_TEXT_COLOR;
        _contentTextView.font = CONTENT_TEXT_FONT;
        _contentTextView.editable = NO;
        _contentTextView.selectable = NO;
    }
    return _contentTextView;
}

//MARK:一个图片+内容的弹框
- (void)prepareUIImageName:(NSString *)imageName
                   title  :(NSString *)title
                   content:(NSString *)content
{
        _buttonTitles = @[@"关闭"];
        _type = CustomViewNonCustomization;
    
        self.contentTextView.text = content;
        self.titleLabel.text   = title;
        
        [self.containerView addSubview:self.imgView];
        [self.containerView addSubview:self.titleLabel];
        [self.containerView addSubview:self.contentTextView];
        [self.containerView addSubview:self.closeBtn];
        
        self.imgView.image = [UIImage imageNamed:imageName];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.offset(0);
            make.height.offset(140);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(containerWidth);
            make.centerX.equalTo(self.containerView);
            make.top.equalTo(self.imgView.mas_bottom).offset(padding);
            make.bottom.equalTo(self.contentTextView.mas_top).offset(-padding);
        }];
        
        CGFloat textViewHeight = [self.contentTextView sizeThatFits:CGSizeMake(containerWidth, 0)].height;
        [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.containerView);
            make.width.offset(containerWidth);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(padding);
            make.height.offset(textViewHeight);
        }];
        
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-padding);
            make.top.offset(padding);
            make.width.height.offset(30);
        }];
        
        self.containerViewHeight = 140 + textViewHeight +[self.titleLabel sizeThatFits:CGSizeMake(containerWidth, 0)].height +padding*2;
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.centerX.equalTo(self.alertView);
            make.width.offset(alertWidth);
            make.height.offset(self.containerViewHeight);
        }];
}
- (void)setTitleTextColor:(UIColor *)titleTextColor
{
    if (titleTextColor)self.titleLabel.textColor = titleTextColor;
}
- (void)setContentTextColor:(UIColor *)contentTextColor
{
    if (contentTextColor)self.contentTextView.textColor = contentTextColor;
}
- (void)setTitleTextFont:(UIFont *)titleTextFont
{
    if (titleTextFont)self.titleLabel.font = titleTextFont;
}
- (void)setContentTextFont:(UIFont *)contentTextFont
{
    if (contentTextFont)self.contentTextView.font = contentTextFont;
}
- (void)setTitleAttributedText:(NSAttributedString *)titleAttributedText
{
    if (titleAttributedText) self.titleLabel.attributedText = titleAttributedText;
}
- (void)setContentAttributedText:(NSAttributedString *)contentAttributedText
{
    if (contentAttributedText)self.contentTextView.attributedText = contentAttributedText;
}
- (void)setBtnTitleColor:(UIColor *)btnTitleColor
{
    if (btnTitleColor){
        for (UIButton * closeBtn in self.btnArray) {
            [closeBtn setTitleColor:btnTitleColor forState:UIControlStateNormal];
        }
    }
}
- (void)setBtnTitleFont:(UIFont *)btnTitleFont
{
    if (btnTitleFont) {
        for (UIButton * closeBtn in self.btnArray) {
            [closeBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        }
    }
}
- (void)setBtnBgColor:(UIColor *)btnBgColor
{
    if (btnBgColor) {
        for (UIButton * closeBtn in self.btnArray) {
            closeBtn.backgroundColor = btnBgColor;
        }
    }
}

- (UIView *)alertView
{
    if (!_alertView) {
        CGSize screenSize = [self countScreenSize];
        CGSize dialogSize = [self countDialogSize];
        _alertView = [[UIView alloc] initWithFrame:CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height)];
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.layer.cornerRadius = kCustomAlertViewCornerRadius;
        _alertView.clipsToBounds = YES;
        _alertView.layer.opacity = 0.5f;
        _alertView.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.0);
    }
    [_alertView addSubview:self.containerView];
    return _alertView;
}

- (void)buttonTouchUpInside:(id)sender
{
    if (self.onButtonTouchUpInside) {
        self.onButtonTouchUpInside( [sender tag]);
    }
    // 点击button后自动dismiss
    if (self) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)addButtonsToView: (UIView *)container
{
    if (_buttonTitles==NULL) return;
    
    CGFloat buttonWidth = alertWidth / [_buttonTitles count];
    
    for (int i=0; i<[_buttonTitles count]; i++) {
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setTag:i];
        [closeButton setTitle:[_buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
        [closeButton setTitleColor:i == 0 ?MAIN_COLOR:CANCEL_COLOR  forState:UIControlStateNormal];
        [closeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        closeButton.titleLabel.numberOfLines = 0;
        [self.alertView addSubview:closeButton];
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(buttonWidth);
            make.right.offset( -(i * buttonWidth));
            make.bottom.offset(0);
            make.height.offset(btnHeight);
        }];
        [self.btnArray addObject:closeButton];
    }
}


- (CGSize)countDialogSize
{
    CGFloat dialogWidth = alertWidth;
    CGFloat dialogHeight ;
    if (_buttonTitles!=NULL && [_buttonTitles count] > 2) {
        dialogHeight = self.containerView.frame.size.height + btnHeight*[_buttonTitles count] + btnSpacerHeight;
    }else{
        dialogHeight = self.containerView.frame.size.height + btnHeight + btnSpacerHeight;
    }
    return CGSizeMake(dialogWidth, dialogHeight);
}

- (CGSize)countScreenSize
{
    if (_buttonTitles!=NULL && [_buttonTitles count] > 0) {
        btnHeight       = kCustomAlertViewDefaultButtonHeight;
        btnSpacerHeight = kCustomAlertViewDefaultButtonSpacerHeight;
    } else {
        btnHeight = 0;
        btnSpacerHeight = 0;
    }
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    return CGSizeMake(screenWidth, screenHeight);
}

#pragma mark 懒加载
- (NSMutableArray *)btnArray
{
    if (!_btnArray) {
        _btnArray = [@[]mutableCopy];
    }
    return _btnArray;
}
- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertWidth, 150)];
        _containerView.layer.cornerRadius = kCustomAlertViewCornerRadius;
        _containerView.clipsToBounds = YES;
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}


- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = TITLE_TEXT_COLOR;
        _titleLabel.font = TITLE_TEXT_FONT;
    }
    return _titleLabel;
}

-(UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}

- (UIButton*)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"X"] forState:UIControlStateNormal];
        [_closeBtn setTitle:@"X" forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (void)close
{
    // 点击button后自动dismiss
    if (self) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark - UIViewControllerTransitioningDelegate
/** 返回Present动画 */
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    ZYPopupPresentAnimator *animator = [[ZYPopupPresentAnimator alloc] init];
    return animator;
}

/** 返回Dismiss动画 */
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    ZYPopupDismissAnimator *animator = [[ZYPopupDismissAnimator alloc] init];
    return animator;
}


@end
