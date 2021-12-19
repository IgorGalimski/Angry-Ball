//
//  GameScene.swift
//  AngryBall
//
//  Created by IgorGalimski on 19/12/2021.
//

import Foundation
import SpriteKit
import GameplayKit

class GameScene : SKScene
{
    private var ball = SKSpriteNode()
    
    private var originalBallPosition = CGPoint()
    
    private var wasBallShoot: Bool = false
    
    private var sceneBoxes = [SKSpriteNode]()
    
    private var boxesStartingPosition = [CGPoint]()
    
    override func didMove(to view: SKView)
    {
        
        guard let angryBall = childNode(withName: "ball") as? SKSpriteNode else { return }
        ball = angryBall
        originalBallPosition = ball.position
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        for boxNumber in 1...8
        {
            guard let box = childNode(withName: "box\(boxNumber)") as? SKSpriteNode else { continue }
            
            sceneBoxes.append(box)
            boxesStartingPosition.append(box.position)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if !wasBallShoot
        {
            guard let touch = touches.first else { return }
            
            let touchLocation = touch.location(in: self)
            
            let touchNodes = nodes(at: touchLocation)
            
            if !touchNodes.isEmpty
            {
                for node in touchNodes
                {
                    guard let spriteNode = node as? SKSpriteNode else { return }
                    
                    if spriteNode == ball
                    {
                        ball.position = touchLocation
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if !wasBallShoot
        {
            guard let touch = touches.first else { return }
            
            let touchLocation = touch.location(in: self)
            
            let touchNodes = nodes(at: touchLocation)
            
            if !touchNodes.isEmpty
            {
                for node in touchNodes
                {
                    guard let spriteNode = node as? SKSpriteNode else { return }
                    
                    if spriteNode == ball
                    {
                        if ball.position.x > 0.0
                        {
                            ball.position = originalBallPosition
                        }
                        else
                        {
                            ball.position = touchLocation
                        }
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touch = touches.first else { return }
        
        let touchLocation = touch.location(in: self)
        
        let touchNodes = nodes(at: touchLocation)
        
        if !touchNodes.isEmpty
        {
            for node in touchNodes
            {
                guard let spriteNode = node as? SKSpriteNode else { return }
                
                if spriteNode == ball
                {
                    let ballX = -(touchLocation.x - originalBallPosition.x)
                    let ballY = -(touchLocation.y - originalBallPosition.y)
                    
                    let impulse = CGVector(dx: ballX, dy: ballY)
                    
                    ball.physicsBody?.applyImpulse(impulse)
                    ball.physicsBody?.applyAngularImpulse(-0.01)
                    ball.physicsBody?.affectedByGravity = true
                    
                    wasBallShoot = true
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        if let angryBallPhysicsBody = ball.physicsBody
        {
            if angryBallPhysicsBody.velocity.dx <= 0.1 &&
                angryBallPhysicsBody.velocity.dy <= 0.1 &&
                angryBallPhysicsBody.angularVelocity <= 0.1 &&
                wasBallShoot
            {
                ball.physicsBody?.affectedByGravity = false
                
                ball.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
                
                ball.physicsBody?.angularVelocity = .zero
                
                ball.zRotation = .zero
                
                ball.position = originalBallPosition
                
                wasBallShoot = false
                
                for boxIndex in 0...7
                {
                    let originalBoxPosition = boxesStartingPosition[boxIndex]
                    let box = sceneBoxes[boxIndex]
                    box.position = originalBoxPosition
                    box.zRotation = .zero
                    box.physicsBody?.velocity = CGVector.zero
                    box.physicsBody?.angularVelocity = .zero
                }
            }
        }
    }
}
