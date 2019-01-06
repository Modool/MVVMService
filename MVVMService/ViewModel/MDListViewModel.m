//
//  MDListViewModel.m
//  MVVMService
//
//  Created by xulinfeng on 2018/11/27.
//  Copyright © 2018 modool. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "MDListViewModel.h"

@implementation NSIndexPath (MDAdditions)

+ (NSIndexSet *)rac_indexSetWithIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    return [self rac_indexSetWithIndexPaths:indexPaths inSection:0];
}

+ (NSIndexSet *)rac_indexSetWithIndexPaths:(NSArray<NSIndexPath *> *)indexPaths inSection:(NSUInteger)section {
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    for (NSIndexPath *indexPath in indexPaths) {
        if ([indexPath section] != section) continue;

        [indexSet addIndex:[indexPath row]];
    }
    return indexSet;
}

@end

@implementation MDListSection
@synthesize header = _header, footer = _footer;
@synthesize headerHeight = _headerHeight, footerHeight = _footerHeight;
@synthesize headerViewClass = _headerViewClass, footerViewClass = _footerViewClass;
@synthesize viewModels = _viewModels;

+ (instancetype)sectionWithViewModels:(NSArray<MDListItem> *)viewModels {
    return [[self alloc] initWithViewModels:viewModels];
}

- (instancetype)initWithViewModels:(NSArray<MDListItem> *)viewModels {
    if (self = [super init]) {
        _viewModels = viewModels;
    }
    return self;
}

@end

@implementation MDListViewModel

- (instancetype)initWithService:(id<MDService>)service parameters:(NSDictionary *)parameters{
    self = [super initWithService:service parameters:parameters];
    if (self) {
        _firstPage = 1;
        _page = 1;
        _pageOffset = 1;
        _sizeOfPerPage = 10;
        _loadMoreEnabled = YES;
        _allowsSelection = YES;
        _automaticallyCancelSelection = YES;
        _shouldRequestRemoteDataOnViewDidLoad = YES;
    }
    return self;
}

- (void)initialize {
    [super initialize];

    @weakify(self);
    _requestDataCommand = [[RACCommand alloc] initWithSignalBlock:^(NSNumber *page) {
        @strongify(self);
        return [[self requestDataSignalWithPage:[page unsignedIntegerValue]] takeUntil:self.rac_willDeallocSignal];
    }];

    _deleteCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *tuple) {
        RACTupleUnpack(id<MDListItem> viewModel, NSNumber *animation) = tuple;
        if (!viewModel) return [RACSignal empty];

        @strongify(self);
        return [[[self deleteSignalWithViewModel:viewModel] combineLatestWith:[RACSignal return:animation]] takeUntil:self.rac_willDeallocSignal];
    }];
    _deleteCommand.allowsConcurrentExecution = YES;

    _insertCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *tuple) {
        RACTupleUnpack(id<MDListItem> viewModel, NSNumber *index, NSNumber *animation) = tuple;
        if (!viewModel) return [RACSignal empty];

        @strongify(self);
        return [[[self insertSignalWithViewModel:viewModel atIndex:index.integerValue] combineLatestWith:[RACSignal return:animation]] takeUntil:self.rac_willDeallocSignal];
    }];
    _insertCommand.allowsConcurrentExecution = YES;

    _addCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *tuple) {
        RACTupleUnpack(id<MDListItem> viewModel, NSNumber *animation) = tuple;
        if (!viewModel) return [RACSignal empty];

        @strongify(self);
        return [[[self addSignalWithViewModel:viewModel] combineLatestWith:[RACSignal return:animation]] takeUntil:self.rac_willDeallocSignal];
    }];
    _addCommand.allowsConcurrentExecution = YES;

    _didMoveCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *tuple) {
        RACTupleUnpack(NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath) = tuple;
        if (!sourceIndexPath || !destinationIndexPath) return [RACSignal empty];

        @strongify(self);
        return [[self moveItemAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath] takeUntil:self.rac_willDeallocSignal];
    }];

    [[self.requestDataCommand.errors filter:self.requestDataErrorsFilter] subscribe:self.errors];
}

- (void)refresh {}
- (void)loadMore {}

- (BOOL (^)(NSError *error))requestDataErrorsFilter {
    return ^(NSError *error) {
        return YES;
    };
}

- (BOOL)allowedMoveAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)allowedSelectAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)allowedDeselectAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSUInteger)offsetForPage:(NSUInteger)page {
    return (page - 1) * [self sizeOfPerPage];
}

- (id<MDListItem>)viewModelAtIndexPath:(NSIndexPath *)indexPath {
    id<MDListSection> tableSection = self.dataSource[indexPath.section];

    return tableSection.viewModels[indexPath.row];
}

- (NSIndexPath *)indexPathWithViewModel:(id<MDListItem>)viewModel {
    NSArray<MDListSection *> *dataSource = [[self dataSource] copy];
    NSUInteger numberOfSections = [[self dataSource] count];

    for (NSUInteger section = 0; section < numberOfSections; section++) {
        id<MDListSection> tableSection = dataSource[section];
        NSUInteger numberOfRows = [[tableSection viewModels] count];

        for (NSUInteger row = 0; row < numberOfRows; row++) {
            MDViewModel *local = tableSection.viewModels[row];
            if (viewModel == local || [viewModel isEqual:local]) {
                return [NSIndexPath indexPathForRow:row inSection:section];
            }
        }
    }
    return nil;
}

- (Class<MDView, NSObject>)classForItemViewModel:(id<MDListItem>)viewModel {
    return nil;
}

- (RACSignal *)requestDataSignalWithPage:(NSUInteger)page {
    return [RACSignal empty];
}

- (RACSignal *)deleteSignalWithViewModel:(id<MDListItem>)viewModel {
    return (id)[RACSignal return:viewModel];
}

- (RACSignal *)addSignalWithViewModel:(id<MDListItem>)viewModel {
    return (id)[RACSignal return:viewModel];
}

- (RACSignal *)insertSignalWithViewModel:(id<MDListItem>)viewModel atIndex:(NSUInteger)index {
    return [RACSignal return:RACTuplePack((id)viewModel, @(index))];
}

- (RACSignal *)moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    return [RACSignal empty];
}

@end
