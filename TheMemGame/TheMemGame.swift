//
//  TheMemGame.swift
//  TheMemGame
//
//  Created by Nattee Setobol on 2018/03/10.
//  Copyright © 2018年 Nattee Setobol. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class TheMemGame
{
    let totalRows : Int = 3
    let totalCols : Int = 2
    let cardStartPosX: Int = 10
    let cardStartPosY: Int = 10
    let cardPaddingX : CGFloat = 15
    let cardPaddingY : CGFloat = 1
    var  cardImages: Array<SKSpriteNode> = Array()
    var  board: Array<card> = Array()
    var totalCardsToMatch : Int = 0
    var timesFlipped = 0
    var userScore = 0
    let scoreLabel = SKLabelNode(text: "")
    let stats = SKLabelNode(text: "")
    
    func InitCards(view: SKView, scene: SKScene)
    {
        var cardStartPosX:CGFloat = view.frame.origin.x + 50.0
        var cardStartPosY:CGFloat = view.frame.origin.y+view.frame.height-130
        
        totalCardsToMatch = (totalRows * totalCols) / 2
        
        scoreLabel.position = CGPoint(x: view.frame.origin.x+350 , y:view.frame.origin.y+view.frame.height/2)
        scene.addChild(scoreLabel)
        stats.position = CGPoint(x: view.frame.origin.x+350, y:view.frame.origin.y+(view.frame.height/2)+100)
        scene.addChild(stats)
        
        for _ in 0..<totalCols
        {
            for _ in 0..<totalRows
            {
                let cardImage = SKSpriteNode(imageNamed: "cardback")
                cardImage.anchorPoint = CGPoint(x:0,y:0)
                cardImage.position = CGPoint(x: cardStartPosX,y:cardStartPosY)
                cardImage.yScale = 0.4
                cardImage.xScale = 0.4
                
                scene.addChild(cardImage)
                cardImages.append(cardImage)
                cardStartPosX += CGFloat(cardImage.frame.width + cardPaddingX)
                
                var cardInfo:card = card()
                
                cardInfo.min = cardImage.position
                cardInfo.max = CGPoint(x: CGFloat(cardImage.position.x+cardImage.frame.width), y: CGFloat(cardImage.position.y+cardImage.frame.height))
                
                board.append(cardInfo)
            }
            
            cardStartPosY += cardPaddingY-130
            cardStartPosX = view.frame.origin.x + 50.0
        }
        
        
    }
    
    func CardTouch(Location: CGPoint )
    {
        if timesFlipped != 2
        {
            for boardNode in board
            {
                if (DidTouchCardArea(Location: Location, CardMin: boardNode.min, CardMax:  boardNode.max))
                {
                    if (boardNode.matched)
                    {
                        return
                    }
                    if (boardNode.flipped == false)
                    {
                        FlipCardOver(boardNode: boardNode)
                        break;
                    }
                }
            }
            
        }
        if timesFlipped == 2 {
            CheckIfCardMatch()
        }
    }
    
    func FlipCardOver(boardNode:card)
    {
        if (boardNode.flipped == false)
        {
            switch(boardNode.id)
            {
                case 1:
                    cardImages[boardNode.index].texture = SKTexture(imageNamed: "panda")
                    break;
                case 2:
                    cardImages[boardNode.index].texture = SKTexture(imageNamed: "penguin")
                    break;
                case 3:
                    cardImages[boardNode.index].texture = SKTexture(imageNamed: "dog")
                    break;
                default:
                    break
            }
            timesFlipped += 1
            board[boardNode.index].flipped = true
        } else {
            board[boardNode.index].flipped = false;
            cardImages[boardNode.index].texture = SKTexture(imageNamed: "cardback")
        }
    }
    
    func DidTouchCardArea(Location: CGPoint, CardMin: CGPoint, CardMax: CGPoint ) -> Bool
    {
        return (Location.x > CardMin.x && Location.x < CardMax.x &&
            Location.y > CardMin.y && Location.y < CardMax.y )
    }
    
    func CheckIfCardMatch()
    {
        var storedIndex = -1
        for bnode in board
        {
            if (bnode.flipped == true)
            {
                if (storedIndex == -1)
                {
                    
                    storedIndex = bnode.index
                } else {
                    if (board[storedIndex].id == bnode.id)
                    {
                        cardImages[storedIndex].isHidden = true
                        cardImages[bnode.index].isHidden = true
                        board[bnode.index].matched = true
                        board[storedIndex].matched = true
                        board[storedIndex].flipped = false;
                        board[bnode.index].flipped = false;

                        if (CheckIfGameIsOver())
                        {
                            stats.text = ""
                            scoreLabel.text = "GAME OVER!!"
                            NSLog("Game Over!")
                        } else {
                            stats.text = "Match"
                            _ = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(Match), userInfo: bnode.id, repeats: false)
                        }
                        
                    } else {
                        stats.text = "No Match!"
                        _ = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(Unpause), userInfo: nil, repeats: false)
                    }
                    
                    break
                }
            }
        }
    }
    
    func CheckIfGameIsOver() -> Bool
    {
        var isGameOver = true
        
        for cardInBoard in board
        {
            if (cardInBoard.matched == false)
            {
                isGameOver = false
            }
        }
        
        return isGameOver
    }
    
    func GenerateRandomCards()
    {
        var isValid: Bool = false
        
        while(isValid == false)
        {
            let pickRandomCard: UInt32 = arc4random_uniform(UInt32(totalCardsToMatch)) + 1
            var validStat: Bool = true
            var cardItemCount = 0
            
            for cardItem in board
            {
                if (cardItem.id != -1)
                {
                    
                    if cardItem.id == pickRandomCard
                    {
                        validStat = false
                    }
                    
                    cardItemCount += 1
                }
            }
            
            if (cardItemCount == board.count)
            {
                isValid = true
                break;
            }
            if (validStat)
            {
                
                //Pick a spot for the random card Generated
                for _ in 0..<2
                {
                    var validRandomSpot = false
                    while (validRandomSpot == false)
                    {
                        let randomSpot = arc4random_uniform(UInt32(board.count))
                        
                        if (board[Int(randomSpot)].id == -1)
                        {
                            board[Int(randomSpot)].id = Int(pickRandomCard)
                            board[Int(randomSpot)].index = Int(randomSpot)
                            
                            validRandomSpot = true
                            break
                        }
                    }
                }
                
            }
        }
    }
    
    @objc func Match(timer: Timer)
    {
        timesFlipped = 0
        stats.text = ""
    }
    @objc func Unpause()
    {
        timesFlipped = 0
        for boardNode in board
        {
            if (boardNode.flipped)
            {
                FlipCardOver(boardNode: boardNode)
                stats.text = ""
            }
            
        }
    }
}
