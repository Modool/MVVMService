//
//  MDViewController.m
//  MVVMService
//
//  Created by xulinfeng on 2018/11/27.
//  Copyright © 2018 modool. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "MDViewController.h"
#import "UIViewController+SafeArea.h"

#import "MDControllerViewModel.h"
#import "MDControllerViewModel+Private.h"

#import "MDDoubleTitleView.h"
#import "MDLoadingTitleView.h"

@implementation MDViewController{
    UIEdgeInsets _safeContentInsets;
}

@synthesize viewModel = _viewModel;

- (instancetype)initWithViewModel:(MDControllerViewModel *)viewModel {
    NSAssert(viewModel, @"View model must be nonull.");
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _viewModel = viewModel;
        self.title = viewModel.title;
        self.tabBarItem = viewModel.tabBarItem;

        @weakify(self);
        [[self rac_signalForSelector:@selector(loadView)] subscribeNext:^(id x) {
            [viewModel loadView];
        }];
        [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
            @strongify(self);
            [self bindViewModel];
            [viewModel viewDidLoad];
        }];
        [[self rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
            [viewModel viewWillAppear];
        }];
        [[self rac_signalForSelector:@selector(viewDidAppear:)] subscribeNext:^(id x) {
            [viewModel viewDidAppear];
        }];
        [[self rac_signalForSelector:@selector(viewWillDisappear:)] subscribeNext:^(id x) {
            [viewModel viewWillDisappear];
        }];
        [[self rac_signalForSelector:@selector(viewDidDisappear:)] subscribeNext:^(id x) {
            [viewModel viewDidDisappear];
        }];
    }
    return self;
}

- (void)loadView{
    [super loadView];

    self.view.backgroundColor = [UIColor whiteColor];

    if (@available(iOS 11, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    }
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] init];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    [self _updateSafeContentInsetsIfNeeds];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    [self _updateSafeContentInsetsIfNeeds];
}

- (void)dealloc {
    _viewModel = nil;
}

#pragma mark - accessor

- (void)setContentInsetAdjustmentBehavior:(MDViewControllerContentInsetAdjustmentBehavior)contentInsetAdjustmentBehavior {
    _contentInsetAdjustmentBehavior = contentInsetAdjustmentBehavior;

    self.automaticallyAdjustsScrollViewInsets = contentInsetAdjustmentBehavior != MDViewControllerContentInsetAdjustmentNever;
}

- (UIEdgeInsets)safeContentInsets {
    if (UIEdgeInsetsEqualToEdgeInsets(_safeContentInsets, UIEdgeInsetsZero)) {
        _safeContentInsets = [super safeContentInsets];
    }
    return _safeContentInsets;
}

#pragma mark - private

- (void)_updateSafeContentInsetsIfNeeds {
    UIEdgeInsets insets = [super safeContentInsets];
    if (UIEdgeInsetsEqualToEdgeInsets(_safeContentInsets, insets)) return;

    _safeContentInsets = insets;

    [self viewSafeContentInsetsDidChange];
}

#pragma mark - protected

- (void)viewSafeContentInsetsDidChange {}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];

    [self viewSafeContentInsetsDidChange];
}

#pragma mark - public

- (void)bindViewModel {
    @weakify(self);
    [self.viewModel.keyPathAndValues enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        @strongify(self);
        [self setValue:value forKeyPath:key];
    }];

    // System title view
    RAC(self, title) = RACObserve(self.viewModel, title);
    UIView *titleView = self.navigationItem.titleView;

    // Double title view
    MDDoubleTitleView *doubleTitleView = [MDDoubleTitleView new];
    RAC(doubleTitleView.titleLabel, text)    = RACObserve(self.viewModel, title);
    RAC(doubleTitleView.subtitleLabel, text) = RACObserve(self.viewModel, subtitle);

    @weakify(doubleTitleView);
    [[self rac_signalForSelector:@selector(viewWillTransitionToSize:withTransitionCoordinator:)] subscribeNext:^(id x) {
        @strongify(self, doubleTitleView);
        doubleTitleView.titleLabel.text    = self.viewModel.title;
        doubleTitleView.subtitleLabel.text = self.viewModel.subtitle;
    }];

    // Loading title view
    MDLoadingTitleView *loadingTitleView = [[MDLoadingTitleView alloc] initWithLoadingText:self.viewModel.title];
    @weakify(loadingTitleView);
    RAC(self.navigationItem, titleView) = [[RACObserve(self.viewModel, titleViewType) distinctUntilChanged] map:^(NSNumber *value) {
        @strongify(doubleTitleView, loadingTitleView);
        MDTitleViewType titleViewType = [value unsignedIntegerValue];
        switch (titleViewType) {
            case MDTitleViewTypeDefault:
                return titleView;
            case MDTitleViewTypeDoubleTitle:
                return (UIView *)doubleTitleView;
            case MDTitleViewTypeLoadingTitle:
                return (UIView *)loadingTitleView;
        }
    }];
}

@end


