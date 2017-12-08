//
//  CustomAlertManager.h
//  ASPopupControllerDemo
//
//  Created by zhaoying on 2017/11/21.
//  Copyright © 2017年 zhaoying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZYCustomAlertType) {
    AlertViewNonCustomization = 0,         // 默认，非定制
    AlertViewCustomization = 1,         // 外部定制
};

@interface ZYCustomAlertManager  : UIView
+ (instancetype)shareInstance ;

/** 保存当前的视图控制器，用来dismiss */
@property (nonatomic, strong)UIViewController *controller;

// 容器
@property (nonatomic, strong) UIView *containerView;
//按钮数组
@property (nonatomic, strong) NSArray *buttonTitles;
// 点击阴影，是否关闭
@property (nonatomic, assign) BOOL closeOnTouchUpOutside;
//弹框类型
@property (nonatomic, assign) ZYCustomAlertType type;
//弹框点击事件的block
@property (nonatomic,copy) void (^onButtonTouchUpInside)(NSInteger buttonIndex);

//标题颜色
@property (nonatomic,strong) UIColor *titleTextColor;
//标题字号
@property (nonatomic,strong) UIFont *titleTextFont;
//内容颜色
@property (nonatomic,strong) UIColor *contentTextColor;
//内容字号
@property (nonatomic,strong) UIFont *contentTextFont;
//title富文本修饰的内容
@property(nonatomic,copy)   NSAttributedString *titleAttributedText;
//content富文本修饰的内容
@property(nonatomic,copy)   NSAttributedString *contentAttributedText;

//按钮字体颜色
@property (nonatomic,strong) UIColor *btnTitleColor;
//按钮字体字号
@property (nonatomic,strong) UIFont *btnTitleFont;
//按钮背景颜色
@property (nonatomic,strong) UIColor *btnBgColor;

//定制alert弹框
- (void)externalCustomUIWithButtonTitleArray : (NSArray <NSString *> *)buttonTitleArray
                                buttonClicked:(void (^) (NSInteger index))buttonClicked;
/**
 @param 内容 弹框内容
 */

- (void)prepareUIWithContentText:(NSString *)content
               buttonTitleArray : (NSArray <NSString *> *)buttonTitleArray
                   buttonClicked:(void (^) (NSInteger index))buttonClicked;

/**
 @param title 弹框标题
 @param content 弹框内容
 */
- (void)prepareUIWithTitle:(NSString *)title
               contentText:(NSString *)content
         buttonTitleArray : (NSArray <NSString *> *)buttonTitleArray
             buttonClicked:(void (^) (NSInteger index))buttonClicked;
/**
 @param imageName 图片名字
 @param title 标题
 @param content 内容
 */
- (void)prepareUIImageName:(NSString *)imageName
                          title  :(NSString *)title
                          content:(NSString *)content
                buttonTitleArray : (NSArray <NSString *> *)buttonTitleArray
                    buttonClicked:(void (^) (NSInteger index))buttonClicked;

- (void)show;
- (void)close;
- (void)setOnButtonTouchUpInside:(void (^)( NSInteger buttonIndex))onButtonTouchUpInside;

#pragma mark 显示在ViewController上的
/**
 @param title 标题 ，如未为空，则不显示
 @param message 内容
 @param buttonTitleArray 按钮标题数组  如@[@"确定",@"取消"]，则"确定"按钮在右侧，"取消"按钮在左侧
 */
- (void)showWithTitle:(NSString*)title
              message:(NSString * )message
    btnTitleArray : (NSArray <NSString *> *)btnTitleArray
        btnClicked:(void (^) (NSInteger index))btnClicked;

//在controller上显示定制的UI
- (void)showExternalCustomUIWithbtnTitleArray : (NSArray <NSString *> *)btnTitleArray
                                     btnClicked:(void (^) (NSInteger index))btnClicked;

- (void)showWithUIImageName:(NSString *)imageName
                    title  :(NSString *)title
                    content:(NSString *)content
             btnTitleArray : (NSArray <NSString *> *)btnTitleArray
                 btnClicked:(void (^) (NSInteger index))btnClicked;
@end
