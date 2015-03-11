import SpriteKit

class P: SKNode {
    
    let sprite: SKSpriteNode
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    override init() {
        
        let atlas = SKTextureAtlas(named: "letters")
        let texture = atlas.textureNamed("P")
        texture.filteringMode = .Nearest
        
        
        sprite = SKSpriteNode(texture: texture)
        super.init()
        
        
        
        addChild(sprite)
        name = "P"
        
        var radius = min(sprite.size.width, sprite.size.height) / 2
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody!.categoryBitMask = PhysicsCategory.P
        physicsBody!.collisionBitMask = PhysicsCategory.None
        
    }
    
    
}