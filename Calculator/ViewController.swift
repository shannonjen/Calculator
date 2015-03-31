//
//  ViewController.swift
//  Calculator
//
//  Created by Jen on 3/24/15.
//  Copyright (c) 2015 Jen. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var historyDisplay: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    
    
    
    //instance variable
    var brain = CalculatorBrain()
    
    @IBAction func clearAll() {
        userIsInTheMiddleOfTypingANumber = false
        displayValue = nil
        //display.text = "0"
        historyDisplay.text = " "
        brain.resetStack()
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        //add float capability to ui
        //display.text!.rangeOfString(".") returns nil if the display does not contain a .
        if digit == "." && display.text!.rangeOfString(".") != nil {
            return
        }
        if userIsInTheMiddleOfTypingANumber{
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    //user presses an operation button
    @IBAction func operate(sender: UIButton) {
        //if user hit the operation button after typing a number, enter that number first
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
             historyDisplay.text = historyDisplay.text! + sender.currentTitle! + ","
            if let result = brain.performOperation(operation){
                displayValue = result
               
            } else {
                //need to make displayValue an optional so this is nil
                displayValue = nil
            }
        }
    }
    
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        historyDisplay.text = historyDisplay.text! + display.text! + ","
        //push operand onto the stack
        //update display
        //every time push operand, up display value with evaluation
        if let result = brain.pushOperand(displayValue!) {
            displayValue = result
        } else {
            //need to make displayValue an optional so this is nil
            displayValue = nil
        }
    }
    
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
            
        } set {
            //newValue is default parameter
            if newValue != nil{
                display.text = "\(newValue!)"
            }
            else{
                display.text = "0"
            }
        }
    }
}

