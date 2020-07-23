//
//  Game.swift
//  word-findy
//
//  Created by Renee Sajedian on 7/14/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import Foundation
import UIKit

enum GuessType: String {
    case incorrect = "incorrect"
    case alreadyGuessed = "already guessed"
    case correct = "correct!"
}

struct Game {
    var secondsRemaining = 180
    var score = 0
    var wordsOnBoard = Set<String>()
    var correctWords = Set<String>()
    var board = Board()
    var guessType: GuessType?
    var wordGuessed: String?
    var scoreAddition: Int = 0

    var displayColor: UIColor {
        switch guessType {
        case .incorrect, .alreadyGuessed:
            return .purple
        default:
            return .green
        }
    }

    var scoreAdditionDisplay: String {
        if scoreAddition > 0 {
            return "+\(scoreAddition)"
        } else {
            return ""
        }
    }

    var timeRemainingDisplay: String {
        let minutes = secondsRemaining / 60
        let seconds = secondsRemaining % 60
        if seconds < 10 {
            return "\(minutes):0\(seconds)"
        } else {
            return "\(minutes):\(seconds)"
        }
    }
}
