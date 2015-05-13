//
//  CHRPhoneNumberMask.m
//
//  Created by Dmitry Nesterenko on 12/05/15.
//  Copyright (c) 2015 e-legion. All rights reserved.
//

#import "CHRPhoneNumberMask.h"

@implementation CHRPhoneNumberMask

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    typeof(self) copy = [[self.class alloc] init];
    copy.prefix = self.prefix;
    return copy;
}

#pragma mark - Masking

- (BOOL)shouldChangeText:(NSString *)text withReplacementString:(NSString *)string inRange:(NSRange)range {
    NSString *replacedText = [text stringByReplacingCharactersInRange:range withString:string];
    
    NSString *prefix = self.prefix.length > 0 ? [self.prefix stringByAppendingString:@" "] : nil;
    
    // Consider first symbol of a mask "(" to be a part of the prefix.
    NSUInteger prefixLength = prefix.length > 0 ? prefix.length : 0;
    if (prefixLength > 0 && text.length >= prefixLength + 1)
        prefixLength++;
    
    BOOL isRangeAffectsPrefix = range.location + range.length <= prefixLength && range.location < prefixLength;
    if (isRangeAffectsPrefix) {
        // can't modify prefix
        return NO;
        
    } else {
        NSString *filteredString = [self filteredStringFromString:replacedText cursorPosition:NULL];
        if (filteredString.length > self.prefix.length + 10) {
            // can't exceed max length
            return NO;
        }

        return YES;
    }
}

- (NSString *)filteredStringFromString:(NSString *)string cursorPosition:(NSUInteger *)cursorPosition {
    NSString *prefix = self.prefix ?: @"";
    
    // obtain initial cursor position and append prefix if needed
    NSUInteger originalCursorPosition = cursorPosition == NULL ? 0 : *cursorPosition;
    NSUInteger filteredCursorPosition = cursorPosition == NULL ? 0 : *cursorPosition;
    if (![string hasPrefix:prefix] && prefix.length > 0) {
        string = [prefix stringByAppendingString:string];
        originalCursorPosition += prefix.length;
        filteredCursorPosition += prefix.length;
    }

    // filter all characters but digits
    NSMutableString *filteredString = [[NSMutableString alloc] initWithString:prefix];
    for (NSUInteger i = prefix.length; i < string.length; i++) {
        unichar character = [string characterAtIndex:i];
        
        if (isdigit(character)) {
            [filteredString appendString:[NSString stringWithCharacters:&character length:1]];
            
        } else {
            if (i < originalCursorPosition) {
                filteredCursorPosition--;
            }
        }
    }
    
    if (cursorPosition != NULL)
        *cursorPosition = filteredCursorPosition;
    
    return [filteredString copy];
}

- (NSString *)formattedStringFromString:(NSString *)string cursorPosition:(NSUInteger *)cursorPosition {
    NSString *prefix = self.prefix;

    // obtain initial cursor position and append prefix if needed
    NSUInteger originalCursorPosition = cursorPosition == NULL ? 0 : *cursorPosition;
    NSUInteger formattedCursorPosition = cursorPosition == NULL ? 0 : *cursorPosition;
    if (prefix.length > 0) {
        if (![string hasPrefix:prefix]) {
            string = [prefix stringByAppendingString:string];
            originalCursorPosition += prefix.length;
            formattedCursorPosition += prefix.length;
        }
    }
    
    if (prefix.length > 0) {
        NSMutableString *copy = [string mutableCopy];
        [copy insertString:@" " atIndex:prefix.length];
        string = [copy copy];
        prefix = [prefix stringByAppendingString:@" "];
        originalCursorPosition++;
        formattedCursorPosition++;
    }

    NSMutableString *formattedString = [[NSMutableString alloc] initWithString:prefix ?: @""];
    for (NSUInteger i = prefix.length; i < string.length; i++) {
        unichar character = [string characterAtIndex:i];
        
        if (i - prefix.length == 0) {
            if (i < originalCursorPosition) {
                formattedCursorPosition++;
            }
            [formattedString appendString:@"("];
        }
        
        if (i - prefix.length == 3) {
            if (i < originalCursorPosition) {
                formattedCursorPosition += 2;
            }
            [formattedString appendString:@") "];
        }
        
        if (i - prefix.length == 6 || i - prefix.length == 8) {
            if (i < originalCursorPosition) {
                formattedCursorPosition += 1;
            }
            [formattedString appendString:@"-"];
        }
        
        [formattedString appendString:[NSString stringWithCharacters:&character length:1]];
    }
    
    if (cursorPosition != NULL)
        *cursorPosition = formattedCursorPosition;

    return [formattedString copy];
}

@end
