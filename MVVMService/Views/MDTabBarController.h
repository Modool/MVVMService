//
//  MDTabBarController.h
//  MVVMService
//
//  Created by xulinfeng on 2018/11/27.
//  Copyright © 2018 modool. All rights reserved.
//

#import "MDViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class MDMultipleViewModel;
@interface MDTabBarController : MDViewController

@property (nonatomic, strong, readonly) MDMultipleViewModel *viewModel;

@end

@interface MDTabBarController (MDVisibleViewController)

@property (nonatomic, strong, readonly, nullable) UIViewController *selectedViewController;

@end

NS_ASSUME_NONNULL_END
