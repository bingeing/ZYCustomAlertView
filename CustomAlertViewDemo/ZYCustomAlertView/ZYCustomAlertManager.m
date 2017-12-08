//
//  CustomAlertManager.m
//  ASPopupControllerDemo
//
//  Created by zhaoying on 2017/11/21.
//  Copyright © 2017年 zhaoying. All rights reserved.
//

#import "ZYCustomAlertManager.h"
#import <Masonry/Masonry.h>
#import "ZYCustomViewController.h"

#define WEAK_SELF __weak typeof(self) weakSelf = self;
#define STRONG_SELF __strong typeof(weakSelf) strongSelf = weakSelf;
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define MAIN_COLOR  [UIColor colorWithRed:213.0f / 255.0f green:184.0f / 255.0f blue:119.0f / 255.0f alpha:1.0f]
#define CANCEL_COLOR   [UIColor lightGrayColor]
#define TITLE_TEXT_COLOR   [UIColor blackColor]
#define CONTENT_TEXT_COLOR   [UIColor blackColor]
#define TITLE_TEXT_FONT  [UIFont systemFontOfSize:16]
#define CONTENT_TEXT_FONT  [UIFont systemFontOfSize:14]
#define BUTTON_TEXT_FONT  [UIFont systemFontOfSize:14]

const static CGFloat kCustomAlertViewDefaultButtonHeight       = 44;
const static CGFloat kCustomAlertViewDefaultButtonSpacerHeight = 1;
const static CGFloat kCustomAlertViewCornerRadius              = 5;

/** 间隙 */
const static CGFloat padding = 15.0;
/** 弹窗总宽度 */
const static CGFloat alertWidth = 270;
/** 内容宽度 */
const static CGFloat containerWidth = alertWidth - 2*padding;

@interface ZYCustomAlertManager ()
@property (nonatomic, strong) UIView *alertView;
/**标题*/
@property (nonatomic, strong) UILabel *titleLabel;

///**内容说明*/
@property (nonatomic,strong)  UITextView *contentTextView;

@property (nonatomic,assign) CGFloat containerViewHeight;
@property (nonatomic,strong) NSMutableArray *btnArray;

////////////////有图片+内容//////
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UIButton *closeBtn;

@end

@implementation ZYCustomAlertManager
CGFloat buttonHeight = 0;
CGFloat buttonSpacerHeight = 0;

+ (instancetype)shareInstance
{
    static dispatch_once_t predicate;
    static ZYCustomAlertManager *manager = nil;
    dispatch_once(&predicate, ^{
        manager = [ZYCustomAlertManager new];
    });
    return manager;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.frame = [UIScreen mainScreen].bounds;
    }
    return self;
}

- (void)externalCustomUIWithButtonTitleArray : (NSArray <NSString *> *)buttonTitleArray
                                 buttonClicked:(void (^) (NSInteger index))buttonClicked
{
   _closeOnTouchUpOutside = NO;
   _buttonTitles = buttonTitleArray;
    _onButtonTouchUpInside = buttonClicked;
    _type = AlertViewCustomization;
}

- (void)prepareUIWithContentText:(NSString *)content
               buttonTitleArray : (NSArray <NSString *> *)buttonTitleArray
                   buttonClicked:(void (^) (NSInteger index))buttonClicked
{
    
    [self prepareUIWithTitle:nil contentText:content buttonTitleArray:buttonTitleArray buttonClicked:buttonClicked];
}

