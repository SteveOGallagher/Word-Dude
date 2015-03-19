import SpriteKit

class X: SKNode {
    let sprite: SKSpriteNode

    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    override init() {
        let atlas = SKTextureAtlas(named: "letters")
        let texture = atlas.textureNamed("X")
        texture.filteringMode = .Nearest
        sprite = SKSpriteNode(texture: texture)
        
        super.init()
        
        addChild(sprite)
        name = "X"
        
        var radius = min(sprite.size.width, sprite.size.height) / 2
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody!.categoryBitMask = PhysicsCategory.X
        physicsBody!.collisionBitMask = PhysicsCategory.None
    }
}