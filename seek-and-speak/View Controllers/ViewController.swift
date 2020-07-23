//
//  ViewController.swift
//  word-findy
//
//  Created by Renee Sajedian on 6/12/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController {

    var boardVC: BoardController!
    var speechVC: SpeechViewController!
    var gameController: GameController!
    var dictionaryTrie: Trie!
    var correctGuessedWords: Set<String> = []

    @IBOutlet var textField: UITextField!
    @IBOutlet var guessLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var scoreAdditionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightPurple
        textField.autocorrectionType = .no

        scoreAdditionLabel.textColor = .aqua
        updateDisplay()

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
            controller.gameController = gameController
            boardVC = controller
        }
    }

    func updateDisplay() {
        scoreAdditionLabel.alpha = 1
        guessLabel.text = gameController.displayText
        guessLabel.textColor = gameController.game.displayColor
        scoreLabel.text = String(gameController.game.score)
        scoreAdditionLabel.text = gameController.game.scoreAdditionDisplay
        UIView.animate(withDuration: 2) { [weak self] in
            self?.scoreAdditionLabel.alpha = 0
        }
    }
}

extension ViewController: GameControllerDelegate {

    func timerDidCountDown(timeRemaining: String) {
        timeLabel.text = timeRemaining
    }
    func timerDidFinish() {
        let alertController = UIAlertController(title: "Game Over",
                                message: "Your score was \(gameController.game.score)", preferredStyle: .alert)
        let newGameAction = UIAlertAction(title: "Play Again", style: .default) { [weak self] _ in
            self?.gameController.newGame()
        }
        alertController.addAction(newGameAction)
        present(alertController, animated: true)
    }
    func newGameStarted() {
        scoreLabel.text = String(gameController.game.score)
        timeLabel.text = gameController.game.timeRemainingDisplay
        guessLabel.text = gameController.displayText
    }
}

extension ViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {
            return false
        }
        gameController.playerGuessed(text: text)
        textField.text = ""
        updateDisplay()
        return true
    }
}

extension ViewController: SpeechViewControllerDelegate {

    func speechControllerDidFinish(with results: [SFTranscription]) {
        guard !results.isEmpty else { return }
        let strings = results.map { $0.formattedString.lowercased() }
        gameController.playerGuessed(speech: strings)
        updateDisplay()
    }
}
