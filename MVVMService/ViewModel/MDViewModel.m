//
//  MDViewModel.m
//  MVVMService
//
//  Created by xulinfeng on 2018/11/27.
//  Copyright © 2018 modool. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "MDViewModel.h"

@implementation MDViewModel

#pragma mark - protected

- (void)initialize {
    _errors = [RACSubject subject];
}

@end
