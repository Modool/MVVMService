//
//  UITableViewCell+MVVM.h
//  MVVMService
//
//  Created by xulinfeng on 2018/11/29.
//  Copyright © 2018 modool. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MDItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class MDItemViewModel;
@interface UITableViewCell (MVVM) <MDView>

@property (nonatomic, strong, readonly, nullable) MDItemViewModel *viewModel;

@end

NS_ASSUME_NONNULL_END
