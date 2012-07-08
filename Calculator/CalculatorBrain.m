//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Donald Heering on 6/26/12.
//  Copyright (c) 2012 Bombadilla.com. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *operandStack;
@end

@implementation CalculatorBrain

@synthesize operandStack = _operandStack;

- (NSMutableArray *)operandStack
{
    if (!_operandStack)
        _operandStack = [[NSMutableArray alloc] init];
    return _operandStack;
}

- (void) clearAll
{
    self.operandStack = nil;
}

- (void) pushOperand:(double)operand
{
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)popOperand
{
    NSNumber *operandObject = [self.operandStack lastObject];
    if (operandObject) [self.operandStack removeLastObject];
    return [operandObject doubleValue];
}

- (double)performOperation:(NSString *)operation
{
    double result = 0;
    
    // perform the operation here, store in result
    if ([operation isEqualToString:@"+"])
    {
        result = [self popOperand] + [self popOperand];
    }
    else if ([operation isEqualToString:@"*"])
    {
        result = [self popOperand] * [self popOperand];
    }
    else if ([operation isEqualToString:@"-"])
    {
        double subtrahend = [self popOperand];
        result = [self popOperand] - subtrahend;
    }
    else if ([operation isEqualToString:@"/"])
    {
        double divisor = [self popOperand];
        if (divisor) result = [self popOperand] / divisor;
    }
    else if ([operation isEqualToString:@"π"])
    {
        result = M_PI;
    }
    else if ([operation isEqualToString:@"sin"])
    {
        result = sin([self popOperand]);
    }
    else if ([operation isEqualToString:@"cos"])
    {
        result = cos([self popOperand]);
    }
    else if ([operation isEqualToString:@"sqrt"])
    {
        double value = [self popOperand];
        if (value > 0)
            result = sqrt(value);
        else
            result = 0;
    }
    else if ([operation isEqualToString:@"+/-"])
    {
        double value = [self popOperand];
        if (value > 0)
            result = -value;
        else
            result = value;
    }
    
    [self pushOperand:result];
    
    return result;
}

@end
