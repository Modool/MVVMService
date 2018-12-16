//
//  MDDoubleTitleView.m
//  MVVMService
//
//  Created by xulinfeng on 2018/11/27.
//  Copyright © 2018 modool. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "MDDoubleTitleView.h"

@interface MDDoubleTitleView () 
@end

@implementation MDDoubleTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _createSubviews];
        [self _initializeSubviews];
        [self _layoutSubviews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self _layoutSubviews];
}

#pragma mark - accessor

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];

    [self _layoutSubviews];
}

#pragma mark - private

- (void)_createSubviews {
    _titleLabel = [[UILabel alloc] init];
    _subtitleLabel = [[UILabel alloc] init];

    [self addSubview:_titleLabel];
    [self addSubview:_subtitleLabel];

    @weakify(self);
    RACSignal *titleLabelSignal = [RACObserve(_titleLabel, text) doNext:^(id x) {
        @strongify(self);
        [self.titleLabel sizeToFit];
    }];
    RACSignal *subtitleLabelSignal = [RACObserve(_subtitleLabel, text) doNext:^(id x) {
        @strongify(self);
        [self.subtitleLabel sizeToFit];
    }];

    [[RACSignal combineLatest:@[titleLabelSignal, subtitleLabelSignal]] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        self.frame = CGRectMake(0, 0, MAX(CGRectGetWidth(self.titleLabel.frame), CGRectGetWidth(self.subtitleLabel.frame)), 44);
    }];
}

- (void)_initializeSubviews {
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = UIColor.whiteColor;

    _subtitleLabel.font = [UIFont systemFontOfSize:15];
    _subtitleLabel.textAlignment = NSTextAlignmentCenter;
    _subtitleLabel.textColor = UIColor.whiteColor;
}

- (void)_layoutSubviews {
    CGFloat contentWidth = CGRectGetWidth(self.frame);
    CGFloat contentHeight = CGRectGetHeight(self.frame);

    CGRect titleLabelFrame = _titleLabel.frame;
    CGFloat titleWidth = CGRectGetWidth(titleLabelFrame);

    titleLabelFrame.size.width = MIN(titleWidth, contentWidth);
    titleLabelFrame.origin.x = contentWidth / 2 - titleWidth / 2;
    titleLabelFrame.origin.y = 4;
    _titleLabel.frame = titleLabelFrame;

    CGRect subtitleLabelFrame = _subtitleLabel.frame;
    CGFloat subtitleWidth = CGRectGetWidth(subtitleLabelFrame);
    CGFloat subtitleHeight = CGRectGetHeight(subtitleLabelFrame);

    subtitleLabelFrame.size.width = MIN(subtitleWidth, contentWidth);
    subtitleLabelFrame.origin.x = contentWidth / 2 - subtitleWidth / 2;
    subtitleLabelFrame.origin.y = contentHeight - 4 - subtitleHeight;
    _subtitleLabel.frame = subtitleLabelFrame;
}

@end
