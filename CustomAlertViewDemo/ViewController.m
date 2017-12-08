//
//  ViewController.m
//  CustomAlertViewDemo
//
//  Created by zhaoying on 2017/12/8.
//  Copyright © 2017年 zhaoying. All rights reserved.
//

#import "ViewController.h"
#import "ZYCustomAlertManager.h"
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)NSArray *titleArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleArray = @[@"弹框",@"弹框1",@"弹框2",@"弹框3",@"弹框4",@"弹框5",@"弹框6"];
    
    UITableView *demoTable = [[UITableView alloc] initWithFrame:self.view.frame];
    demoTable.delegate = self;
    demoTable.dataSource = self;
    [self.view addSubview:demoTable];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = _titleArray[indexPath.row];
    return cell;
}

/** 使用看这里！ */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.row) {
        case 0:
        {
            [[ZYCustomAlertManager shareInstance] showWithTitle:@"弹框"
                                                        message:@"自定义弹框自定义弹框自定义弹框自定义弹框自定义弹框自定义弹框自定义弹框自定义弹框自定义弹框"
                                                  btnTitleArray:@[@"确定",@"取消"]
                                                     btnClicked:^(NSInteger index) {
                                                         
                                                         NSLog(@"===%ld",index);
                                                         
                                                     }];
            
            
        }
            break;
        case 1:
        {
            [ZYCustomAlertManager shareInstance].containerView = [self createDemoView];
            [[ZYCustomAlertManager shareInstance] showExternalCustomUIWithbtnTitleArray:@[@"确定",@"取消"] btnClicked:^(NSInteger index) {
                NSLog(@"===%ld",index);
            }];
            
            
        }
            break;
        case 2:
        {
            [[ZYCustomAlertManager shareInstance] showWithUIImageName:@"icon_permission_gesture" title:@"弹框" content:@"自定义弹框2 自定义弹框2 自定义弹框2 自定义弹框2 自定义弹框2 自定义弹框2" btnTitleArray:@[@"确定"] btnClicked:^(NSInteger index) {
                NSLog(@"===%ld",index);
            }];
        }
            break;
        case 3:
        {
            [[ZYCustomAlertManager shareInstance] externalCustomUIWithButtonTitleArray:@[@"确定"] buttonClicked:^(NSInteger index) {
                NSLog(@"===%ld",index);
            }];
            [[ZYCustomAlertManager shareInstance] setContainerView:[self createDemoView]];
            [[ZYCustomAlertManager shareInstance] show];
        }
            break;
        case 4:
        {
            [[ZYCustomAlertManager shareInstance] prepareUIWithContentText:@"自定义弹框4自定义弹框4" buttonTitleArray:@[@"确定"] buttonClicked:^(NSInteger index) {
                NSLog(@"===%ld",index);
            }];
            
            [[ZYCustomAlertManager shareInstance] show];
        }
            break;
            
        case 5:
        {
            NSString *title = @"警告警告";
            [[ZYCustomAlertManager shareInstance] prepareUIWithTitle:title contentText:@"自定义弹框5" buttonTitleArray:@[@"确定"] buttonClicked:^(NSInteger index) {
                NSLog(@"===%ld",index);
            }];
            
            //            NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:title];
            //            [titleStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, titleStr.length)];
            //            [ZYCustomAlertManager shareInstance].titleAttributedText = titleStr;
            [[ZYCustomAlertManager shareInstance] show];
        }
            break;
        case 6:
        {
            [[ZYCustomAlertManager shareInstance] prepareUIImageName:@"icon_permission_gesture"
                                                               title:@"弹框"
                                                             content:@"自定义弹框6"
                                                    buttonTitleArray:@[@"确定",@"取消"]
                                                       buttonClicked:^(NSInteger index) {
                                                           NSLog(@"===%ld",index);
                                                       }];
            
            [[ZYCustomAlertManager shareInstance] show];
            
        }
            break;
            
        default:
            break;
    }
}

- (UIView *)createDemoView
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 200)];
    demoView.backgroundColor = [UIColor redColor];
    return demoView;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
