//
//  MDLoadingTitleView.h
//  MVVMService
//
//  Created by xulinfeng on 2018/11/27.
//  Copyright © 2018 modool. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDLoadingTitleView : UIView

@property (nonatomic, copy, readonly) NSString *loadingText;

+ (instancetype)titleViewWithLoadingText:(NSString *)loadingText;
- (instancetype)initWithLoadingText:(NSString *)loadingText;

@end

NS_ASSUME_NONNULL_END
