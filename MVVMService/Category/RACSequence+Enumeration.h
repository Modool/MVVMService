//
//  RACSequence+Enumeration.h
//  Transport
//
//  Created by xulinfeng on 2018/12/7.
//  Copyright © 2018 modool. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface RACSequence (Enumeration)

/// Apply all values in the sequence pass the block.
///
/// block - The block used to apply each item. Cannot be nil.
///
/// Returns a boolean indicating if all values in the sequence passed.
- (RACSequence *)doEach:(void (^)(id _Nullable value))block;

@end

NS_ASSUME_NONNULL_END
