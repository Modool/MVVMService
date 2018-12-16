//
//  UITableViewCell+MVVM.m
//  MVVMService
//
//  Created by xulinfeng on 2018/11/29.
//  Copyright © 2018 modool. All rights reserved.
//

#import <objc/runtime.h>

#import "UITableViewCell+MVVM.h"

#import "MDItemViewModel.h"

@implementation UITableViewCell (MVVM)
@dynamic viewModel;

- (MDItemViewModel *)viewModel {
    return objc_getAssociatedObject(self, @selector(viewModel));
}

- (void)bindViewModel:(MDItemViewModel *)viewModel {
    objc_setAssociatedObject(self, @selector(viewModel), viewModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    self.imageView.image = viewModel.image;
    self.accessoryType = viewModel.accessoryType;
    self.textLabel.attributedText = viewModel.attributeText;
    self.detailTextLabel.attributedText = viewModel.detailAttributeText;
}

@end
