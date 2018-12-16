//
//  MDItemViewModel.m
//  MVVMService
//
//  Created by xulinfeng on 2018/11/29.
//  Copyright © 2018 modool. All rights reserved.
//

#import "MDItemViewModel.h"

@implementation MDItemViewModel

- (NSString *)identifier {
    return NSStringFromClass(self.class);
}

+ (instancetype)viewModelWithAttributeText:(NSAttributedString *)attributeText {
    return [self viewModelWithAttributeText:attributeText detailAttributeText:nil];
}

+ (instancetype)viewModelWithAttributeText:(NSAttributedString *)attributeText detailAttributeText:(NSAttributedString *)detailAttributeText {
    MDItemViewModel *viewModel = [[self alloc] init];
    viewModel->_attributeText = attributeText.copy;
    viewModel->_detailAttributeText = detailAttributeText.copy;

    return viewModel;
}

@end
