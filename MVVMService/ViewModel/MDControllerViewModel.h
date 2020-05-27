//
//  MDControllerViewModel.h
//  MVVMService
//
//  Created by xulinfeng on 2018/11/27.
//  Copyright © 2018 modool. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MDViewModel.h"

NS_ASSUME_NONNULL_BEGIN

#define MD_VIEM_MODEL_PARAMETER

/// The type of the title view.
typedef NS_ENUM(NSUInteger, MDTitleViewType) {
    /// System title view
    MDTitleViewTypeDefault,
    /// Double title view
    MDTitleViewTypeDoubleTitle,
    /// Loading title view
    MDTitleViewTypeLoadingTitle
};

@class RACSignal, RACCommand;
@protocol MDViewController;
@protocol MDControllerViewModelUIDelegate <MDViewModelUIDelegate>
@end

@interface MDControllerViewModel<__covariant ServiceType> : MDViewModel

@property (nonatomic, weak, nullable) id<MDControllerViewModelUIDelegate> UIDelegate;

@property (nonatomic, strong, readonly) ServiceType service;
@property (nonatomic, copy, readonly, nullable) NSDictionary *parameters;

@property (nonatomic, assign) MDTitleViewType titleViewType;

@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable  ) NSString *subtitle;
@property (nonatomic, strong, nullable) UITabBarItem *tabBarItem;

/// The callback block.
@property (nonatomic, copy, nullable) void (^completion)(id viewModel);

/// sub class of MDViewController
@property (nonatomic, strong, nullable) Class<MDViewController> viewControllerClass;

/// Open URL by using UIApplication,, input: URL, output: result state
@property (nonatomic, strong, readonly) RACCommand *openURLCommand;

@property (nonatomic, assign, readonly, getter=isAppeared) BOOL appeared;
@property (nonatomic, assign, readonly, getter=isViewLoaded) BOOL viewLoaded;

- (instancetype)initWithService:(ServiceType)service parameters:(nullable NSDictionary *)parameters NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

- (void)loadView NS_REQUIRES_SUPER;
- (void)viewDidLoad NS_REQUIRES_SUPER;

- (void)viewWillAppear NS_REQUIRES_SUPER;
- (void)viewDidAppear NS_REQUIRES_SUPER;
- (void)viewWillDisappear NS_REQUIRES_SUPER;
- (void)viewDidDisappear NS_REQUIRES_SUPER;

- (void)showViewModel:(MDControllerViewModel *)viewModel;
- (void)showDetailViewModel:(MDControllerViewModel *)viewModel;

@end

@protocol MDControllerViewModelExtension <NSObject>

@optional
- (void)initializeExtension;

@end

NS_ASSUME_NONNULL_END
