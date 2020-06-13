//
//  ViewController.swift
//  word-findy
//
//  Created by Renee Sajedian on 6/12/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BoardControllerDelegate {
    
    var boardVC: BoardController?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 141/255, green: 185/255, blue: 217/255, alpha: 1)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? BoardController {
            controller.delegate = self
            boardVC = controller
        }
    }
    
    


}

