//
//  MDMultipleViewModel.h
//  MVVMService
//
//  Created by xulinfeng on 2018/11/27.
//  Copyright © 2018 modool. All rights reserved.
//

#import "MDControllerViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class RACCommand;
@interface MDMultipleViewModel : MDControllerViewModel

@property (nonatomic, strong, nullable) RACCommand *didSelectCommand;

@property (nonatomic, strong, readonly, nullable) MDControllerViewModel *currentViewModel;

@property (nonatomic, copy, nullable) NSArray<MDControllerViewModel *> *viewModels;

@property (nonatomic, assign) NSUInteger currentIndex;

- (NSArray<UIViewController *> *)viewControllersWithViewModels:(NSArray<MDControllerViewModel *> *)viewModels;

@end

NS_ASSUME_NONNULL_END
