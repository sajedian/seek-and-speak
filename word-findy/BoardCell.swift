//
//  BoardCell.swift
//  word-findy
//
//  Created by Renee Sajedian on 6/12/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import UIKit

class BoardCell: UICollectionViewCell {

    @IBOutlet var letter: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 1, height: 1)
        contentView.layer.shadowRadius = 3
        contentView.layer.shadowOpacity = 1
        contentView.layer.masksToBounds = true
    }
}
