//
//  MDCollectionViewModel.m
//  MVVMService
//
//  Created by xulinfeng on 2018/11/27.
//  Copyright © 2018 modool. All rights reserved.
//

#import "MDCollectionViewModel.h"
#import "MDCollectionViewController.h"

@implementation MDCollectionViewModel
@dynamic UIDelegate;

- (instancetype)initWithService:(id<MDService>)service parameters:(NSDictionary *)parameters {
    if (self = [super initWithService:service parameters:parameters]) {
        self.viewControllerClass = MDCollectionViewController.class;
        
        _allowsSelection = YES;
        _layout = [[UICollectionViewLayout alloc] init];
    }
    return self;
}

- (void)setCollectionViewLayout:(UICollectionViewLayout *)layout animated:(BOOL)animated {
    [self setCollectionViewLayout:layout animated:animated completion:nil];
}

- (void)setCollectionViewLayout:(UICollectionViewLayout *)layout animated:(BOOL)animated completion:(void (^)(BOOL finished))completion {}

- (NSIndexPath *)indexPathForIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [NSIndexPath indexPathForRow:0 inSection:index];
}

@end

