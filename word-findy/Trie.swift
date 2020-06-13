//
//  Trie.swift
//  word-findy
//
//  Created by Renee Sajedian on 6/12/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

class Trie {
    var root = TrieNode()
    
    func insert(word: String) {
        var currNode = root
        for char in Array(word) {
            //advances currNode by one character
            currNode = currNode.findOrCreateChild(for: char)
        }
        //when finished adding characters, mark end of word
        currNode.isEndOfWord = true
    }
//    
//    func lastNodeOf(prefix: String) -> TrieNode? {
//        var currNode = root
//        for char in Array(word) {
//            guard let currNode = currNode.children[char] else {
//                return false
//            }
//        }
//    }
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
