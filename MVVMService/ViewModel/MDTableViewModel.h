//
//  MDTableViewModel.h
//  MVVMService
//
//  Created by xulinfeng on 2018/11/27.
//  Copyright © 2018 modool. All rights reserved.
//

#import "MDListViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewRowAction (MDAdditions)

+ (instancetype)rac_rowActionWithStyle:(UITableViewRowActionStyle)style title:(NSString *)title command:(RACCommand *)command;
+ (instancetype)rac_rowActionWithStyle:(UITableViewRowActionStyle)style title:(NSString *)title viewModel:(nullable id<MDListItem>)viewModel command:(RACCommand *)command;

+ (UITableViewRowAction *)rac_deleteActionCommand:(RACCommand *)command;

@end

API_AVAILABLE(ios(11.0))
@interface UIContextualAction(MDAdditions)

+ (instancetype)rac_actionWithStyle:(UIContextualActionStyle)style title:(NSString *)title viewModel:(id<MDListItem>)viewModel command:(RACCommand *)command;
+ (instancetype)rac_actionWithStyle:(UIContextualActionStyle)style title:(NSString *)title indexPath:(NSIndexPath *)indexPath command:(RACCommand *)command;

+ (UIContextualAction *)rac_deleteActionAtIndexPath:(NSIndexPath *)indexPath command:(RACCommand *)command;

@end

@class MDTableViewModel;
@protocol MDTableViewModelUIDelegate <MDControllerViewModelUIDelegate>
@end

@protocol MDListSection;
@interface MDTableViewModel : MDListViewModel

@property (nonatomic, weak) id<MDTableViewModelUIDelegate> UIDelegate;

@property (nonatomic, assign) UITableViewStyle style;

@property (nonatomic, assign) CGFloat rowHeight; // default is 0.

- (BOOL)allowedEditAtIndexPath:(NSIndexPath *)indexPath;

- (NSUInteger)sectionForIndexTitle:(NSString *)title atIndex:(NSInteger)index;

- (nullable NSArray<UITableViewRowAction *> *)rowEditActionsAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0);

- (nullable NSArray<UIContextualAction *> *)trailingSwipeActionsForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0));
- (nullable NSArray<UIContextualAction *> *)leadingSwipeActionsForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0));

- (nullable UISwipeActionsConfiguration *)trailingSwipeConfigurationWithActions:(NSArray<UIContextualAction *> *)actions API_AVAILABLE(ios(11.0));
- (nullable UISwipeActionsConfiguration *)leadingSwipeConfigurationWithActions:(NSArray<UIContextualAction *> *)actions API_AVAILABLE(ios(11.0));

/**
 height for row at indexPath

 @param contentView content view
 @param indexPath indexPath of view model
 @return height of row
 */
- (CGFloat)contentView:(UIView *)contentView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
