//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Jen on 3/25/15.
//  Copyright (c) 2015 Jen. All rights reserved.
//

//Core services layer
import Foundation

class CalculatorBrain
{
    //Printable is protocol (description)
    //This enum impliments printing protocol
    private enum Op: Printable
    {       
        //if enum is Operand, it will have a Double (the value) associated with it
        case Operand(Double)
        
        //operations have a symbol and a function
        //single argument (square root), String is the symbol, Double -> Double is function (functions are just types in Swift)
        case UnaryOperation(String, Double -> Double)
        //two arguments
        case BinaryOperation(String, (Double, Double) -> Double)
      
        case Constant(String, Double)
        
        case Variable(String)
        
        //add computed property to enum
        //read only (get)
        //returns op into a string
        //description is a string method
        var description: String {
            get {
                //switch on self
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .Constant(let symbol, _):
                    return symbol
                case .Variable(let symbol):
                    return symbol
                }
            }
            
        }
    }
    
    //Array of Operations and Operands - user input
    private var opStack = [Op]()
    
    //Create an empty Dictionary
    //this is used in performOperation function, which is called in viewcontroller operate function, which is called when the user presses one of the operation buttons
    private var knownOps = [String: Op]()
    
    private var variables = [String: Double]()
    
    var π = M_PI
    //Dictionary filled when class is initialized
    init(){
       
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("÷") { $1 / $0 })
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−") { $1 - $0 })
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("sin", sin))
        learnOp(Op.UnaryOperation("cos", cos))
        learnOp(Op.Constant("π",M_PI))
    }
    
    //recursion to evaluate the stack
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty {
            var remainingOps = ops
           
            let op = remainingOps.removeLast()
           
            switch op {
                
                case .Operand(let operand):
                    return (operand, remainingOps)
                case .Constant(_, let value):
                    return (value, remainingOps)
               
                case .UnaryOperation(_, let operation):
                    let operandEvaluation = evaluate(remainingOps)
                    if let operand = operandEvaluation.result {
                        //recurse with remaningOps of operationEvaluation
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
            case .Variable(let symbol):
                return (nil, remainingOps)
            }
        }
        return (nil, ops)
    }
    
    
    //calls evaluate on the whole array opStack and returns a double 
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        
        println("\(opStack) = \(result) with \(remainder) left over")
        let printStack = "\(opStack)"
        return result
    }
    
    //called when user presses enter button
    //the operand is the display value when user presses enter
    //return an evaluate to update display in enter function
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    
    func pushOperand(symbol: String) -> Double? {
        opStack.append(Op.Variable(symbol))
        return evaluate()
        
    }
    
    //called when user presses an operation button
    //the string symbol of the button is passed in
    func performOperation(symbol: String) -> Double? {
        //look through dictionary for symbol to find function
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
  
    
    func resetStack(){
        opStack = []
    }
}
