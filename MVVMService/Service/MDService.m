//
//  MDService.m
//  MVVMService
//
//  Created by xulinfeng on 2018/11/27.
//  Copyright © 2018 modool. All rights reserved.
//

#import <objc/runtime.h>

#import <UIKit/UIKit.h>

#import "MDService.h"

#import "MDViewController.h"

#import "MDService+Private.h"
#import "MDUIService.h"

#import "MDControllerViewModel+Private.h"

NSString * const MDServiceErrorDomain = @"com.modool.mvvm.service.error.domain";

@implementation MDService
@synthesize viewController = _viewController, parentService = _parentService;

- (instancetype)initWithDataService:(id)dataService {
    return [self initWithViewController:nil dataService:dataService];
}

- (instancetype)initWithViewController:(UIViewController *)viewController dataService:(id)dataService {
    if (self = [super init]) {
        _viewController = viewController;
        if (viewController) viewController.MVVMService = self;

        _services = (id)[NSHashTable<MDServicePrivate> weakObjectsHashTable];

        _dataService = dataService;
        _UIService = [[MDUIService alloc] initWithService:self];
    }
    return self;
}

#pragma mark - accessor

- (NSArray<MDService> *)services {
    return (id)[_services allObjects];
}

- (id<MDService>)topService {
    return self.services.lastObject ?: self;
}

- (UINavigationController *)navigationController {
    UIViewController *viewController = _viewController;

    if (!viewController) viewController = _parentService.navigationController;
    if ([viewController isKindOfClass:[UINavigationController class]]) return (UINavigationController *)viewController;

    return viewController.navigationController;
}

#pragma mark - protected

- (void)addService:(id<MDServicePrivate>)service {
    NSParameterAssert(service && ![_services containsObject:service]);

    service.parentService = self;
    [_services addObject:service];
}

- (void)removeService:(id<MDServicePrivate>)service {
    NSParameterAssert(service);

    [_services removeObject:service];
    service.parentService = nil;
}

- (void)removeFromParentService {
    [_parentService removeService:self];
}

#pragma mark - public

- (UIViewController<MDViewController, MDControllerViewModelUIDelegate> *)viewControllerWithViewModel:(MDControllerViewModel *)viewModel {
    Class class = [viewModel viewControllerClass];
    UIViewController<MDViewController, MDControllerViewModelUIDelegate> *viewController = [[class alloc] initWithViewModel:viewModel];

    viewModel.viewController = viewController;
    viewModel.UIDelegate = viewController;

    return viewController;
}

- (UIViewController *)presentingControllerWithViewModel:(MDControllerViewModel *)viewModel navigating:(BOOL)navigating{
    if (!viewModel) return nil;

    id<MDService> service = (id)viewModel.service;
    if (service != self && ![service isKindOfClass:MDPassthroughService.class]) return nil;

    UIViewController *viewController = [self viewControllerWithViewModel:viewModel];
    if (!viewController) return nil;

    Class serviceClass = navigating ? MDNavigationService.class : MDService.class;
    MDService *presentService = [[serviceClass alloc] initWithDataService:_dataService];
    [self addService:presentService];

    if (service == self) {
        viewModel.service = presentService;
    } else {
        viewModel.service = [self serviceWithViewModel:viewModel referenceService:presentService];
    }
    if (navigating) viewController = [[UINavigationController alloc] initWithRootViewController:viewController];

    viewController.MVVMService = presentService;
    presentService.viewController = viewController;
    return viewController;
}

- (id<MDService>)serviceWithViewModel:(MDControllerViewModel *)viewModel referenceService:(id<MDService>)service {
    MDPassthroughService *passthroughService = (MDPassthroughService *)viewModel.service;
    if (passthroughService.referencedService) {
        return [[MDPassthroughService alloc] initWithReferencedService:service];
    } else {
        passthroughService.referencedService = service;
    }
    return passthroughService;
}

- (UIViewController *)navigatingViewControllerWithViewModel:(MDControllerViewModel *)viewModel {
    return [self navigatingViewControllerWithViewModel:viewModel targetService:self];
}

- (UIViewController *)navigatingViewControllerWithViewModel:(MDControllerViewModel *)viewModel targetService:(id<MDService>)service {
    if (viewModel.service != service && ![viewModel.service isKindOfClass:MDPassthroughService.class]) return nil;

    UIViewController *viewController = [service viewControllerWithViewModel:viewModel];
    if (!viewController) return nil;

    if (viewModel.service != service) {
        viewModel.service = [self serviceWithViewModel:viewModel referenceService:service];
    }

    return viewController;
}

- (void)showViewModel:(MDControllerViewModel *)viewModel {
    [self showViewModel:viewModel detail:NO referencedViewController:self.viewController];
}

- (void)showViewModel:(MDControllerViewModel *)viewModel referencedViewModel:(MDControllerViewModel *)referencedViewModel {
    [self showViewModel:viewModel detail:NO referencedViewController:referencedViewModel.viewController];
}

- (void)showDetailViewModel:(MDControllerViewModel *)viewModel {
    [self showViewModel:viewModel detail:YES referencedViewController:self.viewController];
}

- (void)showDetailViewModel:(MDControllerViewModel *)viewModel referencedViewModel:(MDControllerViewModel *)referencedViewModel {
    [self showViewModel:viewModel detail:YES referencedViewController:referencedViewModel.viewController];
}

