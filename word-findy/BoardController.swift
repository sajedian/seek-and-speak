//
//  BoardController.swift
//  word-findy
//
//  Created by Renee Sajedian on 6/12/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import UIKit

private let reuseIdentifier = "BoardCell"

protocol BoardControllerDelegate: class {
    
}

class BoardController: UICollectionViewController {
    
   
    
    var delegate: BoardControllerDelegate?
    
    var board: Board! {
        didSet {
            wordsOnBoard = dictionaryTrie.solve(board: board)
            print(wordsOnBoard)
        }
    }
    var dictionaryTrie: Trie!
    
    var wordsOnBoard: Set<String> = []
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor(red: 141/255, green: 185/255, blue: 217/255, alpha: 1)
        newBoard()
    }
    
    func newBoard() {
        board = Board()
    }
    

    var dictionary = ["aardvark", "bear", "beat", "boat", "best", "cat", "donkey", "done", "deed", "elephant", "elegant", "heed", "head", "deeded", "ceded", "dee", "had", "hah", "chad", "hhh"]
    
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return board.letters.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? BoardCell else {
            fatalError("Failed to dequeue BoardCell")
        }
    
        // Configure the cell
        cell.contentView.backgroundColor = UIColor.white
        let letter = board.letters[indexPath.item].uppercased()
        if letter == "Q" {
            cell.letter.text = "Qu"
        } else {
            cell.letter.text = letter
        }
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
