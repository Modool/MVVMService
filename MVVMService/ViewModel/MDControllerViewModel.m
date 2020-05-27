//
//  MDControllerViewModel.m
//  MVVMService
//
//  Created by xulinfeng on 2018/11/27.
//  Copyright © 2018 modool. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "MDControllerViewModel.h"
#import "MDControllerViewModel+Private.h"

#import "MDViewController.h"

#import "MDService+Private.h"

#import "MDService.h"

@implementation MDControllerViewModel
@dynamic UIDelegate;

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    MDControllerViewModel<MDControllerViewModelExtension> *viewModel = (id)[super allocWithZone:zone];
    @weakify(viewModel);
    [[viewModel rac_signalForSelector:@selector(initWithService:parameters:)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(viewModel);
        [viewModel initialize];
    }];
    
    [[viewModel rac_signalForSelector:@selector(initialize)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(viewModel);
        if ([viewModel respondsToSelector:@selector(initializeExtension)]) {
            [viewModel initializeExtension];
        }
    }];
    
    return viewModel;
}

- (instancetype)initWithService:(id<MDService>)service parameters:(NSDictionary *)parameters {
    NSParameterAssert(service);
    if (self = [super init]) {
        _service = service;
        _parameters = parameters;
        _viewControllerClass = MDViewController.class;
    }
    return self;
}

- (void)initialize {
    [super initialize];

    _tabBarItem = [[UITabBarItem alloc] initWithTitle:_title image:nil selectedImage:nil];

    _openURLCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSURL *URL) {
        return [RACSignal return:@([UIApplication.sharedApplication openURL:URL])];
    }];
}

#pragma mark - public

- (void)loadView {}

- (void)viewDidLoad {
    _viewLoaded = YES;
}

- (void)viewWillAppear {}

- (void)viewDidAppear {
    _appeared = YES;
}

- (void)viewWillDisappear {}

- (void)viewDidDisappear {
    _appeared = NO;
}

- (void)showViewModel:(MDControllerViewModel *)viewModel {
    [self.service showViewModel:viewModel referencedViewModel:self];
}

- (void)showDetailViewModel:(MDControllerViewModel *)viewModel {
    [self.service showDetailViewModel:viewModel referencedViewModel:self];
}

@end
