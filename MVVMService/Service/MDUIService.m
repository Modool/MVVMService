//
//  MDUIService.m
//  MVVMService
//
//  Created by xulinfeng on 2018/11/27.
//  Copyright © 2018 modool. All rights reserved.
//

#import "MDUIService.h"
#import "MDService+Private.h"

#import "MDViewController.h"

@implementation MDUIService
@synthesize service = _service;

- (instancetype)initWithService:(id<MDViewControllerService>)service {
    if (self = [super init]) {
        _service = service;
    }
    return self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UINavigationController *navigationController = [_service navigationController];
    if (!navigationController || ![navigationController isKindOfClass:[UINavigationController class]]) return;

    [navigationController pushViewController:viewController animated:animated];
}

- (void)pushViewController:(UIViewController *)viewController replacingAtIndex:(NSUInteger)index animated:(BOOL)animated {
    UINavigationController *navigationController = [_service navigationController];
    if (!navigationController || ![navigationController isKindOfClass:[UINavigationController class]]) return;

    [navigationController pushViewController:viewController animated:animated];
}

- (void)showViewController:(UIViewController *)viewController detail:(BOOL)detail referencedViewController:(UIViewController *)referencedViewController {
    if (detail) {
        [referencedViewController showDetailViewController:viewController sender:nil];
    } else {
        [referencedViewController showViewController:viewController sender:nil];
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UINavigationController *navigationController = [_service navigationController];

    if (!navigationController || ![navigationController isKindOfClass:[UINavigationController class]]) return nil;
    if (navigationController.viewControllers.count <= 1) return nil;

    return [navigationController popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UINavigationController *navigationController = [_service navigationController];

    if (!navigationController || ![navigationController isKindOfClass:[UINavigationController class]]) return nil;
    if (![navigationController.viewControllers containsObject:viewController]) return nil;

    return [navigationController popToViewController:viewController animated:animated];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    UINavigationController *navigationController = [_service navigationController];
    if (!navigationController || navigationController.viewControllers.count <= 1) return nil;

    return [navigationController popToRootViewControllerAnimated:animated];
}

- (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion {
    UIViewController *presentingViewController = [_service viewController];
    if (!presentingViewController) return;

    [presentingViewController presentViewController:viewController animated:animated completion:completion];
}

- (UIViewController *)dismissViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion {
    UIViewController<MDViewController> *presentingViewController = (id)_service.viewController;
    [presentingViewController dismissViewControllerAnimated:animated completion:completion];

    return presentingViewController;
}

- (void)resetRootViewController:(UIViewController *)viewController {
    UIApplication.sharedApplication.delegate.window.rootViewController = viewController;
}

@end
