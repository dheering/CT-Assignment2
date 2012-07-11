//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Donald Heering on 6/26/12.
//  Copyright (c) 2012 Bombadilla.com. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "Variable.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSDictionary *testVariableValues;
- (void)updateDisplayLabels;
@end

@implementation CalculatorViewController
@synthesize display = _display;
@synthesize sendToBrainDisplay = _sendToBrainDisplay;
@synthesize variablesDisplay = _variablesDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;
@synthesize testVariableValues = _testVariableValues;

- (CalculatorBrain *)brain
{
    if (!_brain)
        _brain = [[CalculatorBrain alloc] init];
    return _brain;
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
    if (!self.userIsInTheMiddleOfEnteringANumber)
    {
        self.display.text = [NSString stringWithString:@"0."];
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
    else if ([self.display.text rangeOfString:@"."].location == NSNotFound)
    {
        self.display.text = [self.display.text stringByAppendingString:@"."];
    }
}

- (IBAction)enterPressed 
{
    double value = [self.display.text doubleValue];
    [self.brain pushOperand:value];

    [self updateDisplayLabels];
    
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)operationPressed:(UIButton *)sender 
{
    if (self.userIsInTheMiddleOfEnteringANumber)
        [self enterPressed];
    NSString *operation = [sender currentTitle];
    [self.brain performOperation:operation];
    
    [self updateDisplayLabels];
}

- (IBAction)clearPressed 
{
    self.userIsInTheMiddleOfEnteringANumber = NO;
    [self.brain clearAll];
    
    [self updateDisplayLabels];
}

- (IBAction)undoPressed 
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
            self.userIsInTheMiddleOfEnteringANumber = NO;
            [self updateDisplayLabels];
        }
    }
    else 
    {
        [self.brain removeLastItemFromProgram];
        [self updateDisplayLabels];
    }
}

- (IBAction)variablePressed:(UIButton *)sender 
{
    if (self.userIsInTheMiddleOfEnteringANumber)
        [self enterPressed];
    NSString *variable = [sender currentTitle];
    [self.brain pushVariable:variable];
}

- (IBAction)changeSign:(UIButton *)sender
{
    if (self.userIsInTheMiddleOfEnteringANumber)
        self.display.text = [NSString stringWithFormat:@"%g", -[self.display.text doubleValue]];
    else 
        [self operationPressed:sender];
}

- (void)updateDisplayLabels
{
    double result = [CalculatorBrain runProgram:self.brain.program usingVariables:self.testVariableValues];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    self.sendToBrainDisplay.text = [CalculatorBrain descriptionOfProgram:self.brain.program];

    self.variablesDisplay.text = @"";
    NSSet *variablesInProgram = [CalculatorBrain variablesUsedInProgram:self.brain.program];
    for (id item in variablesInProgram) 
    {
        self.variablesDisplay.text = [self.variablesDisplay.text stringByAppendingFormat:@" %@=%@", 
                                      item, 
                                      [self.testVariableValues objectForKey:item]];
    }
}

- (IBAction)testVariableValuesPressed:(UIButton *)sender
{
    NSString *testSetTitle = [sender currentTitle];
    if ([testSetTitle isEqualToString:@"Test 1"])
        self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithFloat:125.2], @"x",
                                   [NSNumber numberWithFloat:1.25],  @"a",
                                   [NSNumber numberWithFloat:-1.25], @"b",
                                   nil];
    else if ([testSetTitle isEqualToString:@"Test 2"])
        self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithFloat:1], @"x",
                                   [NSNumber numberWithFloat:2],  @"a",
                                   [NSNumber numberWithFloat:3], @"b",
                                   nil];
    else if ([testSetTitle isEqualToString:@"Test 0"])
        self.testVariableValues = nil;
    
    [self updateDisplayLabels];
}

- (void)viewDidUnload {
    [self setSendToBrainDisplay:nil];
    [self setVariablesDisplay:nil];
    [super viewDidUnload];
}
@end
