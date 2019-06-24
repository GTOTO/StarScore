//
//  StarRateView.m
//  StarScore
//
//  Created by G on 19/5/23.
//  Copyright © 2019年 G. All rights reserved.
//

#import "StarRateView.h"


static NSString *const KForegroundStarImage = @"big_star";
static NSString *const KBackgroundStarImage = @"big_no_star";
static const NSInteger KDefaultNumberOfStar = 5;

@interface StarRateView ()

@property(nonatomic, strong, readwrite) UIView *foregroundStarView;
@property(nonatomic, strong, readwrite) UIView *backgroundStarView;
@property(nonatomic, assign, readwrite) NSInteger numberOfStar;
@property(nonatomic, copy) StarRateViewRateCompletionBlock completionBlock;

@end


@implementation StarRateView

// 指定初始化方法
- (instancetype)initWithFrame:(CGRect)frame
                numberOfStar:(NSInteger)numberOfStar
                rateStyle:(StarRateViewRateStyle)rateStyle
                isAnimation:(BOOL)isAnimation
                completion:(StarRateViewRateCompletionBlock)completionBlock
                delegate:(id)delegate
{
    if (self = [super initWithFrame:frame]) {
        _numberOfStar = numberOfStar;
        _rateStyle = rateStyle;
        _isAnimation = isAnimation;
        _completionBlock = completionBlock;
        _delegate = delegate;
        
        [self createStarView];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        if (_numberOfStar == 0) {
            _numberOfStar = KDefaultNumberOfStar;
        }
        
        [self createStarView];
    }
    
    return self;
}

#pragma mark - 代理方式

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame
                 numberOfStar:KDefaultNumberOfStar
                 rateStyle:StarRateViewRateStyleFullStar
                 isAnimation:NO
                 completion:nil
                 delegate:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
                numberOfStar:(NSInteger)numberOfStar
                rateStyle:(StarRateViewRateStyle)rateStyle
                isAnimation:(BOOL)isAnimation
                delegate:(id)delegate
{
    return [self initWithFrame:frame
                 numberOfStar:numberOfStar
                 rateStyle:rateStyle
                 isAnimation:NO
                 completion:nil
                 delegate:delegate];
}

#pragma mark block方式

- (instancetype)initWithFrame:(CGRect)frame
                completion:(StarRateViewRateCompletionBlock)completionBlock
{
    return [self initWithFrame:frame
                 numberOfStar:KDefaultNumberOfStar
                 rateStyle:StarRateViewRateStyleFullStar
                 isAnimation:NO
                 completion:completionBlock
                 delegate:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
                numberOfStar:(NSInteger)numberOfStar
                rateStyle:(StarRateViewRateStyle)rateStyle
                isAnimation:(BOOL)isAnimation
                completion:(StarRateViewRateCompletionBlock)completionBlock
{
    return [self initWithFrame:frame
                 numberOfStar:numberOfStar
                 rateStyle:rateStyle
                 isAnimation:isAnimation
                 completion:completionBlock
                 delegate:nil];
}

- (void)dealloc
{
    self.delegate = nil;
    self.completionBlock = nil;
}

- (void)setCurrentRating:(CGFloat)currentRating {
    if (_currentRating == currentRating) {
        return;
    }
    if (currentRating < 0) {
        _currentRating = 0;
    } else if (currentRating > _numberOfStar) {
        _currentRating = _numberOfStar;
    } else {
        _currentRating = currentRating;
    }
    
    if ([self.delegate respondsToSelector:@selector(starRateView:ratingDidChange:)]) {
        [self.delegate starRateView:self ratingDidChange:_currentRating];
    }
    
    if (self.completionBlock) {
        _completionBlock(_currentRating);
    }
    
    [self setNeedsLayout];
}

- (void)createStarView
{
    self.foregroundStarView = [self createStarViewWithImageNamed:KForegroundStarImage];
    self.backgroundStarView = [self createStarViewWithImageNamed:KBackgroundStarImage];
    
    NSAssert(_numberOfStar != 0, @"The Value Of Rate Star should not be Zero");
    self.foregroundStarView.frame = CGRectMake(0, 0, self.bounds.size.width * _currentRating / _numberOfStar, self.bounds.size.height);
    
    [self addSubview:self.backgroundStarView];
    [self addSubview:self.foregroundStarView];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapRateView:)];
    tapGesture.numberOfTapsRequired = 1;
    
    [self addGestureRecognizer:tapGesture];
}

- (UIView *)createStarViewWithImageNamed:(NSString *)name
{
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
    
    for (NSInteger i = 0; i < _numberOfStar; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
        imageView.frame = CGRectMake(i * self.bounds.size.width / _numberOfStar, 0, self.bounds.size.width / _numberOfStar, self.bounds.size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [view addSubview:imageView];
    }
    
    return view;
}

// 这里面用到了两个数学函数
// ceilf():返回大于或者等于指定表达式的最小整数。
// roundf():返回四舍五入的整数。
- (void)userTapRateView:(UITapGestureRecognizer *)gesture {
    
    CGPoint tapPoint = [gesture locationInView:self];
    CGFloat offset = tapPoint.x;
    CGFloat realRating = offset / (self.bounds.size.width / _numberOfStar);
    
    switch (_rateStyle) {
        case StarRateViewRateStyleFullStar: {
            self.currentRating = ceilf(realRating);
            break;
        }
        case StarRateViewRateStyleHalfStar: {
            float round = roundf(realRating);
            self.currentRating = (round > realRating) ? round : (round + 0.5);
            break;
        }
        case StarRateViewRateStyleIncompleteStar: {
            self.currentRating = realRating;
            break;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat animationDuration = (self.isAnimation ? 0.2 : 0);
    [UIView animateWithDuration:animationDuration animations:^{
        self.foregroundStarView.frame = CGRectMake(0, 0, self.bounds.size.width / self.numberOfStar * self.currentRating, self.bounds.size.height);
    }];
}

@end
