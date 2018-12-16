//
//  MDTextTableCell.h
//  MVVMService
//
//  Created by xulinfeng on 2018/12/5.
//  Copyright © 2018 modool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDTextItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDTextTableCell : UITableViewCell <MDView>{
@protected
    UILabel *_titleLabel;
}

@property (nonatomic, strong, readonly) MDTextItemViewModel *viewModel;

@end

NS_ASSUME_NONNULL_END
