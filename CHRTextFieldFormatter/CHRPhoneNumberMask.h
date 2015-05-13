//
//  CHRPhoneNumberMask.h
//
//  Created by Dmitry Nesterenko on 12/05/15.
//  Copyright (c) 2015 e-legion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHRTextMask.h"

@interface CHRPhoneNumberMask : NSObject <CHRTextMask>

/**
 Specifies not editable phone number prefix.
 
 Phone number prefix will be separated by a whitespace from the actual phone number.
 */
@property (nonatomic, copy) NSString *prefix;

@end
