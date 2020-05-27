//
//  MDViewController.h
//  MVVMService
//
//  Created by xulinfeng on 2018/11/27.
//  Copyright © 2018 modool. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MDControllerViewModel;
@protocol MDViewController <NSObject>

/// The `viewModel` parameter in `-initWithViewModel:` method.
@property (nonatomic, strong, readonly) MDControllerViewModel *viewModel;

/// Initialization method. This is the preferred way to create a new view.
///
/// viewModel - corresponding view model
///
/// Returns a new view.
- (instancetype)initWithViewModel:(MDControllerViewModel *)viewModel;

/// Binds the corresponding view model to the view.
- (void)bindViewModel;

@end

typedef NS_ENUM(NSUInteger, MDViewControllerContentInsetAdjustmentBehavior) {
    MDViewControllerContentInsetAdjustmentAutomatic, // UIScrollViewContentInsetAdjustmentAutomatic
    MDViewControllerContentInsetAdjustmentScrollableAxes, // UIScrollViewContentInsetAdjustmentScrollableAxes
    MDViewControllerContentInsetAdjustmentNever, // UIScrollViewContentInsetAdjustmentNever
    MDViewControllerContentInsetAdjustmentAlways, // UIScrollViewContentInsetAdjustmentAlways
};

@interface MDViewController : UIViewController<MDViewController>

@property(nonatomic, assign) MDViewControllerContentInsetAdjustmentBehavior contentInsetAdjustmentBehavior;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

- (instancetype)initWithViewModel:(MDControllerViewModel *)viewModel NS_DESIGNATED_INITIALIZER;

- (void)viewSafeAreaInsetsDidChange NS_UNAVAILABLE;
- (void)viewSafeContentInsetsDidChange;

- (void)bindViewModel NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
