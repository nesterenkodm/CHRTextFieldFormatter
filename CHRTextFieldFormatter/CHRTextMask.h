//
//  CHRTextMask.h
//
//  Created by Dmitry Nesterenko on 12/05/15.
//  Copyright (c) 2015 e-legion. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CHRTextMask <NSObject, NSCopying>

- (BOOL)shouldChangeText:(NSString *)text withReplacementString:(NSString *)string inRange:(NSRange)range;
- (NSString *)filteredStringFromString:(NSString *)string cursorPosition:(NSUInteger *)cursorPosition;
- (NSString *)formattedStringFromString:(NSString *)string cursorPosition:(NSUInteger *)cursorPosition;

@end
