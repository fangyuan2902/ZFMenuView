//
//  ZFMenuView.h
//  ZFMenuView
//
//  Created by mac on 2019/1/17.
//  Copyright © 2019年 k. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZFMenuAction;

@interface ZFMenuView : UIView

+ (instancetype)menuWithActions:(NSArray<ZFMenuAction *> *)actions relyonView:(UIView *)view;

- (void)show;

@end

@interface ZFMenuAction : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) void (^handler)(ZFMenuAction *action);

+ (instancetype)actionWithTitle:(NSString *)title image:(UIImage *)image handler:(void (^)(ZFMenuAction *action))handler;

@end

NS_ASSUME_NONNULL_END
