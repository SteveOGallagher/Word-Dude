import SpriteKit

class Letter : SKNode {
    
    let sprite: SKSpriteNode
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    override init() {
        
            let atlas = SKTextureAtlas(named: "letters")
            let texture = atlas.textureNamed("R")
            texture.filteringMode = .Nearest
        
        
            sprite = SKSpriteNode(texture: texture)
            super.init()
        
            
            
            addChild(sprite)
            name = "letter"
        
            var radius = min(sprite.size.width, sprite.size.height) / 2
            physicsBody = SKPhysicsBody(circleOfRadius: radius)
            physicsBody!.categoryBitMask = PhysicsCategory.Letter
            physicsBody!.collisionBitMask = PhysicsCategory.None
        
    }
    

}