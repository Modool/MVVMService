//
//  MDUIService.h
//  MVVMService
//
//  Created by xulinfeng on 2018/11/27.
//  Copyright © 2018 modool. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MDViewControllerService, MDViewController;
@protocol MDUIService <NSObject>

@property (nonatomic, weak, readonly) id<MDViewControllerService> service;

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)pushViewController:(UIViewController *)viewController replacingAtIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)showViewController:(UIViewController *)viewController detail:(BOOL)detail referencedViewController:(UIViewController *)referencedViewController;

- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated;
- (nullable NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (nullable NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated;

- (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;

- (UIViewController *)dismissViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;

- (void)resetRootViewController:(UIViewController *)viewController;

@end

@interface MDUIService : NSObject <MDUIService>

- (instancetype)initWithService:(id<MDViewControllerService>)service;

@end

NS_ASSUME_NONNULL_END
