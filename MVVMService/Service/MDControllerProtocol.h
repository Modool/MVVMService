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
/// Present the corresponding view controller.
///
/// viewModel  - the view model
/// animated   - use animation or not
/// completion - the completion handler
- (void)presentViewModel:(MDControllerViewModel *)viewModel animated:(BOOL)animated completion:(nullable void (^)(void))completion;

/// Present the corresponding view controller with auto-create navigation controller.
///
/// viewModel  - the view model
/// animated   - use animation or not
/// completion - the completion handler
- (void)presentNavigationWithRootViewModel:(MDControllerViewModel *)viewModel animated:(BOOL)animated completion:(nullable void (^)(void))completion;

/// Dismiss the presented view controller.
///
/// animated   - use animation or not
/// completion - the completion handler
- (void)dismissViewModelAnimated:(BOOL)animated completion:(nullable void (^)(void))completion;

/// Reset the corresponding view controller as the root view controller of the application's window.
///
/// viewModel - the view model
- (void)resetRootViewModel:(MDControllerViewModel *)viewModel;
- (void)resetRootNavigationWithViewModel:(MDControllerViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
