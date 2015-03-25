//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Jen on 3/25/15.
//  Copyright (c) 2015 Jen. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private enum Op {
        case Operand(Double)
        //single argument, String is the symbol, Double -> Double is function (functions are just types in swift)
        case UnaryOperation(String, Double -> Double)
        //two arguments
        case BinaryOperation(String, (Double, Double) -> Double)
    }
    
    //Array of Op
    private var opStack = [Op]()
    
    //Dictionary
    private var knownOps = [String:Op]()
    
    init(){
        knownOps["×"] = Op.BinaryOperation("×", *)
        knownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["−"] = Op.BinaryOperation("−") { $1 - $0 }
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
    }
    
    //recursion
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty {
            //make a copy, var is mutable -allows for removeLast() on Array
            var remainingOps = ops
            let op = remainingOps.removeLast()
            //pull associated values out of Op enum
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result{
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    //optional because it may return nothing
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        return result
    }
    
    func pushOperand(operand: Double) {
        opStack.append(Op.Operand(operand))
    }
    
    func performOperation(symbol: String) {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
    }
}
