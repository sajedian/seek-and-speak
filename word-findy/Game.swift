//
//  Game.swift
//  word-findy
//
//  Created by Renee Sajedian on 7/14/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import Foundation

enum GuessType: String {
    case incorrect = "Incorrect"
    case alreadyGuessed = "Already Guessed"
    case correct = "Correct!"

}

struct Game {
    var secondsRemaining = 180
    var score = 0
    var wordsOnBoard = Set<String>()
    var correctWords = Set<String>()
    var board = Board()
    var guessType: GuessType?
    var wordGuessed: String?

}
