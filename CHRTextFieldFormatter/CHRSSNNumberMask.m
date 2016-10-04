//
//  CHRSSNNumberMask.m
//  CHRTextFieldFormatterTest
//
//  Created by Ricardo Barroso on 04/10/2016.
//  Copyright © 2016 Ricardo Barroso. All rights reserved.
//

#import "CHRSSNNumberMask.h"

@implementation CHRSSNNumberMask

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    __typeof__(self) copy = [[self.class alloc] init];
    return copy;
}

#pragma mark - Masking

- (BOOL)shouldChangeText:(NSString *)text withReplacementString:(NSString *)string inRange:(NSRange)range {
    return YES;
}

- (NSString *)filteredStringFromString:(NSString *)string cursorPosition:(NSUInteger *)cursorPosition {
    NSUInteger originalCursorPosition = cursorPosition == NULL ? 0 : *cursorPosition;
    NSMutableString *digitsOnlyString = [NSMutableString new];
    for (NSUInteger i=0; i<[string length]; i++) {
        unichar characterToAdd = [string characterAtIndex:i];
        if (isdigit(characterToAdd)) {
            NSString *stringToAdd = [NSString stringWithCharacters:&characterToAdd length:1];
            
            [digitsOnlyString appendString:stringToAdd];
        }
        else {
            if (i < originalCursorPosition) {
                if (cursorPosition != NULL)
                    (*cursorPosition)--;
            }
        }
    }
    
    return digitsOnlyString;
    
}

- (NSString *)formattedStringFromString:(NSString *)string cursorPosition:(NSUInteger *)cursorPosition {
    NSMutableString *stringWithAddedHyphen = [NSMutableString new];
    NSUInteger cursorPositionInHyphenlessString = cursorPosition == NULL ? 0 : *cursorPosition;
    
    for (NSUInteger i = 0; i < string.length; i++) {
        BOOL shouldAppendHiphen = i == 3 || i == 5;
        
        if (shouldAppendHiphen) {
            [stringWithAddedHyphen appendString:@"-"];
            if (i < cursorPositionInHyphenlessString) {
                (*cursorPosition)++;
            }
        }
        
        unichar characterToAdd = [string characterAtIndex:i];
        NSString *stringToAdd = [NSString stringWithCharacters:&characterToAdd length:1];
        
        [stringWithAddedHyphen appendString:stringToAdd];
    }
    
    return stringWithAddedHyphen;
}

@end
