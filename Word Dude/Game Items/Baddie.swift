import SpriteKit

class Baddie : SKNode {
    
    let sprite: SKSpriteNode
    let emitter: SKEmitterNode
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    override init() {
        
        let atlas = SKTextureAtlas(named: "characters")
        let texture = atlas.textureNamed("baddie")
        texture.filteringMode = .Nearest
        
        sprite = SKSpriteNode(texture: texture)
        
        emitter = SKEmitterNode(fileNamed: "EnemyEngine")
        emitter.particleTexture!.filteringMode = .Nearest
        
        super.init()
    
        
        emitter.targetNode = parent
        addChild(emitter)
        emitter.zRotation = (0.5 * 3.142)
        addChild(sprite)
        name = "baddie"
        
        
        
        //let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:2)
        
        //sprite.runAction(SKAction.repeatActionForever(action))
        
        var minDiam = min(sprite.size.width, sprite.size.height)
        minDiam = max(minDiam-16.0, 4.0)
        let physicsBody = SKPhysicsBody(circleOfRadius: minDiam/2.0)
        // 2
        physicsBody.usesPreciseCollisionDetection = true
        // 3
        physicsBody.allowsRotation = false
        physicsBody.restitution = 1
        physicsBody.friction = 0
        physicsBody.linearDamping = 0
        // 4
        self.physicsBody = physicsBody
        physicsBody.categoryBitMask = PhysicsCategory.Baddie
        //physicsBody.contactTestBitMask = PhysicsCategory.All
        physicsBody.collisionBitMask = PhysicsCategory.Boundary
        
    }
    
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
        //println(sprite.zRotation)
        //Velocity = targetVector
    }
    
}