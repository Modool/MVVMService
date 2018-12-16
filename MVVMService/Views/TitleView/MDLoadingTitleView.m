//
//  MDLoadingTitleView.m
//  MVVMService
//
//  Created by xulinfeng on 2018/11/27.
//  Copyright © 2018 modool. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "MDLoadingTitleView.h"

@interface MDLoadingTitleView ()

@property (nonatomic, strong, readonly) UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic, strong, readonly) UILabel *loadingLabel;

@end

@implementation MDLoadingTitleView

+ (instancetype)titleViewWithLoadingText:(NSString *)loadingText{
    return [[self alloc] initWithLoadingText:loadingText];
}

- (instancetype)initWithLoadingText:(NSString *)loadingText{
    if (self = [super initWithFrame:CGRectZero]) {
        _loadingText = loadingText;
        
        [self _createSubviews];
        [self _initializeSubviews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self _layoutSubviews];
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];

    [[self activityIndicatorView] startAnimating];
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];

    if (!newSuperview) [[self activityIndicatorView] stopAnimating];
}

#pragma mark - accessor

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];

    [self _layoutSubviews];
}

#pragma mark - private

- (void)_createSubviews {
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _loadingLabel = [[UILabel alloc] init];

    [self addSubview:_activityIndicatorView];
    [self addSubview:_loadingLabel];

    @weakify(self);
    RACSignal *loadingLabelSignal = [RACObserve(_loadingLabel, text) doNext:^(id x) {
        @strongify(self);
        [self.loadingLabel sizeToFit];
    }];
    RACSignal *activityIndicatorViewSignal = [RACObserve(_activityIndicatorView, activityIndicatorViewStyle) doNext:^(id x) {
        @strongify(self);
        [self.activityIndicatorView sizeToFit];
    }];
    [[RACSignal combineLatest:@[loadingLabelSignal, activityIndicatorViewSignal ]] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        self.frame = CGRectMake(0, 0, CGRectGetWidth([[self loadingLabel] frame]) + CGRectGetWidth([[self activityIndicatorView] frame]) + 4, 44);
    }];
}

- (void)_initializeSubviews {
    _loadingLabel.font = [UIFont boldSystemFontOfSize:17];
    _loadingLabel.textAlignment = NSTextAlignmentCenter;
    _loadingLabel.textColor = UIColor.whiteColor;

    _loadingLabel.text = [self loadingText] ?: @"加载中...";
    _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
}

- (void)_layoutSubviews{
    CGFloat contentWidth = CGRectGetWidth(self.frame);
    CGFloat contentHeight = CGRectGetHeight(self.frame);

    CGRect activityIndicatorViewFrame = _activityIndicatorView.frame;
    activityIndicatorViewFrame.origin.y = contentHeight / 2 - CGRectGetHeight(activityIndicatorViewFrame) / 2;
    activityIndicatorViewFrame.origin.x = 0;
    _activityIndicatorView.frame = activityIndicatorViewFrame;

    CGRect loadingLabelFrame = _loadingLabel.frame;
    loadingLabelFrame.size.width = MIN(CGRectGetWidth(loadingLabelFrame), contentWidth - CGRectGetWidth(activityIndicatorViewFrame) - 4);
    loadingLabelFrame.origin.x = CGRectGetWidth(activityIndicatorViewFrame) + 4;
    loadingLabelFrame.origin.y = contentHeight / 2 - CGRectGetHeight(loadingLabelFrame) / 2;
    _loadingLabel.frame = loadingLabelFrame;
}

@end
