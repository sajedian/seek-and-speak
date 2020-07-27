//
//  SceneDelegate.swift
//  word-findy
//
//  Created by Renee Sajedian on 6/12/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard scene as? UIWindowScene != nil else { return }
        if let viewController = window?.rootViewController as? ViewController {
            let dictionaryTrie = Trie()
            viewController.dictionaryTrie = dictionaryTrie
            viewController.gameController = GameController(dict: dictionaryTrie)
        }
    }
}
