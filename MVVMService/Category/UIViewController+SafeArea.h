//
//  UIViewController+SafeArea.h
//  Transport
//
//  Created by xulinfeng on 2018/11/27.
//  Copyright © 2018 modool. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (SafeArea)
@property (nonatomic, assign, readonly) UIEdgeInsets safeContentInsets;
@end

@interface UIView (SafeArea)
@property (nonatomic, assign, readonly) UIEdgeInsets safeContentInsets;
@end

@interface UIScrollView (SafeArea)
@property (nonatomic, assign, readonly) UIEdgeInsets compatContentInset;
@end

NS_ASSUME_NONNULL_END
