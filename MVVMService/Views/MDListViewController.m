//
//  MDListViewController.m
//  MVVMService
//
//  Created by xulinfeng on 2018/11/27.
//  Copyright © 2018 modool. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "MDListViewController.h"

#import "MDListViewModel.h"

@implementation MDListViewController
@synthesize scrollView = _scrollView;
@dynamic viewModel;

- (instancetype)initWithViewModel:(MDListViewModel *)viewModel {
    NSAssert(viewModel, @"View model must be nonull.");
    if (self = [super initWithViewModel:viewModel]) {
        @weakify(viewModel);
        [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
            @strongify(viewModel);
            if ([viewModel shouldRequestRemoteDataOnViewDidLoad]) {
                [[viewModel requestDataCommand] execute:@(viewModel.firstPage)];
            }
        }];
    }
    return self;
}

- (void)loadView{
    [super loadView];

    if (!_scrollView) self.view = self.scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.contentInsetAdjustmentBehavior = MDViewControllerContentInsetAdjustmentAutomatic;

    @weakify(self);
    if (self.viewModel.allowedPullToRefresh) {
        [_scrollView serviceAddPullToRefreshWithActionHandler:^{
            @strongify(self);
            [self didTriggerRefresh];
        }];
    }
    if (self.viewModel.allowedPullToLoadMore) {
        [_scrollView serviceAddInfiniteScrollingWithActionHandler:^{
            @strongify(self);
            [self didTriggerLoadMore];
        }];

        RAC(_scrollView, serviceInfiniteEnabled) = RACObserve(self.viewModel, loadMoreEnabled);
    }
}

- (void)dealloc {
    _scrollView = nil;
}

#pragma mark - accessor

- (void)setView:(UIView *)view {
    [super setView:view];

    if ([view isKindOfClass:UIScrollView.class]) {
        _scrollView = (UIScrollView<MDScrollViewRefreshing> *)view;
    }
}

- (void)setContentInsetAdjustmentBehavior:(MDViewControllerContentInsetAdjustmentBehavior)contentInsetAdjustmentBehavior {
    [super setContentInsetAdjustmentBehavior:contentInsetAdjustmentBehavior];

    if (@available(iOS 11, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = (UIScrollViewContentInsetAdjustmentBehavior)contentInsetAdjustmentBehavior;
    }
}

#pragma mark - protected

- (void)bindViewModel {
    [super bindViewModel];

    @weakify(self);
    [RACObserve(self.viewModel, headerClasses) subscribeNext:^(NSDictionary<NSString *, Class<MDView, NSObject>> *headerClasses) {
        @strongify(self);
        for (NSString *identifier  in headerClasses.allKeys) {
            [self registerHeaderViewClass:headerClasses[identifier] forReuseIdentifier:identifier];
        }
    }];

    [RACObserve(self.viewModel, footerClasses) subscribeNext:^(NSDictionary<NSString *, Class<MDView, NSObject>> *footerClasses) {
        @strongify(self);
        for (NSString *identifier  in footerClasses.allKeys) {
            [self registerFooterViewClass:footerClasses[identifier] forReuseIdentifier:identifier];
        }
    }];

    [RACObserve(self.viewModel, itemClasses) subscribeNext:^(NSDictionary<Class<MDListItem>, Class<MDView, NSObject>> *itemClasses) {
        @strongify(self);
        for (Class<MDListItem> class  in itemClasses.allKeys) {
            if (![class respondsToSelector:@selector(identifier)]) continue;

            [self registerItemClass:itemClasses[class] forReuseIdentifier:[class identifier]];
        }
    }];

    if (self.viewModel.allowedPullToRefresh) {
        [[self.viewModel rac_signalForSelector:@selector(refresh)] subscribeNext:^(id x) {
            @strongify(self);
            [self refresh];
        }];
    }

    if (self.viewModel.allowedPullToLoadMore) {
        [[self.viewModel rac_signalForSelector:@selector(loadMore)] subscribeNext:^(id x) {
            @strongify(self);
            [self loadMore];
        }];
    }
}

#pragma mark - public

- (void)reloadData {
    if ([_scrollView respondsToSelector:@selector(reloadData)]) {
        [_scrollView performSelector:@selector(reloadData)];
    }
}

- (void)refresh {
    @weakify(self);
    [[[self.viewModel.requestDataCommand execute:@1] deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self);
        self.viewModel.page = self.viewModel.firstPage;
        self.viewModel.dataSource = nil;
    } error:^(NSError *error) {
        @strongify(self);
        [self.scrollView serviceStopRefreshing];
    } completed:^{
        @strongify(self);
        [self.scrollView serviceStopRefreshing];
    }];
}

- (void)loadMore {
    @weakify(self);
    NSUInteger page = self.viewModel.page + self.viewModel.pageOffset;
    [[[[self.viewModel requestDataCommand] execute:@(page)] deliverOnMainThread] subscribeNext:^(NSArray *results) {
        @strongify(self);
        self.viewModel.page = page;
    } error:^(NSError *error) {
        @strongify(self);
        [self.scrollView serviceStopInfiniting];
    } completed:^{
        @strongify(self);
        [self.scrollView serviceStopInfiniting];
    }];
}

- (void)registerItemClass:(Class<MDView, NSObject>)class forReuseIdentifier:(NSString *)reuseIdentifier {}
- (void)registerHeaderViewClass:(Class<MDView, NSObject>)class forReuseIdentifier:(NSString *)reuseIdentifier {}
- (void)registerFooterViewClass:(Class<MDView, NSObject>)class forReuseIdentifier:(NSString *)reuseIdentifier {}

- (void)willDisplayCellAtIndexPath:(NSIndexPath *)indexPath {}

#pragma mark - actions

- (IBAction)didTriggerRefresh{
    [_scrollView serviceStopRefreshing];

    [self refresh];
}

- (IBAction)didTriggerLoadMore{
    [_scrollView serviceStopInfiniting];

    [self loadMore];
}

@end
