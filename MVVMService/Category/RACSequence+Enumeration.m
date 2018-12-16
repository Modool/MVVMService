//
//  RACSequence+Enumeration.m
//  Transport
//
//  Created by xulinfeng on 2018/12/7.
//  Copyright © 2018 modool. All rights reserved.
//

#import "RACSequence+Enumeration.h"

@implementation RACSequence (Enumeration)

- (RACSequence *)doEach:(void (^)(id value))block {
    NSCParameterAssert(block != NULL);

    return [self map:^id(id value) {
        block(value);

        return value;
    }];
}

@end
