//
//  MDItemViewModel.h
//  MVVMService
//
//  Created by xulinfeng on 2018/11/29.
//  Copyright © 2018 modool. All rights reserved.
//

#import "MDViewModel.h"
#import "MDListViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDItemViewModel : MDViewModel <MDListItem>

@property (nonatomic, copy, readonly, nullable) NSAttributedString *attributeText;
@property (nonatomic, copy, readonly, nullable) NSAttributedString *detailAttributeText;

@property (nonatomic, strong, nullable) UIImage *image;
@property (nonatomic, assign) UITableViewCellAccessoryType accessoryType;

+ (instancetype)viewModelWithAttributeText:(nullable NSAttributedString *)attributeText;
+ (instancetype)viewModelWithAttributeText:(nullable NSAttributedString *)attributeText detailAttributeText:(nullable NSAttributedString *)detailAttributeText;

@end

NS_ASSUME_NONNULL_END
