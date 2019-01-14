//
//  MDControllerProtocol.h
//  MVVMService
//
//  Created by xulinfeng on 2018/11/27.
//  Copyright © 2018 modool. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MDControllerViewModel;
@protocol MDControllerProtocol <NSObject>

@optional

/**
 Present the corresponding view controller.

 @param viewModel the view model
 @param animated use animation or not
 @param completion the completion handler
 */
- (void)presentViewModel:(MDControllerViewModel *)viewModel animated:(BOOL)animated completion:(nullable void (^)(void))completion;

/**
 Present the corresponding view controller with auto-create navigation controller.

 @param viewModel the view model
 @param animated use animation or not
 @param completion the completion handler
 */
- (void)presentNavigationWithRootViewModel:(MDControllerViewModel *)viewModel animated:(BOOL)animated completion:(nullable void (^)(void))completion;

/**
 Dismiss the presented view controller.

 @param animated use animation or not
 @param completion the completion handler
 */
- (void)dismissViewModelAnimated:(BOOL)animated completion:(nullable void (^)(void))completion;

/**
 Reset the corresponding view controller as the root view controller of the application's window.

 @param viewModel viewModel - the view model
 */
- (void)resetRootViewModel:(MDControllerViewModel *)viewModel;

/**
 Reset the corresponding view controller with navigation controller
 as the root view controller of the application's window.

 @param viewModel the view model
 */
- (void)resetRootNavigationWithViewModel:(MDControllerViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
