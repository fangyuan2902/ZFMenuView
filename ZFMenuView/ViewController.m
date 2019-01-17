//
//  ViewController.m
//  ZFMenuView
//
//  Created by mac on 2019/1/17.
//  Copyright © 2019年 k. All rights reserved.
//

#import "ViewController.h"
#import "ZFMenuView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 200, 120, 80);
    button.backgroundColor = [UIColor lightGrayColor];
    [button setTitle:@"点击" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)menuAction:(UIView *)view {
    ZFMenuAction *action = [ZFMenuAction actionWithTitle:@"删除" image:[UIImage imageNamed:@"删除"] handler:^(ZFMenuAction *action) {
        
    }];
    ZFMenuAction *action1 = [ZFMenuAction actionWithTitle:@"下架" image:[UIImage imageNamed:@"下架"] handler:^(ZFMenuAction *action) {
        
    }];
    ZFMenuAction *action2 = [ZFMenuAction actionWithTitle:@"预览" image:[UIImage imageNamed:@"预览"] handler:^(ZFMenuAction *action) {
        
    }];
    ZFMenuAction *action3 = [ZFMenuAction actionWithTitle:@"多选" image:[UIImage imageNamed:@"多选"] handler:^(ZFMenuAction *action) {
        
    }];
    NSArray *arr = @[action,action1,action2,action3];
    ZFMenuView *menuView = [ZFMenuView menuWithActions:arr relyonView:view];
    [menuView show];
}

@end
