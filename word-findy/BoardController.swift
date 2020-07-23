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
    var gameController: GameController!
    var dictionaryTrie: Trie!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor(red: 141/255, green: 185/255, blue: 217/255, alpha: 1)
        collectionView.layer.masksToBounds = true
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return gameController.game.board.letters.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? BoardCell else {
            fatalError("Failed to dequeue BoardCell")
        }
    
        // Configure the cell
        cell.contentView.backgroundColor = UIColor.white
        let letter = gameController.game.board.letters[indexPath.item].uppercased()
        if letter == "Q" {
            cell.letter.text = "Qu"
        } else {
            cell.letter.text = letter
        }
        return cell
    }

    // UICollectionViewDataSource method

        func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        let numberOfSets = CGFloat(self.currentExSets.count)

        let width = (collectionView.frame.size.width - (numberOfSets * view.frame.size.width / 15))/numberOfSets

        let height = collectionView.frame.size.height / 2

        return CGSizeMake(width, height);
    }

    // UICollectionViewDelegateFlowLayout method

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAtIndex section: Int) -> UIEdgeInsets {

        let cellWidthPadding = collectionView.frame.size.width / 30
        let cellHeightPadding = collectionView.frame.size.height / 4
        return UIEdgeInsets(top: cellHeightPadding,left: cellWidthPadding, bottom: cellHeightPadding,right: cellWidthPadding)
    }

}
