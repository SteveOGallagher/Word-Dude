import SpriteKit

class K: SKNode {
    
    let sprite: SKSpriteNode
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    override init() {
        
        let atlas = SKTextureAtlas(named: "letters")
        let texture = atlas.textureNamed("K")
        texture.filteringMode = .Nearest
        
        
        sprite = SKSpriteNode(texture: texture)
        super.init()
        
        
        
        addChild(sprite)
        name = "K"
        
        var radius = min(sprite.size.width, sprite.size.height) / 2
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody!.categoryBitMask = PhysicsCategory.K
        physicsBody!.collisionBitMask = PhysicsCategory.None
        
    }
    
    
}