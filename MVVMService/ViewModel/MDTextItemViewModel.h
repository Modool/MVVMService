//
//  MDTextItemViewModel.h
//  MVVMService
//
//  Created by xulinfeng on 2018/12/5.
//  Copyright © 2018 modool. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MDListViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDTextItemViewModel : MDViewModel <MDListItem>

@property (nonatomic, strong, readonly) NSString *title;

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *selectedTextColor;

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *selectedBackgroundColor;

@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) CGFloat cornerRadius;

+ (instancetype)viewModelWithTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
