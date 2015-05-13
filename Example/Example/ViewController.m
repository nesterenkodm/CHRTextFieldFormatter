//
//  ViewController.m
//  Example
//
//  Created by Dmitry Nesterenko on 14/05/15.
//  Copyright (c) 2015 e-legion. All rights reserved.
//

#import "ViewController.h"
#import "CHRTextFieldFormatter.h"
#import "CHRPhoneNumberMask.h"
#import "CHRCardNumberMask.h"

@interface ViewController () <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *phoneNumberTextField;
@property (nonatomic, strong) IBOutlet UITextField *cardNumberTextField;

@property (nonatomic, strong) CHRTextFieldFormatter *phoneNumberFormatter;
@property (nonatomic, strong) CHRTextFieldFormatter *cardNumberFormatter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.phoneNumberFormatter = [[CHRTextFieldFormatter alloc] initWithTextField:self.phoneNumberTextField mask:[CHRPhoneNumberMask new]];
    self.cardNumberFormatter = [[CHRTextFieldFormatter alloc] initWithTextField:self.cardNumberTextField mask:[CHRCardNumberMask new]];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.phoneNumberTextField) {
        return [self.phoneNumberFormatter textField:textField shouldChangeCharactersInRange:range replacementString:string];
    } else if (textField == self.cardNumberTextField) {
        return [self.cardNumberFormatter textField:textField shouldChangeCharactersInRange:range replacementString:string];
    } else {
        return YES;
    }
}

@end
