import SpriteKit

class C: SKNode {
    
    let sprite: SKSpriteNode
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    override init() {
        
        let atlas = SKTextureAtlas(named: "letters")
        let texture = atlas.textureNamed("C")
        texture.filteringMode = .Nearest
        
        
        sprite = SKSpriteNode(texture: texture)
        super.init()
        
        
        
        addChild(sprite)
        name = "C"
        
        var radius = min(sprite.size.width, sprite.size.height) / 2
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody!.categoryBitMask = PhysicsCategory.C
        physicsBody!.collisionBitMask = PhysicsCategory.None
        
    }
    
    func makeStars () {
        let emitter = SKEmitterNode(fileNamed: "Stars")
        emitter.particleTexture!.filteringMode = .Nearest
        emitter.targetNode = parent
        emitter.zPosition = 100
        emitter.runAction(SKAction.removeFromParentAfterDelay(1.0))
        addChild(emitter)
    }
    
}