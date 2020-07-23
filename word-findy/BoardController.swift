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
}
    // UICollectionViewDataSource method
extension BoardController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ : UICollectionView, layout: UICollectionViewLayout, sizeForItemAt: IndexPath) -> CGSize {
        let width = collectionView.frame.size.height / 4 - 5


        return CGSize(width: width, height: width)
    }

    func collectionView(_ : UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        let cellWidthPadding = CGFloat(1)
        let cellHeightPadding = CGFloat(1)
        return UIEdgeInsets(top: cellHeightPadding,left: cellWidthPadding, bottom: cellHeightPadding,right: cellWidthPadding)
    }
}


    // UICollectionViewDelegateFlowLayout method




