import SpriteKit

class Moon : SKNode {
    let sprite: SKSpriteNode
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    override init() {
        let atlas = SKTextureAtlas(named: "scenery")
        let texture = atlas.textureNamed("moon")
        texture.filteringMode = .Nearest
        sprite = SKSpriteNode(texture: texture)
        
        super.init()
        
        addChild(sprite)
        name = "moon"
        
        var radius = min(sprite.size.width, sprite.size.height) / 2
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody!.categoryBitMask = PhysicsCategory.Moon
        physicsBody!.categoryBitMask = PhysicsCategory.Boundary
        physicsBody!.collisionBitMask = PhysicsCategory.Boundary
    }
}