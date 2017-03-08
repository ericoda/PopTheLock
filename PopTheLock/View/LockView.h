//
//  LockView.h
//  PopTheLock
//
//  Created by Eric on 2017/3/1.
//  Copyright © 2017年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@class LockView;
@protocol LockViewDelegate <NSObject>
@optional
- (void)lockViewDidStart:(LockView *)lockView ;

- (void)lockViewDidEnd:(LockView *)lockView;

@end

@interface LockView : UIView
@property (readonly, nonatomic, strong) CAShapeLayer *loopLayer;
@property (readonly, nonatomic, strong) CAShapeLayer *pointLayer;

@property (readonly, nonatomic, assign) CGFloat pointDegree;
@property (readonly, nonatomic, assign) CGFloat lastDegree;

@property (nonatomic, assign)id <LockViewDelegate> delegate;

- (void)showNewPoint;
- (void)showIndicator;
@end
