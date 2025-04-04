//
//  ContentView.swift
//  Calculator
//
//  Created by Stephen Tim on 2025/3/21.
//

import SwiftUI

struct ContentView: View {
    @State private var display = "0"                  // 当前显示内容
    @State private var firstOperand = 0.0             // 存储第一个操作数
    @State private var currentOperator: Operator?     // 当前选择的运算符
    @State private var isTypingNumber = false         // 跟踪用户是否正在输入数字
    
    enum Operator {
        case add, subtract, multiply, divide
    }
    
    let buttons: [[String]] = [
        ["C", "±", "%", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", ".", "="]
    ]

    var body: some View {
        VStack(spacing: 12) {
            // 显示区域
            Text(display)
                .font(.system(size: 64))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundColor(.green)
                .background(Color(UIColor.darkGray))
                .cornerRadius(12)
                .padding()
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            // 按钮布局
            ForEach(buttons, id: \.self) { row in
                HStack(spacing: 12) {
                    ForEach(row, id: \.self) { button in
                        CalculatorButton(
                            title: button,
                            action: { self.handleButtonPress(button) },
                            isWide: button == "0"
                        )
                    }
                }
            }
        }
        .padding(12)
    }
    
    func handleButtonPress(_ button: String) {
        switch button {
        case "0"..."9":
            handleNumber(button)
        case ".":
            handleDecimal()
        case "C":
            clear()
        case "±":
            toggleSign()
        case "%":
            calculatePercentage()
        case "+", "-", "×", "÷":
            setOperator(button)
        case "=":
            performCalculation()
        default:
            break
        }
    }
    
    func handleNumber(_ number: String) {
        if isTypingNumber {
            display += number
        } else {
            display = number
            isTypingNumber = true
        }
    }
    
    func handleDecimal() {
        if !display.contains(".") {
            display += "."
            isTypingNumber = true
        }
    }
    
    func clear() {
        display = "0"
        firstOperand = 0
        currentOperator = nil
        isTypingNumber = false
    }
    
    func toggleSign() {
        if let value = Double(display) {
            display = String(value * -1)
        }
    }
    
    func calculatePercentage() {
        if let value = Double(display) {
            display = String(value / 100)
        }
    }
    
    func setOperator(_ Operator: String) {
        firstOperand = Double(display) ?? 0
        isTypingNumber = false
        
        switch Operator {
        case "+": currentOperator = .add
        case "-": currentOperator = .subtract
        case "×": currentOperator = .multiply
        case "÷": currentOperator = .divide
        default: break
        }
    }
    
    func performCalculation() {
        guard let operator1 = currentOperator else { return }
        let secondOperand = Double(display) ?? 0
        
        switch operator1 {
        case .add:
            display = String(firstOperand + secondOperand)
        case .subtract:
            display = String(firstOperand - secondOperand)
        case .multiply:
            display = String(firstOperand * secondOperand)
        case .divide:
            display = secondOperand != 0 ? String(firstOperand / secondOperand) : "Error"
        }
        
        isTypingNumber = false
        currentOperator = nil
    }
}

struct CalculatorButton: View {
    let title: String
    let action: () -> Void
    var isWide: Bool = false
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 28))
                .frame(width: isWide ? 160 : 70, height: 70)
                .background(buttonBackground)
                .foregroundColor(buttonForeground)
                .clipShape(Capsule())
        }
    }
    
    var buttonBackground: Color {
        if title == "C" || title == "±" || title == "%" {
            return Color(.lightGray)
        } else if ["÷", "×", "-", "+", "="].contains(title) {
            return .orange
        }
        return Color(.darkGray)
    }
    
    var buttonForeground: Color {
        [.orange, .black, .white].contains(buttonBackground) ? .white : .black
    }
}
