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

@class RACSignal;
@class RACCommand;

@protocol MDService, MDViewController;
@protocol MDControllerViewModelUIDelegate <MDViewModelUIDelegate>
@end

@interface MDControllerViewModel : MDViewModel

@property (nonatomic, weak, nullable) id<MDControllerViewModelUIDelegate> UIDelegate;

@property (nonatomic, strong, readonly) id<MDService> service;
@property (nonatomic, copy, readonly, nullable) NSDictionary *parameters;

@property (nonatomic, assign) MDTitleViewType titleViewType;

@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable  ) NSString *subtitle;
@property (nonatomic, strong, nullable) UITabBarItem *tabBarItem;

@property (nonatomic, assign) BOOL hidesBottomBarWhenPushed;

/// The callback block.
@property (nonatomic, copy, nullable) void (^completion)(id viewModel);

/// sub class of MDViewController
@property (nonatomic, strong, nullable) Class<MDViewController> viewControllerClass;

/// Call phone number, input: phone number, output: request
@property (nonatomic, strong, readonly) RACCommand *callCommand;

/// Open URL by using UIApplication,, input: URL, output: result state
@property (nonatomic, strong, readonly) RACCommand *openURLCommand;

@property (nonatomic, assign, readonly, getter=isAppeared) BOOL appeared;
@property (nonatomic, assign, readonly, getter=isViewLoaded) BOOL viewLoaded;

- (instancetype)initWithService:(id<MDService>)service parameters:(nullable NSDictionary *)parameters;

- (void)viewDidLoad NS_REQUIRES_SUPER;

- (void)viewWillAppear NS_REQUIRES_SUPER;
- (void)viewDidAppear NS_REQUIRES_SUPER;
- (void)viewWillDisappear NS_REQUIRES_SUPER;
- (void)viewDidDisappear NS_REQUIRES_SUPER;

- (void)showViewModel:(MDControllerViewModel *)viewModel;
- (void)showDetailViewModel:(MDControllerViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