- (void)prepareUIWithTitle:(NSString *)title
               contentText:(NSString *)content
         buttonTitleArray : (NSArray <NSString *> *)buttonTitleArray
             buttonClicked:(void (^) (NSInteger index))buttonClicked
{
    
    _closeOnTouchUpOutside = NO;
    _buttonTitles = buttonTitleArray;
    _onButtonTouchUpInside = buttonClicked;
    _type = AlertViewNonCustomization;
    
    self.titleLabel.text = title;
    self.contentTextView.text = content;
    
    [self.alertView addSubview:self.containerView];
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.contentTextView];
    
    // 添加约束 titleLabel
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(containerWidth);
        make.centerX.equalTo(self.containerView);
        make.top.offset(0);
        make.bottom.equalTo(self.contentTextView.mas_top).offset(-padding);
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
        make.top.equalTo(self.titleLabel.mas_bottom).offset(padding);
        make.bottom.offset(0);
        make.height.offset(textViewHeight);
    }];
    
    // 添加约束
    self.containerViewHeight = textViewHeight + titleHeight + padding*2;
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.centerX.equalTo(self.alertView);
        make.width.offset(containerWidth);
        make.height.offset(self.containerViewHeight).priorityHigh();
    }];
}
//MARK:一个图片+内容的弹框
- (void)prepareUIImageName:(NSString *)imageName
                   title  :(NSString *)title
                   content:(NSString *)content
         buttonTitleArray : (NSArray <NSString *> *)buttonTitleArray
             buttonClicked:(void (^) (NSInteger index))buttonClicked
{
   
    _closeOnTouchUpOutside = NO;
    _buttonTitles = buttonTitleArray;
    _onButtonTouchUpInside = buttonClicked;
    _type = AlertViewNonCustomization;
    
    self.titleLabel.text = title;
    self.contentTextView.text = content;
    
    [self.alertView addSubview:self.containerView];
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
        make.width.offset(containerWidth);
        make.height.offset(self.containerViewHeight).priorityHigh();
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
- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication].keyWindow addSubview:self.alertView];
    if (_type == AlertViewCustomization) {
        [self.alertView addSubview:self.containerView];

    }else{
        [self.alertView mas_updateConstraints:^(MASConstraintMaker *make) {
            [make center];
            make.width.offset(alertWidth);
            make.height.offset(self.containerViewHeight + buttonHeight).priorityHigh();
        }];
    }
    [self addButtonsToView:self.alertView];
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
                         self.alertView.layer.opacity = 1.0f;
                         self.alertView.layer.transform = CATransform3DMakeScale(1, 1, 1);
                     }
                     completion:NULL
     ];
    
}


- (void)buttonTouchUpInside:(id)sender
{
    UIButton *btn = sender;
    if (self.onButtonTouchUpInside) {
        self.onButtonTouchUpInside(btn.tag);
    }
    [self close];
}

- (void)close
{
    CATransform3D currentTransform = self.alertView.layer.transform;
    self.alertView.layer.opacity = 1.0f;
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                         self.alertView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
                         self.alertView.layer.opacity = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         for (UIView *v in [self.alertView subviews]) {
                             [v removeFromSuperview];
                         }
                         for (UIView *v in [self subviews]) {
                             [v removeFromSuperview];
                         }
                         for (UIView *v in [self.containerView subviews]) {
                              [v removeFromSuperview];
                         }
                         [self.alertView removeFromSuperview];
                         [self removeFromSuperview];
                         [self.containerView removeFromSuperview];
                         self.containerViewHeight = 0;
                         self.buttonTitles = nil;
                     }
     ];
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
        [closeButton setTitleColor:i == 1 ?CANCEL_COLOR: MAIN_COLOR forState:UIControlStateNormal];
        [closeButton.titleLabel setFont:BUTTON_TEXT_FONT];
        [container addSubview:closeButton];
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(buttonWidth);
            make.right.offset(-(i*buttonWidth));
            make.bottom.offset(0);
            make.height.offset(buttonHeight);
        }];
        [self.btnArray addObject:closeButton];
    }
}


