//
//  CHRTextFieldFormatter.m
//
//  Created by Dmitry Nesterenko on 12/05/15.
//  Copyright (c) 2015 e-legion. All rights reserved.
//

#import "CHRTextFieldFormatter.h"

@interface CHRTextFieldFormatter ()

@property (nonatomic, copy) id<CHRTextMask> mask;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation CHRTextFieldFormatter

#pragma mark - Object Lifecycle

- (void)dealloc {
    [self.textField removeTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - Initialization

- (instancetype)init {
    return [self initWithTextField:nil mask:nil];
}

- (instancetype)initWithTextField:(UITextField *)textField mask:(id<CHRTextMask>)mask {
    self = [super init];
    if (self) {
        self.mask = mask;
        self.textField = textField;

        [textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        [self formatTextInTextField:textField];
    }
    return self;
}

#pragma mark - Text Field State

- (void)formatTextInTextField:(UITextField *)textField {
    // In order to make the cursor end up positioned correctly, we need to
    // explicitly reposition it after we inject spaces into the text.
    // targetCursorPosition keeps track of where the cursor needs to end up as
    // we modify the string, and at the end we set the cursor position to it.
    NSUInteger targetCursorPosition = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];

    NSString *formattedString = [self stringForObjectValue:textField.text cursorPosition:&targetCursorPosition];
    
    textField.text = formattedString;
    UITextPosition *targetPosition = [textField positionFromPosition:[textField beginningOfDocument] offset:targetCursorPosition];
    
    [textField setSelectedTextRange:[textField textRangeFromPosition:targetPosition toPosition:targetPosition]];
}

#pragma mark - Editing Changed

- (void)textFieldEditingChanged:(UITextField *)textField {
    [self formatTextInTextField:textField];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self.mask shouldChangeText:textField.text withReplacementString:string inRange:range];
}

#pragma mark - NSFormatter

- (NSString *)stringForObjectValue:(id)obj {
    if (![obj isKindOfClass:[NSString class]])
        return nil;
    
    return [self stringForObjectValue:obj cursorPosition:NULL];
}

- (NSString *)stringForObjectValue:(NSString *)obj cursorPosition:(NSUInteger *)cursorPosition {
    NSString *filteredString = [self.mask filteredStringFromString:obj cursorPosition:cursorPosition];
    NSString *formattedString = [self.mask formattedStringFromString:filteredString cursorPosition:cursorPosition];
    return formattedString;
}

- (BOOL)getObjectValue:(out __autoreleasing id *)obj forString:(NSString *)string errorDescription:(out NSString *__autoreleasing *)error {
    if (obj != NULL) {
        *obj = [self.mask filteredStringFromString:string cursorPosition:NULL];
    }
    
    return YES;
}

- (NSString *)maskedStringFromString:(NSString *)string {
    return [self stringForObjectValue:string];
}

- (NSString *)unmaskedStringFromString:(NSString *)string {
    id object;
    [self getObjectValue:&object forString:string errorDescription:nil];
    return object;
}

@end
