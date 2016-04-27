//
//  CHRCardNumberMask.m
//
//  Created by Dmitry Nesterenko on 14/05/15.
//  Copyright (c) 2015 e-legion. All rights reserved.
//

#import "CHRCardNumberMask.h"

@implementation CHRCardNumberMask

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
    NSMutableString *stringWithAddedSpaces = [NSMutableString new];
    NSUInteger cursorPositionInSpacelessString = cursorPosition == NULL ? 0 : *cursorPosition;
    for (NSUInteger i=0; i<[string length]; i++) {
        if ((i>0) && ((i % 4) == 0)) {
            [stringWithAddedSpaces appendString:@" "];
            if (i < cursorPositionInSpacelessString) {
                (*cursorPosition)++;
            }
        }
        unichar characterToAdd = [string characterAtIndex:i];
        NSString *stringToAdd =
        [NSString stringWithCharacters:&characterToAdd length:1];
        
        [stringWithAddedSpaces appendString:stringToAdd];
    }
    
    return stringWithAddedSpaces;
}

@end
