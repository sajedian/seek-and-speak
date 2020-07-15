//
//  GameController.swift
//  word-findy
//
//  Created by Renee Sajedian on 7/14/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import Foundation



class GameController {

    var game: Game!
    var dictionaryTrie: Trie!
    var timer: Timer!
    var displayText: String {
        if let guessType = game.guessType, let wordGuessed = game.wordGuessed {
            return "\(wordGuessed) - \(guessType.rawValue)"
        } else {
            return "Guess a Word!"
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
        } else if game.correctWords.contains(word) {
            game.guessType = .alreadyGuessed
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
                return
            }
        }
        game.wordGuessed = words[0]
        if !game.wordsOnBoard.contains(words[0]) {
            game.guessType = .incorrect
        } else {
            game.guessType = .alreadyGuessed
        }

    }

    func updateScore(wordLength: Int) {

        switch wordLength {
        case 0...2:
            return
        case 3...4:
            game.score += 1
        case 5:
            game.score += 2
        case 6:
            game.score += 3
        case 7:
            game.score += 5
        default:
            game.score += 11
        }

    }
    

    func newGame() {
        game = Game()
        game.wordsOnBoard = dictionaryTrie.solve(board: game.board)
    }

}


