//
//  MDDefaultCollectionViewController.m
//  MVVMService
//
//  Created by xulinfeng on 2018/11/27.
//  Copyright © 2018 modool. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "MDDefaultCollectionViewController.h"

#import "MDCollectionViewModel.h"

@implementation MDDefaultCollectionViewController

- (void)bindViewModel{
    [super bindViewModel];

    @weakify(self);
    [RACObserve(self.viewModel, dataSource) subscribeNext:^(id x) {
        @strongify(self);
        [self reloadData];
    }];
}

@end
