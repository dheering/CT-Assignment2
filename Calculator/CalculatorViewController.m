//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Donald Heering on 6/26/12.
//  Copyright (c) 2012 Bombadilla.com. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSString *itemsSentToBrain;
@end

@implementation CalculatorViewController
@synthesize display = _display;
@synthesize sendToBrainDisplay = _sendToBrainDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;
@synthesize itemsSentToBrain = _itemsSentToBrain;

- (CalculatorBrain *)brain
{
    if (!_brain)
        _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (NSString *)itemsSentToBrain
{
    if (!_itemsSentToBrain)
        _itemsSentToBrain = [[NSString alloc] init];
    else if ([_itemsSentToBrain length] > 50)
        _itemsSentToBrain = [_itemsSentToBrain substringFromIndex:[_itemsSentToBrain length] - 50];
    return _itemsSentToBrain;
}

- (IBAction)digitPressed:(UIButton *)sender 
{
    NSString *digit = [sender currentTitle];
    if (self.userIsInTheMiddleOfEnteringANumber)
    {
        self.display.text = [self.display.text stringByAppendingString:digit];    
    }
    else 
    {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)decimalDotPressed:(UIButton *)sender 
{
    if ([self.display.text rangeOfString:@"."].location == NSNotFound)
    {
        self.display.text = [self.display.text stringByAppendingString:@"."];
        if (self.userIsInTheMiddleOfEnteringANumber == NO)
            self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)enterPressed 
{
    double value = [self.display.text doubleValue];
    [self.brain pushOperand:value];
    self.itemsSentToBrain = [self.itemsSentToBrain stringByAppendingFormat:@" %g", value];
    self.sendToBrainDisplay.text = self.itemsSentToBrain;
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)operationPressed:(UIButton *)sender 
{
    if (self.userIsInTheMiddleOfEnteringANumber)
        [self enterPressed];
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    self.itemsSentToBrain = [self.itemsSentToBrain stringByAppendingFormat:@" %@", operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    self.sendToBrainDisplay.text = [self.itemsSentToBrain stringByAppendingString:@" ="];
}

- (IBAction)clearPressed 
{
    self.userIsInTheMiddleOfEnteringANumber = NO;
    [self.brain clearAll];
    self.display.text = [NSString stringWithString:@"0"];
    self.sendToBrainDisplay.text = [NSString stringWithString:@""];
    self.itemsSentToBrain = nil;
}

- (IBAction)backspacePressed 
{
    if (self.userIsInTheMiddleOfEnteringANumber)
    {
        NSUInteger displayStringLength = [self.display.text length];
        if (displayStringLength > 1)
        {
            self.display.text = [self.display.text substringToIndex:displayStringLength - 1];
        }
        else
        {
            self.display.text = [NSString stringWithString:@"0"];
            self.userIsInTheMiddleOfEnteringANumber = NO;
        }
    }
}

- (IBAction)changeSign:(UIButton *)sender
{
    if (self.userIsInTheMiddleOfEnteringANumber)
        self.display.text = [NSString stringWithFormat:@"%g", -[self.display.text doubleValue]];
    else 
        [self operationPressed:sender];
}

- (void)viewDidUnload {
    [self setSendToBrainDisplay:nil];
    [super viewDidUnload];
}
@end
