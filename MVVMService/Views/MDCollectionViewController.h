//
//  MDCollectionViewController.h
//  MVVMService
//
//  Created by xulinfeng on 2018/11/27.
//  Copyright © 2018 modool. All rights reserved.
//

#import "MDListViewController.h"

#import "MDCollectionViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDCollectionViewController : MDListViewController <UICollectionViewDataSource, UICollectionViewDelegate, MDCollectionViewModelUIDelegate>

@property (nonatomic, strong, readonly) MDCollectionViewModel *viewModel;

// The table view for tableView controller.
@property (nonatomic, strong, readonly) UICollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END
