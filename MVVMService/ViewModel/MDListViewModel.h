//
//  MDListViewModel.h
//  MVVMService
//
//  Created by xulinfeng on 2018/11/27.
//  Copyright © 2018 modool. All rights reserved.
//

#import "MDControllerViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSIndexPath (MDAdditions)

+ (nullable NSIndexSet *)rac_indexSetWithIndexPaths:(nullable NSArray<NSIndexPath *> *)indexPaths;
+ (nullable NSIndexSet *)rac_indexSetWithIndexPaths:(nullable NSArray<NSIndexPath *> *)indexPaths inSection:(NSUInteger)section;

@end

@protocol MDListItem <NSObject>

@optional
@property (nonatomic, strong, readonly, nullable) NSString *identifier;
@property (nonatomic, strong, readonly, nullable, class) NSString *identifier;

@end

@protocol MDListSection <NSObject>

@required
@property (nonatomic, copy, nullable) NSString *header;
@property (nonatomic, assign) CGFloat headerHeight;

@property (nonatomic, copy, nullable) NSString *footer;
@property (nonatomic, assign) CGFloat footerHeight;

@property (nonatomic, strong, nullable) Class<MDView> headerViewClass;
@property (nonatomic, strong, nullable) Class<MDView> footerViewClass;

@property (nonatomic, copy, nullable) NSArray<MDListItem> *viewModels;

@end

@interface MDListSection : MDViewModel <MDListSection>

+ (instancetype)sectionWithViewModels:(nullable NSArray<MDListItem> *)viewModels;
- (instancetype)initWithViewModels:(nullable NSArray<MDListItem> *)viewModels;

@end

@interface MDListViewModel : MDControllerViewModel

/// The data source of table view.
@property (nonatomic, copy, nullable) NSArray<MDListSection> *dataSource;

/// ViewModel class: identifier and cell class
@property (nonatomic, copy, nullable) NSDictionary<Class<MDListItem>, Class<MDView, NSObject>> *itemClasses;

/// Identifier to header class
@property (nonatomic, copy, nullable) NSDictionary<NSString *, Class<MDView, NSObject>> *headerClasses;

/// Identifier to footer class
@property (nonatomic, copy, nullable) NSDictionary<NSString *, Class<MDView, NSObject>> *footerClasses;

/// The list of section titles to display in section index view.
@property (nonatomic, copy, nullable) NSArray *sectionIndexTitles;

/// Default is 1.
@property (nonatomic, assign) NSUInteger firstPage;

/// Default is 1.
@property (nonatomic, assign) NSUInteger page;

/// Default is 1.
@property (nonatomic, assign) NSUInteger pageOffset;

/// Default is 10.
@property (nonatomic, assign) NSUInteger sizeOfPerPage;

/// Default is NO.
@property (nonatomic, assign) BOOL allowedPullToRefresh;
/// Default is NO.
@property (nonatomic, assign) BOOL allowedPullToLoadMore;

/// Default is YES.
@property (nonatomic, assign, getter=isLoadMoreEnabled) BOOL loadMoreEnabled;
- (void)refresh;
- (void)loadMore;

/// default is YES.
@property (nonatomic, assign) BOOL allowsSelection;
/// default is NO.
@property (nonatomic, assign) BOOL allowsMultipleSelection;

@property (nonatomic, copy, nullable) NSString *keyword;

/// input: RACTuplePack(itemViewModel, index, animation) output: RACTuplePack(itemViewModel, animation)
@property (nonatomic, strong) RACCommand *insertCommand;

/// input: RACTuplePack(itemViewModel, animation) output: RACTuplePack(itemViewModel, animation)
@property (nonatomic, strong) RACCommand *addCommand;

/// input: RACTuplePack(itemViewModel, animation) output: RACTuplePack(itemViewModel, animation)
@property (nonatomic, strong) RACCommand *deleteCommand;

/// input: RACTuplePack(sourceIndexPath, destinationIndexPath)
@property (nonatomic, strong) RACCommand *didMoveCommand;

/// Default is YES.
@property (nonatomic, assign) BOOL automaticallyCancelSelection;
@property (nonatomic, strong, nullable) RACCommand *didSelectCommand;
@property (nonatomic, strong, nullable) RACCommand *didDeselectCommand;

/// Default is YES.
@property (nonatomic, assign) BOOL shouldRequestRemoteDataOnViewDidLoad;
@property (nonatomic, strong, readonly) RACCommand *requestDataCommand;

- (nullable BOOL (^)(NSError *error))requestDataErrorsFilter;

- (BOOL)allowedMoveAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)allowedSelectAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)allowedDeselectAtIndexPath:(NSIndexPath *)indexPath;

/**
 Caculate reponse offset for page

 @param page page of response
 @return offset of page
 */
- (NSUInteger)offsetForPage:(NSUInteger)page;

/**
 view model from indexPath

 @param indexPath indePath of view model
 @return indexPath
 */
- (nullable id<MDListItem>)viewModelAtIndexPath:(NSIndexPath *)indexPath;

/**
 indexPath from view model

 @param viewModel item view model
 @return indexPath
 */
- (nullable NSIndexPath *)indexPathWithViewModel:(id<MDListItem>)viewModel;

/**
 view class from view model

 @param viewModel item view model
 @return view class
 */
- (nullable Class<MDView, NSObject>)classForItemViewModel:(id<MDListItem>)viewModel;

/**
 Fetch remote info

 @param page page to fetch remote info
 @return RACSignal<Object>
 */
- (RACSignal *)requestDataSignalWithPage:(NSUInteger)page;

/**
 Delete row with view model

 @param viewModel deleting view model
 @return RACSignal<viewModel>
 */
- (RACSignal *)deleteSignalWithViewModel:(id<MDListItem>)viewModel;

/**
 Add row with view model

 @param viewModel inseting view model
 @return RACSignal<viewModel>
 */
- (RACSignal *)addSignalWithViewModel:(id<MDListItem>)viewModel;

/**
 Insert row with view model at index

 @param viewModel inseting view model
 @return RACSignal<RACTwoTuple<viewModel, index> *>
 */
- (RACSignal *)insertSignalWithViewModel:(id<MDListItem>)viewModel atIndex:(NSUInteger)index;

/**
 Move item to indexPath

 @param sourceIndexPath indexPath of souce item
 @param destinationIndexPath indexPath of destination item
 @return RACSignal empty signal
 */
- (RACSignal *)moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath;

@end

NS_ASSUME_NONNULL_END
