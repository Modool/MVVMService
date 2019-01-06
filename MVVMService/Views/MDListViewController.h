//
//  MDListViewController.h
//  MVVMService
//
//  Created by xulinfeng on 2018/11/27.
//  Copyright © 2018 modool. All rights reserved.
//

#import "MDViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MDScrollViewRefreshing <NSObject>

@property (nonatomic, assign, getter=isServiceRefreshEnabled) BOOL serviceRefreshEnabled;
@property (nonatomic, assign, getter=isServiceInfiniteEnabled) BOOL serviceInfiniteEnabled;

- (void)serviceAddPullToRefreshWithActionHandler:(void (^)(void))handler;
- (void)serviceAddInfiniteScrollingWithActionHandler:(void (^)(void))handler;

- (void)serviceStopRefreshing;
- (void)serviceStopInfiniting;

@end

@protocol MDView;
@class MDListViewModel;
@interface MDListViewController : MDViewController {
@protected
    UIScrollView<MDScrollViewRefreshing> *_scrollView;
}

@property (nonatomic, strong, readonly) MDListViewModel *viewModel;

// The table view for tableView controller.
@property (nonatomic, strong, readonly) UIScrollView<MDScrollViewRefreshing> *scrollView;

- (instancetype)initWithViewModel:(MDListViewModel *)viewModel NS_DESIGNATED_INITIALIZER;

- (void)refresh;
- (void)loadMore;

- (void)registerItemClass:(Class<MDView, NSObject>)class forReuseIdentifier:(NSString *)reuseIdentifier;
- (void)registerHeaderViewClass:(Class<MDView, NSObject>)class forReuseIdentifier:(NSString *)reuseIdentifier;
- (void)registerFooterViewClass:(Class<MDView, NSObject>)class forReuseIdentifier:(NSString *)reuseIdentifier;

- (void)willDisplayCellAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
