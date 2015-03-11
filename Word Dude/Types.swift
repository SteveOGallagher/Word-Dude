struct PhysicsCategory {
    

    
    static let None : UInt32 = 0
    static let All : UInt32 = UInt32.max
    static let Boundary : UInt32 = 0b1
    static let Player : UInt32 = 0b10
    static let Letter : UInt32 = 0b100
    static let O : UInt32 = 0b1000
    static let C : UInt32 = 0b10000
    static let K : UInt32 = 0b100000
    static let E : UInt32 = 0b1000000
    static let T : UInt32 = 0b10000000
    static let M : UInt32 = 0b100000000
    static let S : UInt32 = 0b1000000000
    static let P : UInt32 = 0b10000000000
    static let L : UInt32 = 0b100000000000
    static let A : UInt32 = 0b1000000000000
    static let N : UInt32 = 0b10000000000000
    static let H : UInt32 = 0b100000000000000
    static let Moon : UInt32 = 0b1000000000000000
    static let EnemyLaser : UInt32 = 0b10000000000000000
    static let Rocket : UInt32 = 0b100000000000000000
    static let Baddie: UInt32 = 0b1000000000000000000
    static let B: UInt32 = 0b10000000000000000000
    static let I: UInt32 = 0b100000000000000000000
    static let G: UInt32 = 0b1000000000000000000000
    static let U: UInt32 = 0b10000000000000000000000
    static let X: UInt32 = 0b100000000000000000000000
    static let Y: UInt32 = 0b1000000000000000000000000
    
    
}

enum GameState {
    case MainMenu
    case Playing
    case Paused
    case InLevelMenu
    case GameLoad
    case Instructions
}