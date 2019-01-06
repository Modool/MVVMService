//
//  MDCollectionViewModel.h
//  MVVMService
//
//  Created by xulinfeng on 2018/11/27.
//  Copyright © 2018 modool. All rights reserved.
//

#import "MDListViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class MDCollectionViewModel;
@protocol MDCollectionViewModelUIDelegate <MDControllerViewModelUIDelegate>
@end

@protocol MDCollectionFlowLayoutViewModel <NSObject>

@optional
- (CGSize)contentView:(UIView *)contentView sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
- (UIEdgeInsets)contentView:(UIView *)contentView insetForSectionAtIndex:(NSInteger)section;
- (CGFloat)contentView:(UIView *)contentView minimumLineSpacingForSectionAtIndex:(NSInteger)section;
- (CGFloat)contentView:(UIView *)contentView minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
- (CGSize)contentView:(UIView *)contentView referenceSizeForHeaderInSection:(NSInteger)section;
- (CGSize)contentView:(UIView *)contentView referenceSizeForFooterInSection:(NSInteger)section;

@end

@interface MDCollectionViewModel : MDListViewModel <MDCollectionFlowLayoutViewModel>

@property (nonatomic, weak) id<MDCollectionViewModelUIDelegate> UIDelegate;

@property (nonatomic, strong) UICollectionViewLayout *layout;

- (void)setCollectionViewLayout:(UICollectionViewLayout *)layout animated:(BOOL)animated;
- (void)setCollectionViewLayout:(UICollectionViewLayout *)layout animated:(BOOL)animated completion:(void (^ __nullable)(BOOL finished))completion;

- (NSIndexPath *)indexPathForIndexTitle:(NSString *)title atIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
