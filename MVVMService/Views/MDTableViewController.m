//
//  MDTableViewController.m
//  MVVMService
//
//  Created by xulinfeng on 2018/11/27.
//  Copyright © 2018 modool. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "MDTableViewController.h"

@implementation MDTableViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.rowHeight = self.viewModel.rowHeight;
    
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 0;
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.sectionIndexColor = [UIColor darkGrayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexMinimumDisplayRowCount = 20;
    self.tableView.tableFooterView = [UIView new];

    [self registerItemClass:[UITableViewCell class] forReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
}

- (void)dealloc {
    ((UITableView *)_scrollView).delegate = nil;
    ((UITableView *)_scrollView).dataSource = nil;
}

#pragma mark - accessor

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:self.viewModel.style];
        tableView.delegate = self;
        tableView.dataSource = self;
        
        _scrollView = tableView;
    }
    return _scrollView;
}

- (UITableView *)tableView {
    return (UITableView *)[self scrollView];
}

#pragma mark - public

- (void)reloadData {
    [self.tableView reloadData];
}

- (void)registerItemClass:(Class<MDView, NSObject>)class forReuseIdentifier:(NSString *)reuseIdentifier {
    [self.tableView registerClass:class forCellReuseIdentifier:reuseIdentifier];
}

- (void)registerHeaderViewClass:(Class<MDView, NSObject>)class forReuseIdentifier:(NSString *)reuseIdentifier {
    [self.tableView registerClass:class forHeaderFooterViewReuseIdentifier:reuseIdentifier];
}

- (void)registerFooterViewClass:(Class<MDView, NSObject>)class forReuseIdentifier:(NSString *)reuseIdentifier {
    [self.tableView registerClass:class forHeaderFooterViewReuseIdentifier:reuseIdentifier];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<MDListSection> tableSection = self.viewModel.dataSource[section];
    return tableSection.viewModels.count;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.viewModel.sectionIndexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.viewModel sectionForIndexTitle:title atIndex:index];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel allowedEditAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MDViewModel<MDListItem> *viewModel = [self.viewModel viewModelAtIndexPath:indexPath];
    if (!viewModel) return nil;

    Class<MDView, NSObject> class = [self.viewModel classForItemViewModel:viewModel];
    if (!class) class = self.viewModel.itemClasses[viewModel.class];

    UITableViewCell<MDView> *cell = nil;

    NSString *identifier = viewModel.identifier ?: NSStringFromClass(class);
    if (!identifier.length) return nil;

    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell && class) cell = [[(Class)class alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];

    if (!cell) return nil;
    
    [cell bindViewModel:viewModel];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.viewModel contentView:tableView heightForRowAtIndexPath:indexPath];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.viewModel rowEditActionsAtIndexPath:indexPath];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) {
    NSArray *actions = [self.viewModel leadingSwipeActionsForRowAtIndexPath:indexPath] ?: @[];
    
    return [self.viewModel leadingSwipeConfigurationWithActions:actions];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) {
    NSArray *actions = [self.viewModel trailingSwipeActionsForRowAtIndexPath:indexPath] ?: @[];
    
    return [self.viewModel trailingSwipeConfigurationWithActions:actions];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    id<MDListSection> tableSection = self.viewModel.dataSource[section];
    
    return [tableSection headerHeight] > 0 ? [tableSection headerHeight] : 0.5f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    MDListSection<MDListSection> *tableSection = self.viewModel.dataSource[section];
    
    return [tableSection header];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self viewInSection:section header:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    MDListSection<MDListSection> *tableSection = self.viewModel.dataSource[section];
    
    return tableSection.footerHeight > 0 ? tableSection.footerHeight : 0.5f;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    id<MDListSection> tableSection = self.viewModel.dataSource[section];
    
    return [tableSection footer];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [self viewInSection:section header:NO];
}

- (UIView *)viewInSection:(NSInteger)section header:(BOOL)header {
    MDListSection<MDListSection> *tableSection = self.viewModel.dataSource[section];
    if (!tableSection) return nil;

    Class class = header ? tableSection.headerViewClass : tableSection.footerViewClass;
    if (!class) return nil;

    NSDictionary<NSString *, Class<MDView, NSObject>> *classes = header ? self.viewModel.headerClasses : self.viewModel.footerClasses;

    NSString *identifier = [[classes allKeysForObject:class] firstObject];
    if (!identifier.length) identifier = NSStringFromClass(class);

    UIView<MDView> *view = nil;
    if (identifier.length) view = (id)[self.tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];

    if (!view && class) view = [[(Class)class alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 0)];
    if (!view) return nil;

    [view bindViewModel:tableSection];

    return view;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel allowedMoveAtIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
   [self willDisplayCellAtIndexPath:indexPath];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel allowedSelectAtIndexPath:indexPath] ? indexPath : nil;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel allowedDeselectAtIndexPath:indexPath] ? indexPath : nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.automaticallyCancelSelection) [tableView deselectRowAtIndexPath:indexPath animated:NO];

    [self.viewModel.didSelectCommand execute:indexPath];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel.didDeselectCommand execute:indexPath];
}

@end
