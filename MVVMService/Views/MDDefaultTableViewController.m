//
//  MDDefaultTableViewController.m
//  MVVMService
//
//  Created by xulinfeng on 2018/11/27.
//  Copyright © 2018 modool. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "MDDefaultTableViewController.h"

#import "MDTableViewModel.h"

@implementation MDDefaultTableViewController

- (void)bindViewModel{
    [super bindViewModel];

    @weakify(self);
    [RACObserve(self.viewModel, dataSource) subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
}

@end
