//
//  MDViewModel.h
//  MVVMService
//
//  Created by xulinfeng on 2018/11/27.
//  Copyright © 2018 modool. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MDViewModelUIDelegate <NSObject>
@end

@class MDViewModel, RACSubject;
@protocol MDView <NSObject>

@property (nonatomic, strong, readonly, nullable) MDViewModel *viewModel;

- (void)bindViewModel:(MDViewModel *)viewModel;

@end

@interface MDViewModel : NSObject

@property (nonatomic, weak, nullable) id<MDViewModelUIDelegate> UIDelegate;

/// A RACSubject object, which representing all errors occurred in view model.
@property (nonatomic, strong, readonly) RACSubject *errors;

@property (nonatomic, strong, nullable) NSDictionary *keyPathAndValues;

/// An additional method, in which you can initialize data, RACCommand etc.
- (void)initialize NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
