//
//  ViewController.swift
//  word-findy
//
//  Created by Renee Sajedian on 6/12/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BoardControllerDelegate {
    
    var boardVC: BoardController!
    var dictionaryTrie: Trie!
    @IBOutlet var textField: UITextField!
    @IBOutlet var guessLabel: UILabel!
    
    var correctGuessedWords: Set<String> = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 141/255, green: 185/255, blue: 217/255, alpha: 1)
        guessLabel.text = "Guess a word"
        textField.autocorrectionType = .no
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? BoardController {
            controller.delegate = self
            controller.dictionaryTrie = dictionaryTrie
            boardVC = controller
        }
    }
    
}

extension ViewController: UITextFieldDelegate {

        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {
            return false
        }
        if boardVC.wordsOnBoard.contains(text) {
            if correctGuessedWords.contains(text) {
                guessLabel.text = "\(text) -- already guessed"
                guessLabel.textColor = .purple
            } else {
                correctGuessedWords.insert(text)
                guessLabel.text = "\(text) -- correct"
                guessLabel.textColor = .green
            }
            
            print(correctGuessedWords)
        } else {
            guessLabel.text = "\(text) -- incorrect"
            guessLabel.textColor = .purple
        }
        textField.text = ""
        return true
    }
    
    
}

