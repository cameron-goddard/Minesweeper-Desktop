//
//  CustomGameViewController.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 8/1/22.
//

import Cocoa

class CustomGameViewController: NSViewController {

    @IBOutlet weak var widthTextField: NSTextField!
    @IBOutlet weak var heightTextField: NSTextField!
    @IBOutlet weak var minesTextField: NSTextField!
    @IBOutlet weak var difficultyLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func randomButtonPressed(_ sender: Any) {
        // TODO: Add dynamic maximums based on screen size
        widthTextField.integerValue = .random(in: 1..<75)
        heightTextField.integerValue = .random(in: 1..<75)
        minesTextField.integerValue = .random(in: 1..<50)
        updateDifficulty()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(self)
    }
    
    @IBAction func generateButtonPressed(_ sender: Any) {
        if widthTextField.integerValue <= 0 {
            shake(textField: widthTextField)
            return
        }
        if heightTextField.integerValue <= 0 {
            shake(textField: heightTextField)
            return
        }
        if minesTextField.integerValue <= 0 || widthTextField.integerValue * heightTextField.integerValue < minesTextField.integerValue {
            shake(textField: minesTextField)
            return
        }
        
        self.dismiss(self)
        NotificationCenter.default.post(name: Notification.Name("NewCustomGame"), object: [widthTextField.integerValue, heightTextField.integerValue, minesTextField.integerValue], userInfo: nil)
    }
    
    private func shake(textField: NSTextField) {
        let midX = textField.layer?.position.x ?? 0
        let midY = textField.layer?.position.y ?? 0

        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.06
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: midX - 10, y: midY)
        animation.toValue = CGPoint(x: midX + 10, y: midY)
        textField.layer?.add(animation, forKey: "position")
    }
    
    private func updateDifficulty() {
        if !widthTextField.stringValue.isEmpty && !heightTextField.stringValue.isEmpty && !minesTextField.stringValue.isEmpty {
            
            let ratio: Int
            if minesTextField.integerValue == 0 {
                ratio = 100 // little bit hacky
            } else {
                ratio = widthTextField.integerValue * heightTextField.integerValue / minesTextField.integerValue
            }
            
            if ratio <= 1 {
                difficultyLabel.stringValue = "Difficulty: Impossible"
            }
            else if ratio < 5 {
                difficultyLabel.stringValue = "Difficulty: Hard"
            }
            else if ratio < 8 {
                difficultyLabel.stringValue = "Difficulty: Intermediate"
            }
            else {
                difficultyLabel.stringValue = "Difficulty: Easy"
            }
        }
    }
}

extension CustomGameViewController: NSTextFieldDelegate {
    
    func controlTextDidChange(_ obj: Notification) {
        updateDifficulty()
    }
}
