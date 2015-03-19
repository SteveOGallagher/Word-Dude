// This file sets up the called for the Player Ship as a Player

import SpriteKit

class Player : SKNode {
    // Constants are declared
    let sprite: SKSpriteNode
    let emitter: SKEmitterNode
    let emitter2: SKEmitterNode
    let playerRotateRadiansPerSec:CGFloat = 4.0 * π
    var dt: NSTimeInterval = 0
    var Velocity = CGPointZero
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    override init() {
        // Create the Sprite for the Player Ship using the "MyShip2" image and "Engines" particle file
        let atlas = SKTextureAtlas(named: "characters")
        let texture = atlas.textureNamed("MyShip2")
        texture.filteringMode = .Nearest
        sprite = SKSpriteNode(texture: texture)
        sprite.setScale(0.2)
        emitter = SKEmitterNode(fileNamed: "Engines")
        emitter.particleTexture!.filteringMode = .Nearest
        // The emitter for Stars is also prepared
        emitter2 = SKEmitterNode(fileNamed: "Stars")
        emitter2.particleTexture!.filteringMode = .Nearest
        
        super.init()
        
        // The Player Ship sprite and emitter are added to the scene with the correct rotation
        addChild(sprite)
        name = "player"
        sprite.zRotation = (0.5 * 3.142)
        sprite.zPosition = 50
        emitter.targetNode = parent
        addChild(emitter)
        emitter.zPosition = 30
     
        // Set up the physics parameters for collision detection on the Player Ship
        var minDiam = min(sprite.size.width, sprite.size.height+10)
        let physicsBody = SKPhysicsBody(circleOfRadius: minDiam/2.0)
        physicsBody.usesPreciseCollisionDetection = true
        physicsBody.allowsRotation = false
        physicsBody.restitution = 1
        physicsBody.friction = 0
        physicsBody.linearDamping = 0
        self.physicsBody = physicsBody
        physicsBody.categoryBitMask = PhysicsCategory.Player
        physicsBody.contactTestBitMask = PhysicsCategory.All
        physicsBody.collisionBitMask = PhysicsCategory.Boundary
    }

    // The moveToward function instructions the Enemy Ship where to face and where to move toward.
    func moveToward(target: CGPoint) {
            var angle: CGFloat = 0
            let targetVector = (target - position).normalized() * 200.0
            physicsBody?.velocity = CGVector(point: targetVector)
        
            func rotateSprite(sprite: SKSpriteNode, direction: CGPoint) {
                sprite.zRotation = (0.5 * 3.142) + CGFloat(
                    atan2(Double(targetVector.y), Double(targetVector.x))) - (0.5 * 3.142)
                emitter.zRotation = sprite.zRotation - (0.5 * 3.142)
            }
            rotateSprite(sprite, targetVector)
            Velocity = targetVector
    }
}


