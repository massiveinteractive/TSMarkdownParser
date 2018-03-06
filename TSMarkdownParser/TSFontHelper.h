//
//  TSFontHelper.h
//  TSMarkdownParser
//
//  Created by Antoine Cœur on 03/05/2016.
//  Copyright © 2016 Computertalk Sweden. All rights reserved.
//

@import Foundation;
#import "TSFoundation.h"
#import "TSFontTraitMask.h"

NS_ASSUME_NONNULL_BEGIN

NS_ROOT_CLASS
@interface TSFontHelper

+ (UIFont *)convertFont:(UIFont *)font toHaveTrait:(TSFontTraitMask)traits;
+ (UIFont *)convertFont:(UIFont *)font toNotHaveTrait:(TSFontTraitMask)traits;
+ (UIFont *)monospaceFontOfSize:(CGFloat)fontSize;

@end

NS_ASSUME_NONNULL_END
