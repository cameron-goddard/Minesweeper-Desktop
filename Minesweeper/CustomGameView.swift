//
//  CustomGameView.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 7/2/25.
//

import SwiftUI

struct CustomGameView: View {
    
    var onDismiss: (() -> Void)?
    
    @State private var rows: String = ""
    @State private var columns: String = ""
    @State private var mines: Double = 0
    
    var maxMines: Double {
        let r = Int(rows) ?? 0
        let c = Int(columns) ?? 0
        return Double(r * c)
    }
    
    var difficultyLabel: String {
        guard let r = Int(rows), let c = Int(columns) else {
            return "Unknown"
        }
        
        guard r > 0, c > 0 else {
            return "Unknown"
        }
        
        let ratio = maxMines / mines

        if ratio <= 1 {
            return "Impossible"
        } else if ratio < 5 {
            return "Hard"
        } else if ratio < 8 {
            return "Intermediate"
        } else {
            return "Easy"
        }
    }
    
    var body: some View {
        VStack {
            Form {
                Section {
                    TextField("Rows", text: $rows, prompt: Text("Rows"))
                    TextField("Columns", text: $columns, prompt: Text("Columns"))
                    Slider(value: $mines, in: 0...maxMines) {
                        Text("\(Int(mines)) Mines")
                    }
                } header: {
                    VStack(alignment: .leading) {
                        Text("Custom Game")
                        Text("Difficulty: \(difficultyLabel)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .formStyle(.grouped)
            .scrollContentBackground(.hidden)
            .scrollDisabled(true)

            Divider()

            HStack {
                Button("Random") {
                    rows = String(Int.random(in: 1..<40))
                    columns = String(Int.random(in: 1..<40))
                    mines = .random(in: 1..<maxMines)
                }
                Spacer()
                Button("Cancel") {
                    self.onDismiss?()
                }
                Button("Generate") {
                    NotificationCenter.default.post(
                        name: .newCustomGame,
                        object: [
                            Int(rows), Int(columns), Int(mines),
                        ], userInfo: nil)
                    
                    self.onDismiss?()
                }
                .keyboardShortcut(.defaultAction)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .padding(.top, 12)
            
        }
        .frame(width: 350, height: 265)
    }
}
