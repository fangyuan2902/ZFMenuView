//
//  ZFMenuView.m
//  ZFMenuView
//
//  Created by mac on 2019/1/17.
//  Copyright © 2019年 k. All rights reserved.
//

#define kArrowWidth          10.0
#define kArrowHeight         6.0
#define kDefaultMargin       5.0

#import "ZFMenuView.h"

@implementation ZFMenuAction

+ (instancetype)actionWithTitle:(NSString *)title image:(UIImage *)image handler:(void (^)(ZFMenuAction *action))handler {
    ZFMenuAction *action = [[ZFMenuAction alloc] initWithTitle:title image:image handler:handler];
    return action;
}

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image handler:(void (^)(ZFMenuAction *action))handler {
    if (self = [super init]) {
        _title = [NSString stringWithFormat:@"  %@",title];
        _image = image;
        _handler = [handler copy];
    }
    return self;
}

@end

@interface ZFMenuView()

@property (nonatomic, strong) NSArray<ZFMenuAction *> *actions;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *refView;
@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGPoint refPoint;
@property (nonatomic, assign) CGFloat arrowPosition;
@property (nonatomic, assign) CGFloat topMargin;

@end

@implementation ZFMenuView

+ (instancetype)menuWithActions:(NSArray<ZFMenuAction *> *)actions relyonView:(UIView *)view {
    ZFMenuView *menu = [[ZFMenuView alloc] initWithActions:actions relyonView:view];
    return menu;
}

- (instancetype)initWithActions:(NSArray<ZFMenuAction *> *)actions relyonView:(UIView *)view {
    if (self = [super init]) {
        _refView = view;
        _actions = [actions copy];
        [self defaultConfiguration];
        [self setupSubView];
    }
    return self;
}

- (void)defaultConfiguration {
    self.alpha = 0.0f;
    _cellWidth = 55.0;
    _offset = 0.0f;
}

- (void)setupSubView {
    [self calculateArrowAndFrame];
    [self setupMaskLayer];
    [self addSubview:self.contentView];
}

- (void)buttonAction:(UIButton *)button {
    ZFMenuAction *action = _actions[button.tag - 1000];
    if (action.handler) {
        action.handler(action);
    }
    [self dismiss];
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview: self.bgView];
    [[UIApplication sharedApplication].keyWindow addSubview: self];
    self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration: 0.25 animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 1.0f;
        self.bgView.alpha = 1.0f;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration: 0.25 animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
        self.alpha = 0.0f;
        self.bgView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.bgView removeFromSuperview];
        self.actions = nil;
    }];
}

#pragma mark - Private
- (void)setupMaskLayer {
    CAShapeLayer *layer = [self drawMaskLayer];
    self.contentView.layer.mask = layer;
}

- (void)calculateArrowAndFrame {
    CGFloat originX;
    CGFloat originY;
    CGFloat width;
    _refPoint = [self getRefPoint];
    width = (kDefaultMargin + _actions.count * (_cellWidth + kDefaultMargin) > self.screenWidth - kDefaultMargin * 2) ? self.screenWidth - kDefaultMargin * 2 : kDefaultMargin + _actions.count * (_cellWidth + kDefaultMargin);
    _arrowPosition = 0.5 * width - 0.5 * kArrowWidth;
    originX = _refPoint.x - _arrowPosition - 0.5 * kArrowWidth;
    originY = _refPoint.y;
    if (originX + width > self.screenWidth - kDefaultMargin) {
        originX = self.screenWidth - kDefaultMargin - width;
    }else if (originX < kDefaultMargin) {
        originX = kDefaultMargin;
    }
    if ((_refPoint.x <= originX + width - 5.0) && (_refPoint.x >= originX + 5.0)) {
        _arrowPosition = _refPoint.x - originX - 0.5 * kArrowWidth;
    } else if (_refPoint.x < originX + 5.0) {
        _arrowPosition = 5.0;
    } else {
        _arrowPosition = width - 5.0 - kArrowWidth;
    }
    CGPoint anchorPoint = CGPointMake(fabs(_arrowPosition) / width, 0);
    _topMargin = kArrowHeight;
    originY += originY >= _refPoint.y ? _offset : -_offset;
    self.layer.anchorPoint = anchorPoint;
    self.frame = CGRectMake(originX, originY, width, 42.0 + kArrowHeight);
}

- (CAShapeLayer *)drawMaskLayer {
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    CGFloat bottomMargin = 0;
    CGPoint topRightArcCenter = CGPointMake(self.width - 5.0, _topMargin + 5.0);
    CGPoint bottomRightArcCenter = CGPointMake(self.width - 5.0, self.height - bottomMargin - 5.0);
    CGPoint bottomLeftArcCenter = CGPointMake(5.0, self.height - bottomMargin - 5.0);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(0, _topMargin + 5.0)];
    [path addLineToPoint: CGPointMake(0, bottomLeftArcCenter.y)];
    [path addArcWithCenter: bottomLeftArcCenter radius: 5.0 startAngle: -M_PI endAngle: -M_PI-M_PI_2 clockwise: NO];
    [path addLineToPoint: CGPointMake(self.width - 5.0, self.height - bottomMargin)];
    [path addArcWithCenter: bottomRightArcCenter radius: 5.0 startAngle: -M_PI-M_PI_2 endAngle: -M_PI*2 clockwise: NO];
    [path addLineToPoint: CGPointMake(self.width, self.height - bottomMargin + 5.0)];
    [path addArcWithCenter: topRightArcCenter radius: 5.0 startAngle: 0 endAngle: -M_PI_2 clockwise: NO];
    
    [path addLineToPoint: CGPointMake(_arrowPosition + kArrowWidth, _topMargin)];
    [path addLineToPoint: CGPointMake(_arrowPosition + 0.5 * kArrowWidth, 0)];
    [path addLineToPoint: CGPointMake(_arrowPosition, _topMargin)];
    [path addLineToPoint: CGPointMake(5.0, _topMargin)];
    [path closePath];
    maskLayer.path = path.CGPath;
    return maskLayer;
}

#pragma mark - Setting&&Getting
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _bgView.alpha = 0.0f;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:self.bounds];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.masksToBounds = YES;
        for (int i = 0;i <  _actions.count; i++) {
            ZFMenuAction *action = _actions[i];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(kDefaultMargin + i * (_cellWidth + kDefaultMargin), kArrowHeight, _cellWidth, 42.0 + kArrowHeight - kArrowHeight);
            button.tag = 1000 + i;
            button.backgroundColor = [UIColor clearColor];
            button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitle:action.title forState:UIControlStateNormal];
            [button setImage:action.image?action.image:nil forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [_contentView addSubview:button];
        }
    }
    return _contentView;
}

- (CGPoint)getRefPoint {
    CGRect absoluteRect = [_refView convertRect:_refView.bounds toView:[UIApplication sharedApplication].keyWindow];
    CGPoint refPoint = CGPointMake(absoluteRect.origin.x + absoluteRect.size.width / 2, absoluteRect.origin.y + absoluteRect.size.height);
    return refPoint;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGFloat)screenWidth {
    return [UIScreen mainScreen].bounds.size.width;
    
}

@end
