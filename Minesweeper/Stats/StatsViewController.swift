//
//  StatsViewController.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 8/5/22.
//

import Cocoa

class StatsViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var timerField: NSTextField!
    
    var stats = ["3BV", "3BV/s", "IOS", "RQP", "IOE", "Correctness"]
    var values = [0, 0, 0, 0, 0, 0]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor(red: 226, green: 226, blue: 226, alpha: 1).cgColor //change to default value
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateStat(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTime(notification:)), name: Notification.Name("UpdateTime"), object: nil)
    }
    
    @objc func updateStat(notification: Notification) {
        let statName = notification.userInfo!.keys.first! as! String
        let statValue = notification.userInfo!.values.first! as! Int
        print(statName)
        print(statValue)
        values[stats.firstIndex{$0 == "3BV"}!] = statValue
        tableView.reloadData()
    }
    
    @objc func updateTime(notification: Notification) {
        let elapsedTime = notification.object as! TimeInterval
        let seconds = Int(elapsedTime)
        let hundredths = Int((elapsedTime.truncatingRemainder(dividingBy: 1)) * 100)
        
        timerField.stringValue = String(format: "%d.%02d", seconds, hundredths)
    }
}

extension StatsViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return stats.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableColumn == tableView.tableColumns[0] {
            guard let statsLabelCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "statsLabelCell"), owner: self) as? NSTableCellView else { return nil }
            statsLabelCell.textField!.stringValue = stats[row]
            return statsLabelCell
        } else {
            guard let statsValueCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "statsValueCell"), owner: self) as? NSTableCellView else { return nil }
            statsValueCell.textField!.integerValue = values[row]
            return statsValueCell
        }
    }
}

extension StatsViewController: NSTableViewDelegate {
    
}
