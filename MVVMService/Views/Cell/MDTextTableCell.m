//
//  MDTextTableCell.m
//  MVVMService
//
//  Created by xulinfeng on 2018/12/5.
//  Copyright © 2018 modool. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "MDTextTableCell.h"

@implementation MDTextTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.layer.masksToBounds = YES;
        
        self.backgroundView = [[UIView alloc] init];
        self.selectedBackgroundView = [[UIView alloc] init];

        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textAlignment = NSTextAlignmentCenter;

        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _titleLabel.frame = self.contentView.bounds;
}

#pragma mark - accessor

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    [self _updateContentView];
}

#pragma mark - private

- (void)_updateContentView {
    _titleLabel.textColor = self.selected ? _viewModel.selectedTextColor : _viewModel.textColor;
}

#pragma mark - public

- (void)bindViewModel:(MDTextItemViewModel *)viewModel {
    _viewModel = viewModel;
    [self _updateContentView];

    RAC(_titleLabel, text) = [RACObserve(viewModel, title) takeUntil:self.rac_prepareForReuseSignal];

    RAC(self.backgroundView, backgroundColor) = [RACObserve(viewModel, backgroundColor) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.selectedBackgroundView, backgroundColor) = [RACObserve(viewModel, selectedBackgroundColor) takeUntil:self.rac_prepareForReuseSignal];

    RAC(self.layer, cornerRadius) = [RACObserve(viewModel, cornerRadius) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.layer, borderWidth) = [RACObserve(viewModel, borderWidth) takeUntil:self.rac_prepareForReuseSignal];
    [[RACObserve(viewModel, borderColor) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(UIColor *borderColor) {
        self.layer.borderColor = borderColor.CGColor;
    }];
}

@end
