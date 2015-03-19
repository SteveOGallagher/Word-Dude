import SpriteKit

class A: SKNode {
    let sprite: SKSpriteNode
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    override init() {
        let atlas = SKTextureAtlas(named: "letters")
        let texture = atlas.textureNamed("A")
        texture.filteringMode = .Nearest
        sprite = SKSpriteNode(texture: texture)
        
        super.init()
    
        addChild(sprite)
        name = "A"
        
        var radius = min(sprite.size.width, sprite.size.height) / 2
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody!.categoryBitMask = PhysicsCategory.A
        physicsBody!.collisionBitMask = PhysicsCategory.None
    }
}