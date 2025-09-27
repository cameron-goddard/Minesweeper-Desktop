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

    @State private var rowsError: Bool = false
    @State private var colsError: Bool = false

    var maxMines: Double {
        guard let r = Int(rows), let c = Int(columns) else {
            return 0
        }

        guard r > 0, c > 0 else {
            return 0
        }
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
                    VStack(alignment: .leading) {
                        TextField("Rows", text: $rows, prompt: Text("Rows"))
                        if rowsError {
                            Text("Invalid number of rows")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }

                    VStack(alignment: .leading) {
                        TextField("Columns", text: $columns, prompt: Text("Columns"))
                        if colsError {
                            Text("Invalid number of columns")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }

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
                    if rows == "" || columns == "" {
                        return
                    }
                    if rowsError || colsError {
                        return
                    }

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
            .onChange(
                of: rows,
                perform: { input in
                    if let val = Int(input), val > 0 {
                        rowsError = false
                    } else {
                        rowsError = true
                    }
                }
            )
            .onChange(
                of: columns,
                perform: { input in
                    if let val = Int(input), val > 0 {
                        colsError = false
                    } else {
                        colsError = true
                    }
                })
        }
        .frame(width: 350)
        .fixedSize(horizontal: false, vertical: true)
    }
}
