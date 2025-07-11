//
//  StatsViewController.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 8/5/22.
//

import Cocoa
import OrderedCollections

class StatsViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var timerField: NSTextField!

    var stats: OrderedDictionary = [
        "3BV": 0,
        "3BV/s": 0.0,
        "Left": 0,
        "Right": 0,
        "Middle": 0,
        "Estimated": 0,
    ]

    var revealStats: Bool = false
    var elapsedTime: TimeInterval = 0
    var total3BV: Int = 0
    var totalClicks: Int = 0
    var effectiveClicks: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        view.wantsLayer = true
        // TODO: Change to default value
        view.layer?.backgroundColor = NSColor(red: 226, green: 226, blue: 226, alpha: 1).cgColor

        NotificationCenter.default.addObserver(
            self, selector: #selector(self.updateStat(_:)), name: .updateStat, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.resetStats(_:)), name: .resetStats, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.revealStats(_:)), name: .revealStats, object: nil)
    }

    @objc func updateStat(_ notification: Notification) {
        let statName = notification.userInfo!.keys.first! as! String
        let statValue = notification.userInfo!.values.first! as! Int

        if statName == "NonEffective" {
            totalClicks += 1
        }
        if statName == "Effective" {
            totalClicks += 1
            effectiveClicks += 1
        }

        if statName == "Total3BV" {
            total3BV = statValue
        }

        if statName == "3BV" {
            stats["3BV"]! += Double(1)
        }

        if statName == "Left" {
            stats["Left"]! += 1
        }

        if statName == "Right" {
            stats["Right"]! += 1
        }

        if statName == "Middle" {
            stats["Middle"]! += 1
        }

        //        TODO: Add back in
        //        if (totalClicks == 0) {
        //            stats["IOE"] = 0
        //            stats["Throughput"] = 0
        //        } else {
        //            stats["IOE"] = Double(round(stats["3BV"]! / Double(totalClicks)) / 1000)
        //            stats["Throughput"] = Double(round(stats["3BV"]! / Double(effectiveClicks)) / 1000)
        //        }

        tableView.reloadData()
    }

    @objc func revealStats(_: Notification) {
        revealStats = true

        // Calculate time-based stats
        if elapsedTime.magnitude == 0 {
            stats["3BV/s"] = 0
            stats["Estimated"] = 0
        } else {
            stats["3BV/s"] = Double(
                round(1000 * (Double(effectiveClicks) / elapsedTime.magnitude)) / 1000)
            stats["Estimated"] = Double(total3BV) / (Double(totalClicks) / elapsedTime.magnitude)
        }

        tableView.reloadData()
    }

    @objc func resetStats(_: Notification) {
        totalClicks = 0
        effectiveClicks = 0

        for i in 0..<stats.values.count {
            stats.values[i] = 0
        }

        revealStats = false
    }
}

extension StatsViewController: GameTimerDelegate {

    func updateTime(_ time: TimeInterval) {
        elapsedTime = time
        let seconds = Int(elapsedTime)
        let hundredths = Int((elapsedTime.truncatingRemainder(dividingBy: 1)) * 100)

        DispatchQueue.main.async {
            self.timerField.stringValue = String(format: "%d.%02d", seconds, hundredths)
        }

        //        TODO: Add back in
        //        if (elapsedTime.magnitude == 0) {
        //             stats["IOS"] = 0
        //             stats["RQP"] = 0
        //        } else {
        //             stats["IOS"] = Double(round(1000 * log(stats["3BV"]!) / log(elapsedTime.magnitude)) / 1000)
        //             stats["RQP"] = Double(round(1000 * elapsedTime.magnitude / stats["3BV/s"]!) / 1000)
        //        }
    }

}

extension StatsViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return stats.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableColumn == tableView.tableColumns[0] {
            guard
                let statsLabelCell = tableView.makeView(
                    withIdentifier: .init(rawValue: "statsLabelCell"),
                    owner: self) as? NSTableCellView
            else { return nil }
            statsLabelCell.textField!.stringValue = stats.elements[row].key
            return statsLabelCell
        } else {
            guard
                let statsValueCell = tableView.makeView(
                    withIdentifier: .init(rawValue: "statsValueCell"),
                    owner: self) as? NSTableCellView
            else { return nil }

            switch stats.elements[row].key {
            case "3BV":
                if revealStats {
                    statsValueCell.textField!.stringValue =
                        "\(Int(stats.elements[row].value))/\(total3BV)"
                } else {
                    statsValueCell.textField!.stringValue = "•/•"
                }
            case "3BV/s", "Estimated":
                if revealStats {
                    statsValueCell.textField!.stringValue = String(
                        format: "%.2f", stats.elements[row].value)
                } else {
                    statsValueCell.textField!.stringValue = "•••"
                }
            case "Left", "Middle", "Right":
                statsValueCell.textField!.stringValue = "\(Int(stats.elements[row].value))"
            default: break
            }

            return statsValueCell
        }
    }
}

extension StatsViewController: NSTableViewDelegate {

}