- (void)countAlertViewHeight
{
   
    if (_buttonTitles && [_buttonTitles count] > 0) {
        buttonHeight       = kCustomAlertViewDefaultButtonHeight;
        buttonSpacerHeight = kCustomAlertViewDefaultButtonSpacerHeight;
    } else {
        buttonHeight = 0;
        buttonSpacerHeight = 0;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!_closeOnTouchUpOutside) return;
    UITouch *touch = [touches anyObject];
    if ([touch.view isKindOfClass:[ZYCustomAlertManager class]]) {
        [self close];
    }
}


#pragma mark 懒加载
- (UIView *)alertView
{
    if (!_alertView) {
        [self countScreenSize];
        CGSize dialogSize = [self countDialogSize];
        _alertView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - dialogSize.width) / 2, (SCREEN_HEIGHT - dialogSize.height) / 2, dialogSize.width, dialogSize.height)];
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.layer.cornerRadius = kCustomAlertViewCornerRadius;
        _alertView.clipsToBounds = YES;
        _alertView.layer.shouldRasterize = YES;
        _alertView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        _alertView.layer.opacity = 0.5f;
        _alertView.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.0);
    }
    return _alertView;
}
- (void)countScreenSize
{
    if (_buttonTitles!=NULL && [_buttonTitles count] > 0) {
        buttonHeight       = kCustomAlertViewDefaultButtonHeight;
        buttonSpacerHeight = kCustomAlertViewDefaultButtonSpacerHeight;
    } else {
        buttonHeight = 0;
        buttonSpacerHeight = 0;
    }
    
}
- (CGSize)countDialogSize
{
    if (_buttonTitles!=NULL && [_buttonTitles count] > 0) {
        buttonHeight       = kCustomAlertViewDefaultButtonHeight;
        buttonSpacerHeight = kCustomAlertViewDefaultButtonSpacerHeight;
    } else {
        buttonHeight = 0;
        buttonSpacerHeight = 0;
    }
    
    CGFloat dialogWidth = alertWidth;
    CGFloat dialogHeight ;
    if (_buttonTitles!=NULL && [_buttonTitles count] > 2) {
        dialogHeight = self.containerView.frame.size.height + buttonHeight*[_buttonTitles count] + buttonSpacerHeight;
    }else{
        dialogHeight = self.containerView.frame.size.height + buttonHeight + buttonSpacerHeight;
    }
    return CGSizeMake(dialogWidth, dialogHeight);
}
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
- (void)showWithTitle:(NSString*)title
              message:(NSString * )message
       btnTitleArray : (NSArray <NSString *> *)btnTitleArray
           btnClicked:(void (^) (NSInteger index))btnClicked

{
    ZYCustomViewController *alert = [ZYCustomViewController new];
    [alert prepareUIWithTitle:title contentText:message];
    [alert setButtonTitles:btnTitleArray];
    alert.onButtonTouchUpInside = btnClicked;
    [[self appRootViewController] presentViewController:alert animated:YES completion:nil];
   
}

- (void)showExternalCustomUIWithbtnTitleArray : (NSArray <NSString *> *)btnTitleArray
                                    btnClicked:(void (^) (NSInteger index))btnClicked
{
    ZYCustomViewController *alert = [ZYCustomViewController new];
    alert.containerView = self.containerView;
    [alert prepareExternalCustomUI];
    [alert setButtonTitles:btnTitleArray];
    alert.onButtonTouchUpInside = btnClicked;
    [[self appRootViewController] presentViewController:alert animated:YES completion:nil];
    
}

- (void)showWithUIImageName:(NSString *)imageName
                    title  :(NSString *)title
                    content:(NSString *)content
          btnTitleArray : (NSArray <NSString *> *)btnTitleArray
              btnClicked:(void (^) (NSInteger index))btnClicked
{
    ZYCustomViewController *alert = [ZYCustomViewController new];
    [alert prepareUIImageName:imageName title:title content:content];
    [alert setButtonTitles:btnTitleArray];
    alert.onButtonTouchUpInside = btnClicked;
    [[self appRootViewController] presentViewController:alert animated:YES completion:nil];
}
- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}
@end
