//
//  MVVMViewModel.m
//  demo
//
//  Created by xulinfeng on 2019/1/12.
//  Copyright © 2019 modool. All rights reserved.
//

#import "MVVMViewModel.h"

@implementation MVVMViewModel

- (instancetype)initWithService:(id<MDService>)service parameters:(NSDictionary *)parameters {
    if (self = [super initWithService:service parameters:parameters]) {
        static NSUInteger index;

        self.title = @(index).stringValue;
        self.viewControllerClass = MVVMViewModel.class;
        self.itemClasses = @{(id)MDTextItemViewModel.class: MDTextTableCell.class};

        index++;
    }
    return self;
}

@end
