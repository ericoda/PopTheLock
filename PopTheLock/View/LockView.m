//
//  LockView.m
//  PopTheLock
//
//  Created by Eric on 2017/3/1.
//  Copyright © 2017年 Eric. All rights reserved.
//

#import "LockView.h"



@interface LockView() <CAAnimationDelegate>
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, strong) CAShapeLayer *indicatorLayer;

@property (nonatomic, strong) UIColor *loopColor;
@property (nonatomic, strong) UIColor *pointColor;
@property (nonatomic, strong) UIColor *indicColor;

@property (nonatomic, assign) CGFloat randomDegree;
@end

@implementation LockView {
    BOOL _invert;
    BOOL _isFirstPosition;
    CGFloat _sideLength;
    
    NSUInteger _level;//关卡数
    NSUInteger _points;//圆点出现的次数
}

static NSString *pointerAnimKey   = @"pointerRotation";
static NSString *indicatorAnimKey = @"indicatorRotation";

@synthesize
loopLayer    = _loopLayer,
pointLayer   = _pointLayer,
randomDegree = _randomDegree,
pointDegree  = _pointDegree;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializedData];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)initializedData {
    CGRect frame = self.frame;
    _sideLength = CGRectGetWidth(frame) > CGRectGetHeight(frame) ? CGRectGetHeight(frame) : CGRectGetWidth(frame);
    _lineWidth = CGRectGetWidth(frame)/10;//线宽
    _radius = _sideLength/2 - _lineWidth*2;//半径
    _isFirstPosition = YES;
    _lastDegree = 0;
    _pointDegree = 0;
}

- (void)drawRect:(CGRect)rect {
    CAShapeLayer *loop = self.loopLayer;
    CAShapeLayer *point = self.pointLayer;
    CAShapeLayer *indic = self.indicatorLayer;
    
    [loop addSublayer:point];
    [loop addSublayer:indic];
    [self.layer addSublayer:loop];
}
//圆环层
- (CALayer *)loopLayer {
    if (!_loopLayer) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = self.frame;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.center radius:_radius startAngle:0 endAngle:2*M_PI clockwise:YES];
        layer.path = path.CGPath;
        layer.lineWidth = _lineWidth;
        layer.strokeColor = self.loopColor.CGColor;
        layer.fillColor = [UIColor clearColor].CGColor;
        _loopLayer = layer;
    }
    return _loopLayer;
}

//指示层
- (CALayer *)indicatorLayer {
    if (!_indicatorLayer) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = self.frame;
        CGFloat x = _sideLength/2-_lineWidth/6;
        CGFloat y = self.center.y-_radius-_lineWidth/2;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:(CGRect){{x,y},{_lineWidth/3,_lineWidth}} cornerRadius:20];
        layer.fillColor = self.indicColor.CGColor;
        layer.strokeColor = [UIColor clearColor].CGColor;
        layer.path = path.CGPath;
        _indicatorLayer = layer;
        
    }
    return _indicatorLayer;
}

//圆点层
- (CALayer *)pointLayer {
    if (!_pointLayer) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = self.frame;
        CGFloat x = _sideLength/2;
        CGFloat y = self.center.y - _radius;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:(CGPoint){x,y} radius:_lineWidth/3.f startAngle:0 endAngle:2*M_PI clockwise:YES];
        layer.fillColor = self.pointColor.CGColor;
        layer.strokeColor = [UIColor clearColor].CGColor;
        layer.path = path.CGPath;
        _pointLayer = layer;
    }
    return _pointLayer;
}


#pragma mark - PUBLIC
//添加圆点
- (void)showNewPoint {
    BOOL hasAnim = [[self.pointLayer animationKeys] containsObject:pointerAnimKey];
    if (hasAnim) {
        [self.pointLayer removeAnimationForKey:pointerAnimKey];
    }
    
    CABasicAnimation *anim = [self animationWithRotation];
    anim.duration = 0;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    _pointDegree = [self randomDegree];
    CATransform3D fromv = CATransform3DMakeRotation(_pointDegree, 0, 0, 1.f);
    CATransform3D tov = CATransform3DMakeRotation(_pointDegree, 0, 0, 1.f);
    anim.fromValue = [NSValue valueWithCATransform3D:fromv];
    anim.toValue = [NSValue valueWithCATransform3D:tov];
    [self.pointLayer addAnimation:anim forKey:pointerAnimKey];
    
}

//添加指针
- (void)showIndicator {
    BOOL hasAnim = [[self.indicatorLayer animationKeys] containsObject:indicatorAnimKey];
    if (hasAnim) {
        [self.indicatorLayer removeAnimationForKey:indicatorAnimKey];
    }
    CABasicAnimation *anim = [self animationWithRotation];
    CGFloat fromDgr = 0;
    if (_isFirstPosition) {
        fromDgr = 0;
        _isFirstPosition = NO;
    }else {
        fromDgr = _lastDegree;
    }
    anim.duration = [self timeForAnimation];
    //tmp code start
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    //tmp code end

    _lastDegree = _pointDegree;

    CATransform3D fromv = CATransform3DMakeRotation(fromDgr, 0, 0, 1.f);
    CATransform3D tov = CATransform3DMakeRotation(_pointDegree, 0, 0, 1.f);
    anim.fromValue = [NSValue valueWithCATransform3D:fromv];
    anim.toValue = [NSValue valueWithCATransform3D:tov];
    [self.indicatorLayer addAnimation:anim forKey:indicatorAnimKey];
}

#pragma mark - PRIVATE

- (UIColor *)indicColor {
    if (!_indicColor) {
        _indicColor = [UIColor orangeColor];
    }
    return _indicColor;
}

- (UIColor *)loopColor {
    if (!_loopColor) {
        _loopColor = [UIColor purpleColor];
    }
    return _loopColor;
}

- (UIColor *)pointColor {
    if (!_pointColor) {
        _pointColor = [UIColor yellowColor];
    }
    return _pointColor;
}

- (CGFloat)randomDegree {
    CGFloat tmpDgr = _lastDegree/(M_PI/180.f);
    CGFloat degr = (arc4random()%100)+45;//转动的角度至少45度
    if (degr > 65) {
        degr *= -1;
    }else {
        degr *= 1;
    }
    _randomDegree = (tmpDgr+degr) * M_PI/180;
    return _randomDegree;
}


- (CABasicAnimation *)animationWithRotation{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.delegate = self;
    return animation;
}

- (CGFloat)timeForAnimation {
    CGFloat speed = 2*M_PI/3.f;
    CGFloat distance = [self calculateDegree];
    CGFloat time = distance/speed;
    NSLog(@"time:%.2f",time);
    return time;
}

- (CGFloat)calculateDegree {
    //异号相加
    //同号相减
    BOOL ispPlus = _lastDegree * _pointDegree <= 0;
    
    CGFloat from = [self absoluteValue:_lastDegree];
    CGFloat to = [self absoluteValue:_pointDegree];
    from = from/M_PI/180.f > 180 ? from - 180 : from;
    to = to/M_PI/180.f > 180 ? to - 180 : to;
    
    CGFloat value = 0;
    if (ispPlus) {
        value = from + to;
    }else {
        value = from - to;
    }
    CGFloat distance = [self absoluteValue:value];
    NSLog(@"distance:%.2f",distance);
    NSLog(@"last:%.2f,point:%.2f",_lastDegree,_pointDegree);
    return distance;
}

- (CGFloat)absoluteValue:(CGFloat)value {
    CGFloat des = value;
    des =  des >= 0 ? des : des * -1;
    return des;
}

@end

