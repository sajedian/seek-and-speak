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
    var gameController: GameController!
    var dictionaryTrie: Trie!
    @IBOutlet var textField: UITextField!
    @IBOutlet var guessLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    var correctGuessedWords: Set<String> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 141/255, green: 185/255, blue: 217/255, alpha: 1)
        guessLabel.text = "Guess a word"
        textField.autocorrectionType = .no
        guessLabel.text = gameController.displayText

        gameController.delegate = self
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
        speechVC.wordConstraints = Array(gameController.game.wordsOnBoard.prefix(100))
        speechVC.didMove(toParent: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? BoardController {
            controller.delegate = self
            controller.gameController = gameController
            boardVC = controller
        }
    }
    
}

extension ViewController: GameControllerDelegate {
    func timerDidCountDown(secondsRemaining: Int) {
        timeLabel.text = String(secondsRemaining)
    }
}

extension ViewController: UITextFieldDelegate {

        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {
            return false
        }
        gameController.playerGuessed(text: text)
        guessLabel.text = gameController.displayText
        scoreLabel.text = String(gameController.game.score)
        textField.text = ""
        return true
    }
    
    
}



extension ViewController: SpeechViewControllerDelegate {
    func speechControllerDidFinish(with results: [SFTranscription]) {
        guard !results.isEmpty else { return }
        let strings = results.map { $0.formattedString.lowercased() }
        gameController.playerGuessed(speech: strings)
        guessLabel.text = gameController.displayText
        scoreLabel.text = String(gameController.game.score)
    }
}
