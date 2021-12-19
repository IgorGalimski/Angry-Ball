//
//  ViewController.swift
//  AngryBall
//
//  Created by Yasser Farahi on 14/12/2020.
//

import UIKit
import SpriteKit
import GameplayKit

class ViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let view = self.view as! SKView?
        {
            guard let spriteKitScene = GameScene(fileNamed: "GameScene") else { fatalError() }
            
            spriteKitScene.scaleMode = .aspectFill
            
            view.ignoresSiblingOrder = true
            view.showsFPS = false
            view.showsNodeCount = false
            
            view.presentScene(spriteKitScene)
        }
    }

    override var prefersStatusBarHidden: Bool
    {
        return true
    }

}

