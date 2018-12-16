//
//  MDControllerViewModel+Private.h
//  MVVMService
//
//  Created by xulinfeng on 2018/11/27.
//  Copyright © 2018 modool. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "MDControllerViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MDService;
@class MDControllerViewModel;
@interface MDControllerViewModel ()

@property (nonatomic, weak, nullable) UIViewController *viewController;

@property (nonatomic, strong) id<MDService> service;

@end

NS_ASSUME_NONNULL_END
