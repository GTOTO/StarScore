//
//  ViewController.m
//  StarScore
//
//  Created by G on 2019/6/24.
//  Copyright © 2019 G. All rights reserved.
//

#import "ViewController.h"
#import "StarRateView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    StarRateView *rateView = [[StarRateView alloc] initWithFrame:CGRectMake(20, 100, self.view.frame.size.width - 40, 100) numberOfStar:5 rateStyle:StarRateViewRateStyleIncompleteStar isAnimation:YES completion:^(CGFloat currentScore) {
        NSLog(@"%f", currentScore);
    }];
    
    [self.view addSubview:rateView];
}

@end
