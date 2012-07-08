//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Donald Heering on 6/26/12.
//  Copyright (c) 2012 Bombadilla.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void) pushOperand:(double)operand;
- (double)performOperation:(NSString *)operation;
- (void)clearAll;

@end
