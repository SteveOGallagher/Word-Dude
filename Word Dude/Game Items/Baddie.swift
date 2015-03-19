// This file sets up the called for the enemy ships as a Baddie

import SpriteKit

class Baddie : SKNode {
    // Constants are declared
    let sprite: SKSpriteNode
    let emitter: SKEmitterNode
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    override init() {
        // Create the Sprite for the Baddie using the "baddie" image and "EnemyEngine" particle file
        let atlas = SKTextureAtlas(named: "characters")
        let texture = atlas.textureNamed("baddie")
        texture.filteringMode = .Nearest
        sprite = SKSpriteNode(texture: texture)
        emitter = SKEmitterNode(fileNamed: "EnemyEngine")
        emitter.particleTexture!.filteringMode = .Nearest
        
        super.init()
    
        // add the engine particle emitter and the Enemy Ship
        emitter.targetNode = parent
        addChild(emitter)
        emitter.zRotation = (0.5 * 3.142)
        addChild(sprite)
        name = "baddie"
        
        // Set up the physics parameters for collision detection on the Enemy Ship
        var minDiam = min(sprite.size.width, sprite.size.height)
        minDiam = max(minDiam-16.0, 4.0)
        let physicsBody = SKPhysicsBody(circleOfRadius: minDiam/2.0)
        physicsBody.usesPreciseCollisionDetection = true
        physicsBody.allowsRotation = false
        physicsBody.restitution = 1
        physicsBody.friction = 0
        physicsBody.linearDamping = 0
        self.physicsBody = physicsBody
        physicsBody.categoryBitMask = PhysicsCategory.Baddie
        physicsBody.collisionBitMask = PhysicsCategory.Boundary
    }
    // The moveToward function instructions the Enemy Ship where to face and where to move toward.
    func moveToward(target: CGPoint, initial: CGPoint) {
        var angle: CGFloat = 0
        let targetVector = (target - initial).normalized() * 70
        physicsBody?.velocity = CGVector(point: targetVector)
    
        func rotateSprite(sprite: SKSpriteNode, direction: CGPoint) {
            sprite.zRotation = (0.5 * 3.142) + CGFloat(
                atan2(Double(targetVector.y), Double(targetVector.x))) - (0.5 * 3.142)
            emitter.zRotation = sprite.zRotation - (1.5 * 3.142)
        }
        rotateSprite(sprite, targetVector)
    }
}