- (void)showViewModel:(MDControllerViewModel *)viewModel detail:(BOOL)detail referencedViewController:(UIViewController *)referencedViewController {
    UIViewController *viewController = [self navigatingViewControllerWithViewModel:viewModel];
    if (!viewController) return;

    [_UIService showViewController:viewController detail:detail referencedViewController:referencedViewController];
}

- (void)pushViewModel:(MDControllerViewModel *)viewModel animated:(BOOL)animated {
    UIViewController *viewController = [self navigatingViewControllerWithViewModel:viewModel];
    if (!viewController) return;

    [_UIService pushViewController:viewController animated:animated];
}

- (void)pushViewModel:(MDControllerViewModel *)viewModel replacingAtIndex:(NSUInteger)index animated:(BOOL)animated {
    id<MDService> navigationService = self.navigationController.MVVMService;
    id<MDService> targetService = navigationService == self ? self : navigationService;

    UIViewController *viewController = [self navigatingViewControllerWithViewModel:viewModel targetService:targetService];
    if (!viewController) return;

    [_UIService pushViewController:viewController replacingAtIndex:index animated:animated];
}

- (void)popViewModelAnimated:(BOOL)animated {
    [_UIService popViewControllerAnimated:animated];
}

- (void)popToViewModel:(MDControllerViewModel *)viewModel animated:(BOOL)animated {
    [_UIService popToViewController:viewModel.viewController animated:animated];
}

- (void)popToRootViewModelAnimated:(BOOL)animated {
    [_UIService popToRootViewControllerAnimated:animated];
}

- (void)presentViewModel:(MDControllerViewModel *)viewModel animated:(BOOL)animated completion:(void (^)(void))completion {
    UIViewController *viewController = [self presentingControllerWithViewModel:viewModel navigating:NO];
    if (!viewController) return;

    [_UIService presentViewController:viewController animated:animated completion:completion];
}

- (void)presentNavigationWithRootViewModel:(MDControllerViewModel *)viewModel animated:(BOOL)animated completion:(void (^)(void))completion {
    UIViewController *viewController = [self presentingControllerWithViewModel:viewModel navigating:YES];
    if (!viewController) return;

    [_UIService presentViewController:viewController animated:animated completion:completion];
}

- (void)dismissViewModelAnimated:(BOOL)animated completion:(void (^)(void))completion {
    [_UIService dismissViewControllerAnimated:animated completion:completion];
}

- (void)resetRootViewModel:(MDControllerViewModel *)viewModel {
    UIViewController *viewController = [self viewControllerWithViewModel:viewModel];
    if (!viewController) return;

    [_UIService resetRootViewController:viewController];
}

- (void)resetRootNavigationWithViewModel:(MDControllerViewModel *)viewModel {
    UIViewController *viewController = [self presentingControllerWithViewModel:viewModel navigating:YES];
    if (!viewController) return;

    [_UIService resetRootViewController:viewController];
}

@end

@implementation MDService (MDDataServiceForwarding)

#pragma mark - protected

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return _dataService;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([super respondsToSelector:aSelector]) return YES;
    
    return [_dataService respondsToSelector:aSelector];
}

@end

@implementation MDPassthroughService

- (instancetype)initWithReferencedService:(id<MDService>)referencedService {
    if (self = [self init]) {
        _referencedService = referencedService;
    }
    return self;
}

#pragma mark - protected

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return _referencedService;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([super respondsToSelector:aSelector]) return YES;
    
    return [_referencedService respondsToSelector:aSelector];
}

@end

@implementation MDNavigationService
@end

@implementation MDSplitService
@end

@implementation MDRootService

@end

@implementation MDRootNavigationService

@end

@implementation MDService (Initializer)

+ (id<MDService>)serviceWithNavigationController:(UINavigationController *)navigationController dataService:(id)dataService {
    NSParameterAssert([navigationController isKindOfClass:UINavigationController.class]);

    MDRootNavigationService *service = (id)navigationController.MVVMService;
    if (service) return service;

    return [[MDRootNavigationService alloc] initWithViewController:navigationController dataService:dataService];
}

+ (id<MDService>)serviceWithSplitViewController:(UISplitViewController *)splitViewController dataService:(id)dataService {
    NSParameterAssert([splitViewController isKindOfClass:UISplitViewController.class]);

    MDSplitService *service = (id)splitViewController.MVVMService;
    if (service) return service;

    return [[MDSplitService alloc] initWithViewController:splitViewController dataService:dataService];
}

@end

@implementation MDService (Inconclusive)

+ (id<MDService>)serviceWithViewController:(UIViewController *)viewController dataService:(id)dataService {
    MDRootService *service = (id)viewController.MVVMService;
    if (service) return service;

    if ([viewController isKindOfClass:UINavigationController.class]) {
        return [self serviceWithNavigationController:(id)viewController dataService:dataService];
    }

    if ([viewController isKindOfClass:UISplitViewController.class]) {
        return [self serviceWithSplitViewController:(id)viewController dataService:dataService];
    }

    return [[MDRootService alloc] initWithViewController:viewController dataService:dataService];
}

@end

@implementation MDService (Fork)

- (id<MDService>)forkServiceWithViewController:(UIViewController *)viewController {
    return [[[self class] alloc] initWithViewController:viewController dataService:_dataService];
}

@end

@implementation UIViewController (MDUIService)

- (void)setMVVMService:(id<MDService>)MVVMService {
    objc_setAssociatedObject(self, @selector(MVVMService), MVVMService, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<MDService>)MVVMService {
    return objc_getAssociatedObject(self, @selector(MVVMService));
}

@end
