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

/**
 Show view model with default reference view model.

 @param viewModel the view model
 */
- (void)showViewModel:(MDControllerViewModel *)viewModel;

/**
 Show view model.

 @param viewModel the view model
 @param referencedViewModel the referenced view model
 */
- (void)showViewModel:(MDControllerViewModel *)viewModel referencedViewModel:(MDControllerViewModel *)referencedViewModel;

/**
 Show detail view model with default reference view model.

 @param viewModel the view model
 */

- (void)showDetailViewModel:(MDControllerViewModel *)viewModel;

/**
 Show detail view model.

 @param viewModel the view model
 @param referencedViewModel the referenced view model
 */

- (void)showDetailViewModel:(MDControllerViewModel *)viewModel referencedViewModel:(MDControllerViewModel *)referencedViewModel;

@end

@protocol MDNavigationProtocol <MDSplitProtocol, MDControllerProtocol>

@optional

/**
 Pushes the corresponding view controller.
 Uses a horizontal slide transition.
 Has no effect if the corresponding view controller is already in the stack.

 @param viewModel the view model
 @param animated use animation or not
 */
- (void)pushViewModel:(MDControllerViewModel *)viewModel animated:(BOOL)animated;

/**
 Pushes the corresponding view controller.
 Uses a horizontal slide transition.
 Has no effect if the corresponding view controller is already in the stack.

 @param viewModel the view model
 @param index replace view controllers behind index
 @param animated use animation or not
 */
- (void)pushViewModel:(MDControllerViewModel *)viewModel replacingAtIndex:(NSUInteger)index animated:(BOOL)animated;

/**
 Pops the top view controller in the stack.

 @param animated use animation or not
 */
- (void)popViewModelAnimated:(BOOL)animated;

/**
 Pops until top is this view controller on the stack.

 @param viewModel the view model
 @param animated animated - use animation or not
 */
- (void)popToViewModel:(MDControllerViewModel *)viewModel animated:(BOOL)animated;

/**
 Pops until there's only a single view controller left on the stack.

 @param animated use animation or not
 */
- (void)popToRootViewModelAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
