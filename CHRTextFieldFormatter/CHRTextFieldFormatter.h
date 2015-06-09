//
//  CHRTextFieldFormatter.h
//
//  Created by Dmitry Nesterenko on 12/05/15.
//  Copyright (c) 2015 e-legion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHRTextMask.h"

NS_ASSUME_NONNULL_BEGIN

/**
 UITextField formatter that applies a mask to the input text.
 
 @see http://stackoverflow.com/a/19161529/318790
 */
@interface CHRTextFieldFormatter : NSFormatter

@property (nonatomic, copy, readonly) id<CHRTextMask> mask;

/**
 Initializes the formatter for UITextField with specified mask.
 
 Retain's stong reference to passed UITextField and adds target/action for EditingChanged event.
 */
- (instancetype)initWithTextField:(nullable UITextField *)textField mask:(nullable id<CHRTextMask>)mask NS_DESIGNATED_INITIALIZER;

/**
 Proxy method to be called from the UITextField's delegate callback.
 
 @param textField Must be the same text field which was passed as initializer argument.
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

- (NSString *)maskedStringFromString:(NSString *)string;
- (NSString *)unmaskedStringFromString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END