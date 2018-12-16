//
//  MDMultipleViewModel.m
//  MVVMService
//
//  Created by xulinfeng on 2018/11/27.
//  Copyright © 2018 modool. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "MDMultipleViewModel.h"
#import "MDTabBarController.h"

#import "MDService.h"

@interface  MDMultipleViewModel ()

@end

@implementation MDMultipleViewModel

- (instancetype)initWithService:(id<MDService>)service parameters:(NSDictionary *)parameters{
    if (self = [super initWithService:service parameters:parameters]) {
        self.viewControllerClass = MDTabBarController.class;
    }
    return self;
}

- (void)initialize{
    [super initialize];
    
    RAC(self, currentViewModel) = [RACSignal combineLatest:@[RACObserve(self, currentIndex), RACObserve(self, viewModels)] reduce:^id(NSNumber *currentIndex, NSArray<MDControllerViewModel *> *viewModels){
        if (!viewModels.count || currentIndex.integerValue >= viewModels.count) return nil;
        return viewModels[currentIndex.integerValue];
    }];
}

- (NSArray<UIViewController *> *)viewControllersWithViewModels:(NSArray<MDControllerViewModel *> *)viewModels {
    @weakify(self);
    return [[viewModels.rac_sequence map:^id(MDControllerViewModel *viewModel) {
        @strongify(self);
        return [self.service viewControllerWithViewModel:viewModel];
    }] array];
}

@end
