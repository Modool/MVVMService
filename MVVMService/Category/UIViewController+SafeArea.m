//
//  UIViewController+SafeArea.m
//  Transport
//
//  Created by xulinfeng on 2018/11/27.
//  Copyright © 2018 modool. All rights reserved.
//

#import "UIViewController+SafeArea.h"

@implementation UIViewController (SafeArea)

- (UIEdgeInsets)safeContentInsets {
    if (@available(iOS 11, *)) {
        return self.view.safeContentInsets;
    } else {
        CGFloat top = self.topLayoutGuide.length;
        CGFloat bottom = self.bottomLayoutGuide.length;

        return UIEdgeInsetsMake(top, 0, bottom, 0);
    }
}

@end

@implementation UIView (SafeArea)

- (UIEdgeInsets)safeContentInsets {
    if (@available(iOS 11, *)) {
        return [self safeAreaInsets];
    } else {
        return UIEdgeInsetsZero;
    }
}

@end

@implementation UIScrollView (SafeArea)

- (UIEdgeInsets)compatContentInset {
    if (@available(iOS 11, *)) {
        return self.adjustedContentInset;
    } else {
        return self.contentInset;
    }
}

@end
