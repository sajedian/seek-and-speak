//
//  GameController.swift
//  word-findy
//
//  Created by Renee Sajedian on 7/14/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import Foundation

protocol GameControllerDelegate: class {
    func timerDidCountDown(timeRemaining: String)
    func timerDidFinish()
    func newGameStarted()
}

class GameController {

    weak var delegate: GameControllerDelegate?

    var game: Game!
    var dictionaryTrie: Trie!
    var timer: Timer!
    var displayText: String {
        if let guessType = game.guessType, let wordGuessed = game.wordGuessed {
            return "\(wordGuessed) - \(guessType.rawValue)"
        } else {
            return "Guess a word!"
        }
    }

    init(dict: Trie) {
        dictionaryTrie = dict
        newGame()
    }

    func playerGuessed(text word: String) {
        game.wordGuessed = word
        if !game.wordsOnBoard.contains(word) {
            game.guessType = .incorrect
            game.scoreAddition = 0
        } else if game.correctWords.contains(word) {
            game.guessType = .alreadyGuessed
            game.scoreAddition = 0
        } else {
            game.guessType = .correct
            game.correctWords.insert(word)
            updateScore(wordLength: word.count)
        }
    }

    func playerGuessed(speech words: [String]) {
        for word in words {
            if !game.wordsOnBoard.contains(word) || game.correctWords.contains(word) {
               continue
            } else {
                game.guessType = .correct
                game.wordGuessed = word
                game.correctWords.insert(word)
                updateScore(wordLength: word.count)
                return
            }
        }
        game.wordGuessed = words[0]
        if !game.wordsOnBoard.contains(words[0]) {
            game.guessType = .incorrect
            game.scoreAddition = 0
        } else {
            game.guessType = .alreadyGuessed
            game.scoreAddition = 0
        }

    }

    @objc func countDownTimerFired() {
        print(game.secondsRemaining)
        game.secondsRemaining -= 1
        if game.secondsRemaining < 0 {
            delegate?.timerDidFinish()
            timer.invalidate()
        } else {
            delegate?.timerDidCountDown(timeRemaining: game.timeRemainingDisplay)
        }
    }

    func updateScore(wordLength: Int) {
        let scoreAddition: Int
        switch wordLength {
        case 0...2:
            scoreAddition = 0
        case 3...4:
            scoreAddition = 1
        case 5:
            scoreAddition = 2
        case 6:
            scoreAddition = 3
        case 7:
            scoreAddition = 5
        default:
            scoreAddition = 11
        }
        game.score += scoreAddition
        game.scoreAddition = scoreAddition
    }

    func newGame() {
        game = Game()
        game.wordsOnBoard = dictionaryTrie.solve(board: game.board)
        delegate?.newGameStarted()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDownTimerFired), userInfo: nil, repeats: true)
    }

}
