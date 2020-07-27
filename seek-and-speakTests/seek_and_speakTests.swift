//
//  seek_and_speakTests.swift
//  seek-and-speakTests
//
//  Created by Renee Sajedian on 7/27/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import XCTest
@testable import seek_and_speak

//swiftlint:disable type_name
class trieTests: XCTestCase {

    var trie: Trie!
    var board: Board!

    override func setUpWithError() throws {
        //given
        trie = Trie()
        board = Board()
    }

    func testDictionaryLoadsQuickly() throws {
        measure {
            _ = Trie()
        }
    }

    func testSolve() {
        //given
        board.letters = ["y", "u", "i", "f",
                         "a", "h", "g", "a",
                         "e", "e", "d", "i",
                         "p", "r", "b", "y"]

        //when
        let correctWords = trie.solve(board: board)

        //then

        //words that are too short
        XCTAssertFalse(correctWords.contains(""), "solve should not include empty string")
        XCTAssertFalse(correctWords.contains("a"), "solve should not include one letter words")
        XCTAssertFalse(correctWords.contains("he"), "solve should not include two letter words")

        //words that are too long
        XCTAssertFalse(correctWords.contains("antidemocratically"), "solve should not find words that are too long")

        //correct words
        XCTAssertTrue(correctWords.contains("her"), "solve failed to find her which is a valid word")
        XCTAssertTrue(correctWords.contains("bider"), "solve failed to find bider which is a valid word")

        //invalid words of valid length
        XCTAssertFalse(correctWords.contains("fib"), "solve found fib which is not on board")
        XCTAssertFalse(correctWords.contains("ready"), "solve found ready which is not on board")

    }

    func testInsert() {
        //given
        board.letters = ["y", "u", "i", "f",
                         "a", "h", "g", "a",
                         "e", "e", "d", "i",
                         "p", "r", "b", "y"]

        //when
        //insert nonsense word
        trie.insert(word: "peayuif")

        //then
        //nonsense word should be in trie
        let correctWords = trie.solve(board: board)
        XCTAssertTrue(correctWords.contains("peayuif"), "word was not inserted correctly into trie")

        //prefix of nonsense word should not be in trie
        XCTAssertFalse(correctWords.contains("peayui"), "invalid prefix was asserted into trie")

    }
}

class trieNodeTests: XCTestCase {

    var trieNode: TrieNode!

    override func setUpWithError() throws {
        //given
        trieNode = TrieNode()
    }

    func testTrieNodeStartsOutEmpty() {
        //then
        XCTAssertTrue(trieNode.children.isEmpty, "trieNode should have no children when initialized")
    }

    func testFindOrCreateChildCreatesChild() {
        //when
        _ = trieNode.findOrCreateChild(for: "k")

        //then
        XCTAssertNotNil(trieNode.children["k"], "trieNode did not create child properly")
    }

    func testFindOrCreateChildDoesNotCreateDuplicate() {
        //when
        _ = trieNode.findOrCreateChild(for: "b")
        _ = trieNode.findOrCreateChild(for: "b")
        XCTAssertEqual(trieNode.children.count, 1, "trieNode should not create duplicate child")
    }
}

class boardTests: XCTestCase {

    var board: Board!

    override func setUpWithError() throws {
        //given
        board = Board()
    }

    func testBoardHasSixteenLetters() {
        //then
        XCTAssertEqual(board.letters.count, 16, "board.letters.count was not 16")
    }

    func testIndexFromRowColIsCorrect() {
        //then
        XCTAssertEqual(board.indexFromRowCol(row: 0, col: 0), 0, "row:0, col:0 was not index:0")
        XCTAssertEqual(board.indexFromRowCol(row: 1, col: 0), 4, "row:1, col:0 was not index:4")
        XCTAssertEqual(board.indexFromRowCol(row: 0, col: 3), 3, "row:0, col:3 was not index:3")
        XCTAssertEqual(board.indexFromRowCol(row: 2, col: 2), 10, "row:2, col:2 was not index:10")
        XCTAssertEqual(board.indexFromRowCol(row: 3, col: 3), 15, "row:3, col:3 was not index:15")
    }

    func testRowColFromIndexIsCorrect() {
        //then
        var (row, col) = board.rowColFromIndex(index: 0)
        XCTAssertEqual(row, 0, "row was not 0 for index 0")
        XCTAssertEqual(col, 0, "col was not 9 for index 0")

        (row, col) = board.rowColFromIndex(index: 2)
        XCTAssertEqual(row, 0, "row was not 0 for index 2")
        XCTAssertEqual(col, 2, "col was not 2 for index 2")

        (row, col) = board.rowColFromIndex(index: 11)
        XCTAssertEqual(row, 2, "row was not 2 for index 11")
        XCTAssertEqual(col, 3, "col was not 3 for index 11")
    }
}

class gameTests(){
    
}
