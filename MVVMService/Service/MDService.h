//
//  MDService.h
//  MVVMService
//
//  Created by xulinfeng on 2018/11/27.
//  Copyright © 2018 modool. All rights reserved.
//

#import "MDNavigationProtocol.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString * const MDServiceErrorDomain;

@class MDControllerViewModel;
@protocol MDViewController, MDService;

@protocol MDMultipleService <NSObject>
@optional
@property (nonatomic, weak, readonly, nullable) id<MDService> parentService;

@property (nonatomic, copy, readonly, nullable) NSArray<MDService> *services;
@property (nonatomic, strong, readonly, nullable) id<MDService> topService;

- (void)addService:(id<MDService>)service;
- (void)removeService:(id<MDService>)service;

- (void)removeFromParentService;

@end

@class UIViewController;
@protocol MDService <MDMultipleService, MDNavigationProtocol>

@optional
- (UIViewController<MDViewController> *)viewControllerWithViewModel:(MDControllerViewModel *)viewModel;

- (id<MDService>)forkServiceWithViewController:(UIViewController *)viewController;

@end

@interface MDService<__covariant DataServiceType> : NSObject <MDService> {
    DataServiceType _dataService;
}

@property (nonatomic, weak, nullable, readonly) UIViewController *viewController;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataService:(nullable DataServiceType)dataService;
- (instancetype)initWithViewController:(nullable UIViewController *)viewController dataService:(nullable DataServiceType)dataService NS_DESIGNATED_INITIALIZER;

@end

@interface MDPassthroughService : NSObject <MDService>

- (instancetype)initWithReferencedService:(id<MDService>)referencedService;

@end

@class UINavigationController, UISplitViewController;
@interface MDService<__covariant DataServiceType> (Initializer)

+ (id<MDService>)serviceWithNavigationController:(UINavigationController *)navigationController dataService:(DataServiceType)dataService;
+ (id<MDService>)serviceWithSplitViewController:(UISplitViewController *)splitViewController dataService:(DataServiceType)dataService;

@end

@interface MDService<__covariant DataServiceType> (Inconclusive)

+ (id<MDService>)serviceWithViewController:(UIViewController *)viewController dataService:(DataServiceType)dataService;

@end

NS_ASSUME_NONNULL_END
