//
//  ViewController.swift
//  word-findy
//
//  Created by Renee Sajedian on 6/12/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController, BoardControllerDelegate {
    
    var boardVC: BoardController!
    var speechVC: SpeechViewController!
    var dictionaryTrie: Trie!
    @IBOutlet var textField: UITextField!
    @IBOutlet var guessLabel: UILabel!
    
    var correctGuessedWords: Set<String> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 141/255, green: 185/255, blue: 217/255, alpha: 1)
        guessLabel.text = "Guess a word"
        textField.autocorrectionType = .no
        
        //load speech controller vc
        speechVC = SpeechViewController()
        self.addChild(speechVC)
        view.addSubview(speechVC.view)
        NSLayoutConstraint.activate([
            speechVC.view.topAnchor.constraint(equalTo: guessLabel.bottomAnchor, constant: 10),
            speechVC.view.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -10),
            speechVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            speechVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
            ])
        speechVC.delegate = self
        speechVC.wordConstraints = Array(boardVC.wordsOnBoard.prefix(100))
        speechVC.didMove(toParent: self)
        
        
        
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


extension ViewController: SpeechViewControllerDelegate {
    func speechControllerDidFinish(with results: [SFTranscription]) {
        for result in results {
            let str = result.formattedString.lowercased()
            if boardVC.wordsOnBoard.contains(str) {
                correctGuessedWords.insert(str)
                guessLabel.text = "\(str) -- correct"
                guessLabel.textColor = .green
                return
            }
            
        }
        let str = results[0].formattedString.lowercased()
        guessLabel.text = "\(str) -- incorrect"
        guessLabel.textColor = .purple
    }
    
    
}

