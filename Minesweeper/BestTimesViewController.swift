//
//  BestTimesViewController.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 7/11/25.
//

import Cocoa
import Defaults

class BestTimesViewController: NSViewController {

    @IBOutlet weak var beginner1Field: NSTextField!
    @IBOutlet weak var beginner2Field: NSTextField!
    @IBOutlet weak var beginner3Field: NSTextField!

    @IBOutlet weak var intermediate1Field: NSTextField!
    @IBOutlet weak var intermediate2Field: NSTextField!
    @IBOutlet weak var intermediate3Field: NSTextField!

    @IBOutlet weak var hard1Field: NSTextField!
    @IBOutlet weak var hard2Field: NSTextField!
    @IBOutlet weak var hard3Field: NSTextField!

    var textFields: [NSTextField] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        textFields = [
            beginner1Field, beginner2Field, beginner3Field, intermediate1Field, intermediate2Field,
            intermediate3Field, hard1Field, hard2Field, hard3Field,
        ]

        setUpTextFields()
    }

    override func viewDidAppear() {
        setUpTextFields()
    }

    private func setUpTextFields() {
        for i in 0..<textFields.count {
            if Defaults[.BestTimes.bestTimes][i] == -1 {
                textFields[i].stringValue = "-"
            } else {
                textFields[i].stringValue =
                    "\((Double(Defaults[.BestTimes.bestTimes][i]) * 100).rounded() / 100) s"
            }
        }
    }

    @IBAction func okButtonPressed(_ sender: NSButton) {
        self.dismiss(self)
    }

    @IBAction func resetScoresButtonPressed(_ sender: NSButton) {
        Defaults[.BestTimes.bestTimes] = [-1, -1, -1, -1, -1, -1, -1, -1, -1]
        setUpTextFields()
    }
}
