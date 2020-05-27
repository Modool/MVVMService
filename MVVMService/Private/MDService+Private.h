//
//  MDService+Private.h
//  MVVMService
//
//  Created by xulinfeng on 2018/11/27.
//  Copyright © 2018 modool. All rights reserved.
//

#import "MDService.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MDViewControllerService <NSObject>

@optional
@property (nonatomic, weak, nullable) UIViewController *viewController;
@property (nonatomic, strong, readonly, nullable) UINavigationController *navigationController;

@end

@protocol MDServicePrivate <MDService, MDViewControllerService>

@optional
@property (nonatomic, weak, nullable) id<MDServicePrivate> parentService;

@end

@protocol MDUIService;
@interface MDService () <MDServicePrivate> {
@protected
    id<MDUIService> _UIService;
    NSHashTable<MDServicePrivate> *_services;
}

@property (nonatomic, weak, nullable) UIViewController *viewController;

@end

@interface MDPassthroughService ()

@property (nonatomic, weak) id<MDService> referencedService;

@end

NS_ASSUME_NONNULL_END
