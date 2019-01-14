//
//  MDCollectionViewController.m
//  MVVMService
//
//  Created by xulinfeng on 2018/11/27.
//  Copyright © 2018 modool. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "MDCollectionViewController.h"

@interface MDCollectionViewController ()

@end

@implementation MDCollectionViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self registerItemClass:UICollectionViewCell.class forReuseIdentifier:NSStringFromClass(UICollectionViewCell.class)];
}

- (void)bindViewModel {
    [super bindViewModel];

    RAC(self.collectionView, allowsSelection) = RACObserve(self.viewModel, allowsSelection);
    RAC(self.collectionView, allowsMultipleSelection) = RACObserve(self.viewModel, allowsMultipleSelection);

    RAC(self.collectionView, collectionViewLayout) = RACObserve(self.viewModel, layout);

    @weakify(self);
    [[self.viewModel rac_signalForSelector:@selector(setCollectionViewLayout:animated:completion:)] subscribeNext:^(RACTuple *tuple) {
        RACTupleUnpack(UICollectionViewLayout *layout, NSNumber *animated, void (^completion)(BOOL finished)) = tuple;

        @strongify(self);
        [self.collectionView setCollectionViewLayout:layout animated:animated.boolValue completion:completion];
    }];
}

- (void)dealloc {
    ((UICollectionView *)_scrollView).delegate = nil;
    ((UICollectionView *)_scrollView).dataSource = nil;
}

#pragma mark - accessor

- (UIScrollView<MDScrollViewRefreshing> *)scrollView {
    if (!_scrollView) {
        UICollectionView<MDScrollViewRefreshing> *collectionView = [[UICollectionView<MDScrollViewRefreshing> alloc] initWithFrame:self.view.bounds collectionViewLayout:self.viewModel.layout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor whiteColor];

        _scrollView = collectionView;
    }
    return _scrollView;
}

- (UICollectionView *)collectionView {
    return (UICollectionView *)[self scrollView];
}

#pragma mark - public

- (void)reloadData {
    [self.collectionView reloadData];
}

- (void)registerItemClass:(Class<MDView, NSObject>)class forReuseIdentifier:(NSString *)reuseIdentifier {
    [self.collectionView registerClass:class forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)registerHeaderViewClass:(Class<MDView, NSObject>)class forReuseIdentifier:(NSString *)reuseIdentifier {
    [self.collectionView registerClass:class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifier];
}

- (void)registerFooterViewClass:(Class<MDView, NSObject>)class forReuseIdentifier:(NSString *)reuseIdentifier {
    [self.collectionView registerClass:class forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseIdentifier];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.viewModel.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    id<MDListSection> tableSection = self.viewModel.dataSource[section];

    return tableSection.viewModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MDViewModel<MDListItem> *viewModel = [self.viewModel viewModelAtIndexPath:indexPath];
    if (!viewModel) return nil;

    Class<MDView, NSObject> class = [self.viewModel classForItemViewModel:viewModel];
    if (!class) class = self.viewModel.itemClasses[viewModel.class];
    if (!class) return nil;

    NSString *identifier = nil;
    if ([viewModel respondsToSelector:@selector(identifier)]) identifier = viewModel.identifier;
    if (!identifier.length && [viewModel.class respondsToSelector:@selector(identifier)]) identifier = [viewModel.class identifier];
    if (!identifier.length) identifier = NSStringFromClass(viewModel.class);

    if (!identifier.length) return nil;

    UICollectionViewCell<MDView> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (!cell) return nil;

    [cell bindViewModel:viewModel];

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    MDListSection<MDListSection> *tableSection = self.viewModel.dataSource[indexPath.section];
    if (!tableSection) return nil;

    BOOL header = [kind isEqualToString:UICollectionElementKindSectionHeader];
    if (header && ![tableSection headerViewClass]) return nil;
    if (!header && ![tableSection footerViewClass]) return nil;

    NSDictionary<NSString *, Class<MDView, NSObject>> *classes = header ? self.viewModel.headerClasses : self.viewModel.footerClasses;
    Class<MDView> class = header ? tableSection.headerViewClass : tableSection.footerViewClass;

    NSString *identifier = [[classes allKeysForObject:class] firstObject];
    if (!identifier.length) identifier = NSStringFromClass(class);

    UICollectionReusableView<MDView> *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
    if (!view) return nil;

    [view bindViewModel:tableSection];

    return view;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel allowedMoveAtIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    [self.viewModel.didMoveCommand execute:RACTuplePack(sourceIndexPath, destinationIndexPath)];
}

- (NSArray<NSString *> *)indexTitlesForCollectionView:(UICollectionView *)collectionView {
    return self.viewModel.sectionIndexTitles;
}

- (NSIndexPath *)collectionView:(UICollectionView *)collectionView indexPathForIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.viewModel indexPathForIndexTitle:title atIndex:index];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [self willDisplayCellAtIndexPath:indexPath];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel allowedSelectAtIndexPath:indexPath];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel allowedDeselectAtIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.automaticallyCancelSelection) [collectionView deselectItemAtIndexPath:indexPath animated:NO];

    [self.viewModel.didSelectCommand execute:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel.didDeselectCommand execute:indexPath];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)layout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.viewModel respondsToSelector:@selector(contentView:sizeForItemAtIndexPath:)]) return [self.viewModel contentView:collectionView sizeForItemAtIndexPath:indexPath];
    if ([layout isKindOfClass:UICollectionViewFlowLayout.class]) return layout.itemSize;
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)layout insetForSectionAtIndex:(NSInteger)section {
    if ([self.viewModel respondsToSelector:@selector(contentView:insetForSectionAtIndex:)]) return [self.viewModel contentView:collectionView insetForSectionAtIndex:section];
    if ([layout isKindOfClass:UICollectionViewFlowLayout.class]) return layout.sectionInset;
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)layout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if ([self.viewModel respondsToSelector:@selector(contentView:minimumLineSpacingForSectionAtIndex:)]) return [self.viewModel contentView:collectionView minimumLineSpacingForSectionAtIndex:section];
    if ([layout isKindOfClass:UICollectionViewFlowLayout.class]) return layout.minimumLineSpacing;
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)layout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if ([self.viewModel respondsToSelector:@selector(contentView:minimumInteritemSpacingForSectionAtIndex:)]) return [self.viewModel contentView:collectionView minimumInteritemSpacingForSectionAtIndex:section];
    if ([layout isKindOfClass:UICollectionViewFlowLayout.class]) return layout.minimumInteritemSpacing;
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)layout referenceSizeForHeaderInSection:(NSInteger)section {
    if ([self.viewModel respondsToSelector:@selector(contentView:referenceSizeForHeaderInSection:)]) return [self.viewModel contentView:collectionView referenceSizeForHeaderInSection:section];
    if ([layout isKindOfClass:UICollectionViewFlowLayout.class]) return layout.headerReferenceSize;
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)layout referenceSizeForFooterInSection:(NSInteger)section {
    if ([self.viewModel respondsToSelector:@selector(contentView:referenceSizeForFooterInSection:)]) return [self.viewModel contentView:collectionView referenceSizeForFooterInSection:section];
    if ([layout isKindOfClass:UICollectionViewFlowLayout.class]) return layout.footerReferenceSize;
    return CGSizeZero;
}

@end
