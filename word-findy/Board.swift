//
//  Board.swift
//  word-findy
//
//  Created by Renee Sajedian on 6/12/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import Foundation

struct Board {
    var letters = [String]()
    var rows = 4
    var cols = 4
    init() {
        for die in dice {
            letters.append(die.randomElement()!.lowercased())
        }
        letters.shuffle()
    }
    let dice: [[String]] = [
        ["A", "A", "E", "E", "G", "N"],
        ["E", "L", "R", "T", "Y", "Y"],
        ["A", "O", "O", "T", "T", "W"],
        ["A", "B", "B", "J", "O", "O"],
        ["E", "H", "R", "T", "V", "W"],
        ["C", "I", "M", "O", "T", "U"],
        ["D", "I", "S", "T", "Y", "Y"],
        ["E", "I", "O", "S", "S", "T"],
        ["D", "E", "L", "R", "V", "Y"],
        ["A", "C", "H", "O", "P", "S"],
        ["H", "I", "M", "N", "Q", "U"],
        ["E", "E", "I", "N", "S", "U"],
        ["E", "E", "G", "H", "N", "W"],
        ["A", "F", "F", "K", "P", "S"],
        ["H", "L", "N", "N", "R", "Z"],
        ["D", "E", "I", "L", "R", "X"]
    ]

    func indexFromRowCol(row: Int, col: Int) -> Int {
        return row * cols + col
    }

    func rowColFromIndex(index: Int) -> (Int, Int) {
        return index.quotientAndRemainder(dividingBy: cols)
    }
}
