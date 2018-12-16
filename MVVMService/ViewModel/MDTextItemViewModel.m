//
//  MDTextItemViewModel.m
//  MVVMService
//
//  Created by xulinfeng on 2018/12/5.
//  Copyright © 2018 modool. All rights reserved.
//

#import "MDTextItemViewModel.h"

@implementation MDTextItemViewModel

- (NSString *)identifier {
    return NSStringFromClass(self.class);
}

+ (instancetype)viewModelWithTitle:(NSString *)title {
    MDTextItemViewModel *viewModel = [[self alloc] init];
    viewModel->_title = title;

    return viewModel;
}

- (UIColor *)selectedTextColor {
    return _selectedTextColor ?: _textColor;
}

@end
