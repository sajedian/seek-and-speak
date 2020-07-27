//
//  Trie.swift
//  word-findy
//
//  Created by Renee Sajedian on 6/12/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import Foundation

class Trie {
    var root = TrieNode()

    init() {
        if let dictionaryURL = Bundle.main.url(forResource: "web2", withExtension: "txt") {
           if let dictText = try? String(contentsOf: dictionaryURL) {
               let dictionary = dictText.components(separatedBy: "\n")
               for word in dictionary {
                   self.insert(word: word)
               }
               return
           }
        }
        fatalError("Could not find dictionary")
    }

    func insert(word: String) {
        if word.isEmpty {
            return
        }
        var currNode = root
        for char in Array(word) {
            //advances currNode by one character
            currNode = currNode.findOrCreateChild(for: char)
        }
        //when finished adding characters, mark end of word
        currNode.isEndOfWord = true
    }

    func contains(word: String) -> Bool {
        if word.isEmpty {
            return false
        }
        var currNode = root
        for char in Array(word) {
            if let nextNode = currNode.children[char] {
                currNode = nextNode
            } else {
                return false
            }
        }
        return currNode.isEndOfWord
    }

    func solve(board: Board) -> Set<String> {
        var foundWords = Set<String>()
        for (index, letter) in board.letters.enumerated() {
            if let nextNode = root.children[Character(letter)] {
                foundWords.formUnion(solveFromStartLetter(board: board, index: index, currNode: nextNode))
            }
        }
        return foundWords
    }

    func solveFromStartLetter(board: Board, index: Int, visited: Set<Int> = [],
                              currNode: TrieNode, prefix: String = "") -> Set<String> {

        let letter = board.letters[index]

        let visited = visited.union([index])
        let prefix = prefix + letter
        var foundWords = Set<String>()
        if currNode.isEndOfWord && prefix.count > 2 && letter != "q" {
            foundWords.insert(prefix)
        }
        //if the current node has no children, stop checking
        guard !currNode.children.isEmpty else {
            return foundWords
        }

        //handle Qu tile
        //if it's a q, step forward one node to "u" without moving in board
        if letter == "q" {
            if let nextNode = currNode.children["u"] {
                var board = board
                board.letters[index] = "u"
                foundWords.formUnion(solveFromStartLetter(board: board, index: index,
                                                          visited: visited, currNode: nextNode, prefix: prefix))
                return foundWords
            }
        }

        //let char = Character(board.letters[index])
        let (row, col) = board.rowColFromIndex(index: index)

        for rowIndex in row-1...row+1 {
            //continue if we're off the board
            guard rowIndex >= 0 && rowIndex < board.rows else { continue }

            for colIndex in col-1...col+1 {
                //continue if we're off the board
                guard colIndex >= 0 && colIndex < board.cols else { continue }
                let nextIndex = board.indexFromRowCol(row: rowIndex, col: colIndex)
                //continue if index has already been used, this will include starting index
                guard !visited.contains(nextIndex) else { continue }
                let nextChar = Character(board.letters[nextIndex])
                if let nextNode = currNode.children[nextChar] {
                    foundWords.formUnion(solveFromStartLetter(board: board, index: nextIndex,
                                                              visited: visited, currNode: nextNode, prefix: prefix))
                    }
                }
            }

        return foundWords
        }
}

class TrieNode {
    var children: [Character: TrieNode] = [:]
    var isEndOfWord = false
    func findOrCreateChild(for char: Character) -> TrieNode {
        if let child = children[char] {
            return child
        } else {
            let child = TrieNode()
            children[char] = child
            return child
        }
    }
}
