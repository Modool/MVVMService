//
//  MDTableViewController.h
//  MVVMService
//
//  Created by xulinfeng on 2018/11/27.
//  Copyright © 2018 modool. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MDListViewController.h"
#import "MDTableViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDTableViewController : MDListViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong, readonly) MDTableViewModel *viewModel;

// The table view for tableView controller.
@property (nonatomic, strong, readonly) UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
