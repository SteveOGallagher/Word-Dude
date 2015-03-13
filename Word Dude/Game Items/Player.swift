import SpriteKit

class Player : SKNode {
    
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
        let atlas = SKTextureAtlas(named: "characters")
        let texture = atlas.textureNamed("MyShip2")
        texture.filteringMode = .Nearest
        sprite = SKSpriteNode(texture: texture)
        sprite.setScale(0.2)
        
        emitter = SKEmitterNode(fileNamed: "Engines")
        emitter.particleTexture!.filteringMode = .Nearest
        emitter2 = SKEmitterNode(fileNamed: "Stars")
        emitter2.particleTexture!.filteringMode = .Nearest
        
        super.init() //change
        
        addChild(sprite)
        name = "player"
        
        sprite.zRotation = (0.5 * 3.142)
        sprite.zPosition = 50
        
        emitter.targetNode = parent
        addChild(emitter)
        emitter.zPosition = 30
     
        // 1
        var minDiam = min(sprite.size.width, sprite.size.height+10)
        //minDiam = max(minDiam-16.0, 4.0)
        
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
        physicsBody.categoryBitMask = PhysicsCategory.Player
        physicsBody.contactTestBitMask = PhysicsCategory.All
        physicsBody.collisionBitMask = PhysicsCategory.Boundary
    
        
    }
    
    func starsEmitter() {
        emitter2.targetNode = parent
        addChild(emitter2)
        emitter2.zPosition = 100
        println("yep")
    }

    
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
            //println(sprite.zRotation)
            Velocity = targetVector
    }

    
    
}


