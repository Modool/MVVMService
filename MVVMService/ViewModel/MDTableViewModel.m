//
//  MDTableViewModel.m
//  MVVMService
//
//  Created by xulinfeng on 2018/11/27.
//  Copyright © 2018 modool. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "MDTableViewModel.h"
#import "MDTableViewController.h"

@implementation UITableViewRowAction (MDAdditions)

+ (instancetype)rac_rowActionWithStyle:(UITableViewRowActionStyle)style title:(NSString *)title command:(RACCommand *)command {
    return [self rac_rowActionWithStyle:style title:title viewModel:nil command:command];
}

+ (instancetype)rac_rowActionWithStyle:(UITableViewRowActionStyle)style title:(NSString *)title viewModel:(id<MDListItem>)viewModel command:(RACCommand *)command {
    return [self rowActionWithStyle:style title:title handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [command execute:viewModel];
    }];
}

+ (UITableViewRowAction *)rac_deleteActionCommand:(RACCommand *)command {
    return [self rac_rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" command:command];
}

@end

@implementation UIContextualAction(MDAdditions)

+ (instancetype)rac_actionWithStyle:(UIContextualActionStyle)style title:(NSString *)title viewModel:(id<MDListItem>)viewModel command:(RACCommand *)command {
    return [self contextualActionWithStyle:style title:title handler:^(UIContextualAction * action, UIView *sourceView, void (^completionHandler)(BOOL)) {
        [[command execute:viewModel] subscribeNext:^(id x) {
            completionHandler(YES);
        } error:^(NSError *error) {
            completionHandler(NO);
        }];
    }];
}

+ (instancetype)rac_actionWithStyle:(UIContextualActionStyle)style title:(NSString *)title indexPath:(NSIndexPath *)indexPath command:(RACCommand *)command {
    return [self contextualActionWithStyle:style title:title handler:^(UIContextualAction * action, UIView *sourceView, void (^completionHandler)(BOOL)) {
        [[command execute:indexPath] subscribeNext:^(id x) {
            completionHandler(YES);
        } error:^(NSError *error) {
            completionHandler(NO);
        }];
    }];
}

+ (UIContextualAction *)rac_deleteActionAtIndexPath:(NSIndexPath *)indexPath command:(RACCommand *)command {
    return [self rac_actionWithStyle:UIContextualActionStyleDestructive title:@"删除" indexPath:indexPath command:command];
}

@end

@implementation MDTableViewModel
@dynamic UIDelegate;

- (instancetype)initWithService:(id<MDService>)service parameters:(NSDictionary *)parameters {
    NSParameterAssert(service);
    if (self = [super initWithService:service parameters:parameters]) {
        self.viewControllerClass = MDTableViewController.class;
    }
    return self;
}

- (void)setEditing:(BOOL)editing {
    [self setEditing:editing animated:NO];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    _editing = editing;
}

- (BOOL)allowedEditAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSUInteger)sectionForIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

- (NSArray<UITableViewRowAction *> *)rowEditActionsAtIndexPath:(NSIndexPath *)indexPath {
    return @[];
}

- (NSArray<UIContextualAction *> *)trailingSwipeActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @[];
}

- (NSArray<UIContextualAction *> *)leadingSwipeActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @[];
}

- (UISwipeActionsConfiguration *)trailingSwipeConfigurationWithActions:(NSArray<UIContextualAction *> *)actions API_AVAILABLE(ios(11.0)) {
    UISwipeActionsConfiguration *configration = [UISwipeActionsConfiguration configurationWithActions:actions];
    configration.performsFirstActionWithFullSwipe = NO;
    
    return configration;
}

- (UISwipeActionsConfiguration *)leadingSwipeConfigurationWithActions:(NSArray<UIContextualAction *> *)actions API_AVAILABLE(ios(11.0)) {
    UISwipeActionsConfiguration *configration = [UISwipeActionsConfiguration configurationWithActions:actions];
    configration.performsFirstActionWithFullSwipe = NO;
    
    return configration;
}

- (CGFloat)contentView:(UIView *)contentView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self rowHeight];
}

@end
