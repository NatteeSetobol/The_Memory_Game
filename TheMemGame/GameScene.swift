//
//  GameScene.swift
//  TheMemGame
//
//  Created by Nattee Setobol on 2018/03/10.
//  Copyright © 2018年 Nattee Setobol. All rights reserved.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene {
    
    var theMemGame : TheMemGame = TheMemGame()
    var cardInit = false
    override init(size: CGSize)
    {
        super.init(size: size)
        backgroundColor = UIColor(red: min( 0/100, 1.0),
                                  green: min(50/100, 1.0),
                                  blue: min( 0/100, 1.0),
                                  alpha: 1)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(code) has not been implemented.")
    }
    override func didMove(to view: SKView) {
        if (cardInit == false)
        {
            theMemGame.InitCards(view: view, scene: self)
            theMemGame.GenerateRandomCards()
            cardInit = true
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
      
        theMemGame.CardTouch(Location: pos)
    }
    
    func touchMoved(toPoint pos : CGPoint) {
     
    }
    
    func touchUp(atPoint pos : CGPoint) {
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        */
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }

}
