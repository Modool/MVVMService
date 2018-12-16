//
//  MDNavigationProtocol.h
//  MVVMService
//
//  Created by xulinfeng on 2018/11/27.
//  Copyright © 2018 modool. All rights reserved.
//

#import "MDControllerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MDSplitProtocol <NSObject>

@optional
/// Show view model.
///
/// viewModel  - the view model
/// referencedViewModel  - the referenced view model
/// animated   - use animation or not
/// completion - the completion handler
- (void)showViewModel:(MDControllerViewModel *)viewModel referencedViewModel:(MDControllerViewModel *)referencedViewModel;
- (void)showViewModel:(MDControllerViewModel *)viewModel;

/// Show detail view model.
///
/// viewModel  - the view model
/// referencedViewModel  - the referenced view model
/// animated   - use animation or not
/// completion - the completion handler
- (void)showDetailViewModel:(MDControllerViewModel *)viewModel referencedViewModel:(MDControllerViewModel *)referencedViewModel;
- (void)showDetailViewModel:(MDControllerViewModel *)viewModel;

@end

@protocol MDNavigationProtocol <MDSplitProtocol, MDControllerProtocol>

@optional
/// Pushes the corresponding view controller.
///
/// Uses a horizontal slide transition.
/// Has no effect if the corresponding view controller is already in the stack.
///
/// viewModel - the view model
/// animated  - use animation or not
- (void)pushViewModel:(MDControllerViewModel *)viewModel animated:(BOOL)animated;

/// Pops the top view controller in the stack.
///
/// animated - use animation or not
- (void)popViewModelAnimated:(BOOL)animated;

/// Pops until top is this view controller on the stack.
///
/// animated - use animation or not
- (void)popToViewModel:(MDControllerViewModel *)viewModel animated:(BOOL)animated;

/// Pops until there's only a single view controller left on the stack.
///
/// animated - use animation or not
- (void)popToRootViewModelAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
