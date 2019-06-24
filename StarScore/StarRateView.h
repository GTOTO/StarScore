//
//  StarRateView.h
//  StarScore
//
//  Created by G on 19/5/23.
//  Copyright © 2019年 G. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^StarRateViewRateCompletionBlock)(CGFloat currentScore);

typedef NS_ENUM(NSUInteger, StarRateViewRateStyle) {
    StarRateViewRateStyleFullStar, // 满星
    StarRateViewRateStyleHalfStar, // 半星
    StarRateViewRateStyleIncompleteStar // 任意星
};

@class StarRateView;
@protocol StarRateViewDelegate <NSObject>

@optional
- (void)starRateView:(StarRateView *)starRateView ratingDidChange:(CGFloat)currentRating;

@end

@interface StarRateView : UIView

@property(nonatomic, assign) BOOL isAnimation; // 默认为NO
@property(nonatomic, assign) StarRateViewRateStyle rateStyle;
@property(nonatomic, assign) CGFloat currentRating; // 当前评分
@property(nonatomic, weak) id<StarRateViewDelegate> delegate;


/**
 通过代理方法获取当前评分
 */
- (instancetype)initWithFrame:(CGRect)frame;

- (instancetype)initWithFrame:(CGRect)frame
                numberOfStar:(NSInteger)numberOfStar
                rateStyle:(StarRateViewRateStyle)rateStyle
                isAnimation:(BOOL)isAnimation
                delegate:(id)delegate;

/**
 通过Block方法获取当前评分
 */
- (instancetype)initWithFrame:(CGRect)frame
                completion:(StarRateViewRateCompletionBlock)completionBlock;

- (instancetype)initWithFrame:(CGRect)frame
                 numberOfStar:(NSInteger)numberOfStar
                    rateStyle:(StarRateViewRateStyle)rateStyle
                  isAnimation:(BOOL)isAnimation
                   completion:(StarRateViewRateCompletionBlock)completionBlock;

@end
