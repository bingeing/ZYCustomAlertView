//
//  ZYCustomViewController.h
//
//  Created by zhaoying on 2017/12/5.
//  Copyright © 2017年 zhaoying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYPopupPresentAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@end

@interface ZYPopupDismissAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@end
typedef NS_ENUM(NSUInteger, ZYCustomViewType) {
    CustomViewNonCustomization = 0,         // 默认，非定制
    CustomViewCustomization = 1,         // 外部定制
};

@interface ZYCustomViewController : UIViewController
// 容器
@property (nonatomic, strong) UIView *containerView;
//按钮数组
@property (nonatomic, strong) NSArray *buttonTitles;

//弹框点击事件的block
@property (nonatomic,copy) void (^onButtonTouchUpInside)( NSInteger buttonIndex);
//弹框类型
@property (nonatomic, assign) ZYCustomViewType type;

//标题颜色
@property (nonatomic,strong) UIColor *titleTextColor;
//标题字号
@property (nonatomic,strong) UIFont *titleTextFont;
//内容颜色
@property (nonatomic,strong) UIColor *contentTextColor;
//内容字号
@property (nonatomic,strong) UIFont *contentTextFont;
//title富文本修饰的内容
@property(nonatomic,strong)   NSAttributedString *titleAttributedText;
//content富文本修饰的内容
@property(nonatomic,strong)   NSAttributedString *contentAttributedText;

//按钮字体颜色
@property (nonatomic,strong) UIColor *btnTitleColor;
//按钮字体字号
@property (nonatomic,strong) UIFont *btnTitleFont;
//按钮背景颜色
@property (nonatomic,strong) UIColor *btnBgColor;

@property (nonatomic, strong) UIView *alertView;

//定制alert弹框
- (void)prepareExternalCustomUI;

/**
 @param content 弹框内容
 */
- (void)prepareUIWithContentText:(NSString *)content;

/**
 @param title 弹框标题
 @param content 弹框内容
 */
- (void)prepareUIWithTitle:(NSString *)title contentText:(NSString *)content;

/**
 @param imageName 图片名字
 @param title 标题
 @param content 内容
 */
- (void)prepareUIImageName:(NSString *)imageName
                   title  :(NSString *)title
                   content:(NSString *)content;

- (void)setOnButtonTouchUpInside:(void (^)( NSInteger buttonIndex))onButtonTouchUpInside;
@end
