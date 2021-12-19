//
//  AngryBallScene.swift
//  AngryBall


import SpriteKit
import GameplayKit


class GameScene: SKScene {
    
    private var ball = SKSpriteNode()
    
    private var originalBallPosition = CGPoint()
    
    private var ballWasShot: Bool = false
    
    private var sceneBoxes = [SKSpriteNode]()
    
    private var boxesStartingPosition = [CGPoint]()
    
    override func didMove(to view: SKView) {
        guard let angryBall = self.childNode(withName: "ball") as? SKSpriteNode  else { return }
        ball = angryBall
        originalBallPosition = ball.position
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    
        for boxNumber in 1...8 {
            guard let box = self.childNode(withName: "box\(boxNumber)") as? SKSpriteNode else { continue }

            sceneBoxes.append(box)
            boxesStartingPosition.append(box.position)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !ballWasShot {
            guard let touch = touches.first else { return }

            let touchLocation = touch.location(in: self)

            let touchedNodes = nodes(at: touchLocation)
            

            if !touchedNodes.isEmpty {

                for node in touchedNodes {

                    guard let spriteNode = node as? SKSpriteNode else { return }

                    if spriteNode == ball {

                        ball.position = touchLocation
                    }
                }
            }
        }
    }
    

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        if !ballWasShot {

            guard let touch = touches.first else { return }

            let touchLocation = touch.location(in: self)

            let touchedNodes = nodes(at: touchLocation)
 
            if !touchedNodes.isEmpty {

                for node in touchedNodes {

                    guard let spriteNode = node as? SKSpriteNode else { return }

                    if spriteNode == ball {

                        if ball.position.x > 0.0 {

                            ball.position = originalBallPosition
                        } else {

                            ball.position = touchLocation
                        }
                    }
                }
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

            if !ballWasShot {
 
                guard let touch = touches.first else { return }
 
                let touchLocation = touch.location(in: self)

                let touchedNodes = nodes(at: touchLocation)
                

                if !touchedNodes.isEmpty {
     
                    for node in touchedNodes {

                        guard let spriteNode = node as? SKSpriteNode else { return }
     
                        if spriteNode == ball {
                            

                            let ballX = -(touchLocation.x - originalBallPosition.x)
                            let ballY = -(touchLocation.y - originalBallPosition.y)
                            
                     
                            let impulse = CGVector(dx: ballX, dy: ballY)
                            
          
                            ball.physicsBody?.applyImpulse(impulse)
                            ball.physicsBody?.applyAngularImpulse(-0.01)
                            ball.physicsBody?.affectedByGravity = true
                            

                            ballWasShot = true
                            
                        }
                    }
                }
            }
    }
    

    override func update(_ currentTime: TimeInterval) {

        if let angryBallPhysicsBoody = ball.physicsBody
        {

            if angryBallPhysicsBoody.velocity.dx <= 0.1 && angryBallPhysicsBoody.velocity.dy <= 0.1 && angryBallPhysicsBoody.angularVelocity <= 0.1 && ballWasShot {
                
           
                ball.physicsBody?.affectedByGravity = false
            
                ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                
           
                ball.physicsBody?.angularVelocity = .zero
                
  
                ball.zRotation = 0.0
                
           
                ball.position = originalBallPosition
                
        
                ballWasShot = false
                
                for boxIndex in 0...7 {
                    
                    let originalBoxPosition = boxesStartingPosition[boxIndex]
                    
                    let box = sceneBoxes[boxIndex]
              
                    box.position = originalBoxPosition
                  
                    box.zRotation = 0.0
                 
                    box.physicsBody?.velocity = CGVector.zero
              
                    box.physicsBody?.angularVelocity = 0.0
                    
                }
            }
        }
    }
}
