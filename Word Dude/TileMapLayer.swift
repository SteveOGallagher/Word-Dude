import SpriteKit

class TileMapLayer : SKNode {
    let tileSize: CGSize
    let gridSize: CGSize
    let layerSize: CGSize
    
    var atlas: SKTextureAtlas?
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    init(tileSize: CGSize, gridSize: CGSize, layerSize: CGSize? = nil) {
        self.tileSize = tileSize
        self.gridSize = gridSize
        if layerSize != nil {
            self.layerSize = layerSize!
        } else {
            self.layerSize = CGSize(width: tileSize.width * gridSize.width,
            height: tileSize.height * gridSize.height)
        }
        super.init()
    }
    
    func nodeForCode(tileCode: Character) -> SKNode? {
        // 1
        if atlas == nil {
            return nil
        }
        // 2
        var tile: SKNode?
        switch tileCode {
            case "*":
                tile = SKSpriteNode(texture: atlas!.textureNamed("spacebg"))
                tile?.zPosition = 10
            case "a":
                tile = A()
            case "b":
                tile = B()
            case "c":
                tile = C();
            case "e":
                tile = E()
            case "g":
                tile = G()
            case "h":
                tile = H()
            case "i":
                tile = I()
            case "k":
                tile = K()
            case "l":
                tile = L()
            case "m":
                tile = M()
            case "n":
                tile = N()
            case "o":
                tile = O()
            case "p":
                tile = P()
            case "s":
                tile = S()
            case "t":
                tile = T()
            case "u":
                tile = U()
            case "x":
                tile = X()
            case "y":
                tile = Y()
            case "r":
                tile = R()
            case "?":
                tile = Moon()
            case "-":
                tile = Baddie()
            case "+":
                tile = Player()
            case ".":
                return nil
            default:
                println("Unknown tile code \(tileCode)")
        }
        // 3
        if let sprite = tile as? SKSpriteNode {
            sprite.blendMode = .Replace
            
            sprite.texture?.filteringMode = .Nearest
        }
        return tile
    }
    
    convenience init(atlasName: String, tileSize: CGSize, tileCodes: [String]) {
        self.init(tileSize: tileSize, gridSize: CGSize(width: countElements(tileCodes[0]),
            height: tileCodes.count))
        atlas = SKTextureAtlas(named: atlasName)
        for row in 0..<tileCodes.count {
            let line = tileCodes[row]
            for (col, code) in enumerate(line) {
                if let tile = nodeForCode(code)? {
                    tile.position = positionForRow(row, col: col)
                    addChild(tile)
                }
            }
        }
    }
    
    func positionForRow(row: Int, col: Int) -> CGPoint {
        let x = CGFloat(col) * tileSize.width + tileSize.width / 2
        let y = CGFloat(row) * tileSize.height + tileSize.height / 2
        return CGPoint(x: x, y: layerSize.height - y)
    }
}