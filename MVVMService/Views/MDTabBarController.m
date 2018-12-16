//
//  MDTabBarController.m
//  MVVMService
//
//  Created by xulinfeng on 2018/11/27.
//  Copyright © 2018 modool. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "MDTabBarController.h"
#import "MDMultipleViewModel.h"

#import "MDControllerViewModel+Private.h"

#import "MDService.h"

@interface MDTabBarController () <UITabBarDelegate>

@property (nonatomic, strong, readonly) UITabBarController *tabBarController;

@end

@implementation MDTabBarController
@dynamic viewModel;

- (void)loadView{
    [super loadView];

    _tabBarController = [[UITabBarController alloc] init];
    _tabBarController.tabBar.delegate = self;

    [self addChildViewController:_tabBarController];
    [self.view addSubview:_tabBarController.view];
}

- (void)bindViewModel{
    [super bindViewModel];
    
    RAC(self.viewModel, currentIndex) = RACObserve(_tabBarController, selectedIndex);

    @weakify(self);
    [RACObserve(self.viewModel, viewModels) subscribeNext:^(NSArray<MDControllerViewModel *> *viewModels) {
        @strongify(self);
        NSMutableArray<UINavigationController *> *navigationControllers = [NSMutableArray array];

        for (MDControllerViewModel *viewModel in viewModels) {
            UINavigationController *navigationController = [[UINavigationController alloc] init];
            if (@available(iOS 11, *)) {
                navigationController.navigationBar.prefersLargeTitles = YES;
            }
            navigationController.tabBarItem = [viewModel tabBarItem];

            id<MDService> service = [self.viewModel.service forkServiceWithViewController:navigationController];
            viewModel.service = service;

            UIViewController *viewController = [service viewControllerWithViewModel:viewModel];
            navigationController.viewControllers = @[viewController];

            [navigationControllers addObject:navigationController];
            [self.viewModel.service addService:service];
        }

        [self.tabBarController setViewControllers:navigationControllers.copy animated:YES];
    }];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    _tabBarController.view.frame = self.view.bounds;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    _tabBarController.view.frame = self.view.bounds;
}

#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSUInteger index = [tabBar.items indexOfObject:item];

    [self.viewModel.didSelectCommand execute:@(index)];
}

@end

@implementation MDTabBarController (MDVisibleViewController)

- (UIViewController*)selectedViewController {
    return _tabBarController.selectedViewController;
}

@end
