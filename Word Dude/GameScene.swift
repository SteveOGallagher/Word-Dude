//
//  GameScene.swift
//  Word Dude
//
//  Created by Steve O'Gallagher on 09/02/2015.
//  Copyright (c) 2015 Steve O'Gallagher. All rights reserved.
//
//  This program was created after having learnt Swift via some brilliant tutorials by RayWenderlich.Com and Lynda.Com. 
//  All artwork was created by Steve O'Gallagher.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Set up all initial variables that require access from multiple functions
    
    /* AUDIO VARIABLES */
    var backgroundMusicPlayer: AVAudioPlayer!
    var BaddieLaser: AVAudioPlayer!
    var LaserAudio: AVAudioPlayer!
    var RocketAudio: AVAudioPlayer!
    var RocketSound: AVAudioPlayer!
    
    /* NODE VARIABLES */
    var hudLayerNode: SKNode!
    var scoreLabel: SKLabelNode!
    var timerLabel: SKLabelNode!
    var worldNode: SKNode!
    
    /* CLASS VARIABLES */
    var backgroundLayer: TileMapLayer!
    var baddie: Baddie!
    var itemLayer: TileMapLayer!
    var player: Player!
    let starEmitter = Player()
    
    /* IMAGE VARIABLES */
    let Continue: SKSpriteNode = SKSpriteNode(imageNamed: "Continue")
    let EnemyLaser: SKSpriteNode = SKSpriteNode(imageNamed: "EnemyLaser")
    let fire: SKSpriteNode = SKSpriteNode(imageNamed: "fire")
    let greenHealth = SKSpriteNode(imageNamed: "GreenHealth")
    let greenHealth2 = SKSpriteNode(imageNamed: "GreenHealth")
    let greenHealth3 = SKSpriteNode(imageNamed: "GreenHealth")
    let greenHealth4 = SKSpriteNode(imageNamed: "GreenHealth")
    let greenHealth5 = SKSpriteNode(imageNamed: "GreenHealth")
    let greenHealth6 = SKSpriteNode(imageNamed: "GreenHealth")
    let greenHealth7 = SKSpriteNode(imageNamed: "GreenHealth")
    let healthBarString: NSString = "=========="
    let HUD: SKSpriteNode = SKSpriteNode(imageNamed: "HUD2")
    let Instructions: SKSpriteNode = SKSpriteNode(imageNamed: "Instructions")
    let InstructionScreen: SKSpriteNode = SKSpriteNode(imageNamed: "InstructionsScreen")
    let letterBox1: SKSpriteNode = SKSpriteNode(imageNamed: "letterBlank")
    let letterBox2: SKSpriteNode = SKSpriteNode(imageNamed: "letterBlank")
    let letterBox3: SKSpriteNode = SKSpriteNode(imageNamed: "letterBlank")
    let letterBox4: SKSpriteNode = SKSpriteNode(imageNamed: "letterBlank")
    let letterBox5: SKSpriteNode = SKSpriteNode(imageNamed: "letterBlank")
    let letterBox6: SKSpriteNode = SKSpriteNode(imageNamed: "letterBlank")
    let MainBackground: SKSpriteNode = SKSpriteNode(imageNamed: "Launch")
    let MainMenu: SKSpriteNode = SKSpriteNode(imageNamed: "MainMenu")
    let pause: SKSpriteNode = SKSpriteNode(imageNamed: "pause")
    let PauseBG: SKSpriteNode = SKSpriteNode(imageNamed: "PauseMenuBG")
    let playGame: SKSpriteNode = SKSpriteNode(imageNamed: "PlayGame")
    let Rocket: SKSpriteNode = SKSpriteNode(imageNamed: "PlayerRocket")
    let ShipStatus: SKSpriteNode = SKSpriteNode(imageNamed: "ShipStatus")
    
    // NUMERICAL VARIABLES
    var xPosition: CGFloat = 0
    var rocketFound: CGFloat = 0
    var cosmosFound: CGFloat = 0
    var planetFound: CGFloat = 0
    var spaceFound: CGFloat = 0
    var starsFound: CGFloat = 0
    var earthFound: CGFloat = 0
    var moonFound: CGFloat = 0
    var orbitFound: CGFloat = 0
    var cometFound: CGFloat = 0
    var galaxyFound: CGFloat = 0
    var nebulaFound: CGFloat = 0
    var sunFound: CGFloat = 0
    var currentLevel = 0
    var numS = 0
    var numO = 0
    var numA = 0
    var timeInterval = 0
    let baddieLocation: CGPoint!
    var shipHealth: CGFloat = 7
    var dt: NSTimeInterval = 0
    var lastUpdateTime: NSTimeInterval = 0
    var velocity = CGPointZero
    var lastTouchLocation: CGPoint?
    var playerMovePointsPerSec: CGFloat = 300.0
    let playerRotateRadiansPerSec:CGFloat = 4.0 * π
    var GameStatus = 0
    var gameState = GameState.MainMenu
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    override init(size: CGSize) {
        
        super.init(size: size)
        
    }
    
    init(size: CGSize, level: Int, inGame: Int) {
        currentLevel = level // This ensures the correct level is loaded when the scene loads
        GameStatus = inGame // Updates the GameStatus to determine if MainMenu should load
        
        super.init(size: size)
    }
    
    override func didMoveToView(view: SKView) {
        
        // The following code locates the appropriate level data information in Word Dude
        let config = NSDictionary(contentsOfFile:
            NSBundle.mainBundle().pathForResource("Levels", ofType: "plist")!)!
        
        let levels = config["levels"] as [[String:AnyObject]]
        
        if currentLevel >= levels.count { // If the final level has been reached,
                currentLevel = 0          // the new level is set to the first level.
        }
        
        let levelData = levels[currentLevel] // The information for the level is loaded
        createWorld(levelData) // The createWorld function is executed with the appropriate level data
        worldNode.zPosition = 50
        
        createHUD() // The HeadsUpDiplay is created and added to the scene
        hudLayerNode.zPosition = 100
        
        self.physicsWorld.gravity = CGVector.zeroVector // Gravity is set to zero.
        
        createCharacters(levelData) // The appropriate level items are created and added to the scene
        centerViewOn(player.position) // The view centers itself on the Player's ship.
        
        // If the gameState is set to .MainMenu, the Main Menu screen is built and displayed
        if gameState == .MainMenu {
            createMainMenu()
            paused = false
        }
        // If the scene is not loading the game scene for the first time, the MainMenu is not created
        if GameStatus == 1 {
            gameState = .Playing
            paused = false
        }
    }
    
    func createMainMenu() {
        /* This function creates the Main Menu Screen if GameStatus is equal to 0. */
        
        if GameStatus == 0 {
            hudLayerNode.addChild(MainBackground)
            MainBackground.zPosition = 100
            MainBackground.position = CGPoint(x: 0, y: 0)
            MainBackground.size = size
            
            // The Play Game image is created and displayed in the hudLayerNode
            playGame.position = CGPoint(x: 0, y: -130)
            playGame.zPosition = 100
            playGame.size.height = 50
            playGame.size.width = 290
            playGame.name = "playGame"
            hudLayerNode.addChild(playGame)
            
            // The Instructions image is created and displayed in the hudLayerNode
            Instructions.position = CGPoint(x: 0, y: -190)
            Instructions.zPosition = 100
            Instructions.size.height = 42
            Instructions.size.width = 260
            Instructions.name = "playGame"
            hudLayerNode.addChild(Instructions)
        }
        
    }
    
    func checkWinner() {
        /* This function checks to see if the total number of required letters are found. */
        
        if rocketFound == 6 { // Each if statement relates to a particular word
            rocketFound = 0 // If the level is complete, rocketFound is set to 0 in advance of next use
            endLevelWithSuccess(true) // The End Level function is then called to display options
        }
        if cosmosFound == 6 {
            cosmosFound = 0
            endLevelWithSuccess(true)
        }
        if planetFound == 6 {
            planetFound = 0
            endLevelWithSuccess(true)
        }
        if spaceFound == 5 {
            spaceFound = 0
            endLevelWithSuccess(true)
        }
        if starsFound == 5 {
            starsFound = 0
            endLevelWithSuccess(true)
        }
        if earthFound == 5 {
            earthFound = 0
            endLevelWithSuccess(true)
        }
        if moonFound == 4 {
            moonFound = 0
            endLevelWithSuccess(true)
        }
        if orbitFound == 5 {
            orbitFound = 0
            endLevelWithSuccess(true)
        }
        if cometFound == 5 {
            cometFound = 0
            endLevelWithSuccess(true)
        }
        if galaxyFound == 6 {
            galaxyFound = 0
            endLevelWithSuccess(true)
        }
        if nebulaFound == 6 {
            nebulaFound = 0
            endLevelWithSuccess(true)
        }
        if sunFound == 3 {
            sunFound = 0
            endLevelWithSuccess(true)
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
                
        if gameState == .MainMenu && !paused { // Pauses the game when in the Main Menu
            paused = true
        }
        
        if gameState != .Playing {
            return
        }
        
        // Variables are created with information on the Player and Enemy ships' locations
        var ShipLoc = worldNode.childNodeWithName("player")?.position
        var EnemyPosition = worldNode.childNodeWithName("baddie")?.position
        var PlayerPosition = ShipLoc!
        var EnemyPositionx = worldNode.childNodeWithName("baddie")?.position.x
        var EnemyPositiony = worldNode.childNodeWithName("baddie")?.position.y
        var PlayerPositionx = PlayerPosition.x
        var PlayerPositiony = PlayerPosition.y
        
        // If there is still an Enemy Ship, the following will compute
        if (worldNode.childNodeWithName("baddie") != nil) {
            
            // If the Player Ship and the Enemy Ship are within a certain distance from each other:
            if (abs(PlayerPositiony - EnemyPositiony!) <= 200)
                && (abs(PlayerPositionx - EnemyPositionx!) <= 180) {
                
                // The Enemy ship will move towards the Player's ship
                baddie.moveToward(PlayerPosition, initial: EnemyPosition!)
                
                if timeInterval == 0 { // timeInterval is initially 0 when the level loads
                    
                    // The difference between the Enemy and Player ships is calculated into a vector
                    var VectorPoint: CGPoint = (PlayerPosition - EnemyPosition!)
                    let offset = CGPoint(x: PlayerPositionx - EnemyPositionx!,
                        y: PlayerPositiony - EnemyPositiony!)
                    var Offsetx: CGFloat = PlayerPositionx - EnemyPositionx!
                    var Offsety: CGFloat = PlayerPositiony - EnemyPositiony!
                    let length = sqrt(Double(Offsetx * Offsetx + Offsety * Offsety))
                    let direction = CGPoint(x: Offsetx / CGFloat(length), y: Offsety / CGFloat(length))
                    let laserVelocity = CGPoint(x: direction.x * 400, y: direction.y * 400)

                    // A Laser will then be create to fire from the Enemy in the direction of the Player's ship
                    fireLaser(EnemyPosition!, Velocity: laserVelocity, shipLocation: laserVelocity)
                    
                } else if timeInterval > 65 { // If enough time has passed, ready for a new Laser
                    timeInterval = 0
                    
                } else {
                    timeInterval += 1 // Continually increases over time
                }
                
            } else { // If the ships are not close enough, all actions are removed from the Enemy Ship
                baddie.removeAllActions()
            }
        }
    }
    
    
    func fireLaser(EnemyPosition: CGPoint, Velocity: CGPoint, shipLocation: CGPoint){
        /* This function fires a laser from the Enemy Ship towards the Player's Ship. */
        
        timeInterval += 1 // This ensures that timeInterval is not 0 when a Laser is fired
        
        // The laser's sound is played
        let BaddieLaserURL = NSBundle.mainBundle().URLForResource("BaddieLaser.mp3", withExtension: nil)
        BaddieLaser = AVAudioPlayer(contentsOfURL: BaddieLaserURL, error:nil)
        BaddieLaser.numberOfLoops = 0
        BaddieLaser.prepareToPlay()
        BaddieLaser.play()
        
        // The laser sprite node is added to the scene at the correct location
        let nextLocation: CGPoint = EnemyPosition + Velocity
        worldNode.addChild(EnemyLaser)
        EnemyLaser.position = EnemyPosition
        EnemyLaser.zPosition = 36
        
        // The laser is given Physical attributes for collision testing
        var radius = min(EnemyLaser.size.width, EnemyLaser.size.height) / 2
        EnemyLaser.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        EnemyLaser.physicsBody!.categoryBitMask = PhysicsCategory.EnemyLaser
        EnemyLaser.physicsBody!.collisionBitMask = PhysicsCategory.None
        
        // The laser is rotated so that it faces the direction of the Player's Ship
        rotateSprite(EnemyLaser, direction: shipLocation)
        
        // Actions are called on the laser to move it toward the Player and remove it from scene
        let fire: SKAction = SKAction.moveTo(nextLocation, duration: 0.75)
        let actionRemove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fire, actionRemove])
        EnemyLaser.runAction(sequence)
    }

    func rotateSprite(sprite: SKSpriteNode, direction: CGPoint) {
        /* This function rotates a given SpriteNode towards a given location (direction) */
        
        sprite.zRotation = CGFloat(atan2(Double(direction.y), Double(direction.x))) + (1.5 * 3.142)
    }
    
    func createCharacters(levelData: [String:AnyObject]) {
        /* This function creates and distributes the Letters, Player, and Enemy nodes. */
        
        let layerFiles: AnyObject? = levelData["layers"]
        if let dict = layerFiles as? [String:String] {
            itemLayer = tileMapLayerFromFileNamed(dict["letters"]!)
        }
        
        itemLayer.zPosition = 10
        worldNode.addChild(itemLayer) // The entire itemLayer is added to the worldNode node
        
        // The Enemy Ship is separated from the worldNode so that it may move independantly
        baddie = itemLayer.childNodeWithName("baddie") as Baddie
        baddie.removeFromParent()
        baddie.zPosition = 47
        worldNode.addChild(baddie)
        
        // The Player Ship is separated from the worldNode so that it may move independantly
        player = itemLayer.childNodeWithName("player") as Player
        player.removeFromParent()
        player.zPosition = 46
        //player.position = CGPoint(x: 300, y: 300)
        worldNode.addChild(player)
    }
    
    func createScenery(levelData: [String:AnyObject]) -> TileMapLayer? {
        /* This function creates the level's starry background image. */
        
        let layerFiles: AnyObject? = levelData["layers"]
        if let dict = layerFiles as? [String:String] {
            return tileMapLayerFromFileNamed(dict["background"]!)
        }
        return nil
    }
    
    func createWorld(levelData: [String:AnyObject]) {
        /* This function creates the world's node for all objects the be placed in and also sets the boundary within which the world operates. */
        
        backgroundLayer = createScenery(levelData)
        worldNode = SKNode()
        worldNode.addChild(backgroundLayer)
        addChild(worldNode)
        
        anchorPoint = CGPointMake(0.5, 0.5)
        worldNode.position =
            CGPointMake(-backgroundLayer.layerSize.width / 2,
            -backgroundLayer.layerSize.height / 2)
        
        // The boundary of playable area is set by the below code
        let bounds = SKNode()
        bounds.physicsBody =
        SKPhysicsBody(edgeLoopFromRect: CGRect(x: 0, y: 0,
                width: backgroundLayer.layerSize.width,
                height: backgroundLayer.layerSize.height - 75))
        bounds.physicsBody!.categoryBitMask = PhysicsCategory.Boundary
        bounds.physicsBody!.friction = 0
        worldNode.addChild(bounds)
        
        physicsWorld.contactDelegate = self
    }
    
    func endLevelWithSuccess(won: Bool) {
        /* This function displays a winning/losing condition on the screen when either all of the letters are found or the Player's Ship has been destroyed. */
        
        // An audio file is played depending on the win/lose boolean value
        let SuccessURL = NSBundle.mainBundle().URLForResource("Yeah.mp3", withExtension: nil)
        let FailURL = NSBundle.mainBundle().URLForResource("EnemyLaugh.mp3", withExtension: nil)
        
        BaddieLaser = won ? AVAudioPlayer(contentsOfURL: SuccessURL, error:nil) :
                            AVAudioPlayer(contentsOfURL: FailURL, error:nil)
        BaddieLaser.numberOfLoops = 0
        BaddieLaser.prepareToPlay()
        BaddieLaser.play()
        
        // A message is displayed to inform the Player if they won or lost
        let YouWon = SKSpriteNode(imageNamed: "YouDidIt")
        let YouLost = SKSpriteNode(imageNamed: "YouExploded")
        let Message1: SKSpriteNode = won ? YouWon : YouLost
        Message1.hidden = false
        Message1.name = "msgLabel"
        Message1.position = CGPoint(x: 0, y: 70)
        Message1.zPosition = 100
        addChild(Message1)
        
        // An option to replay the level or play next level is given depending on win/loss
        let nextLevel = SKSpriteNode(imageNamed: "NextWord")
        let restart = SKSpriteNode(imageNamed: "TryAgain")
        nextLevel.name = "nextLevelLabel"
        nextLevel.position = CGPoint(x: 0, y: -70)
        nextLevel.zPosition = 100
        restart.name = "restartLabel"
        restart.position = CGPoint(x: 0, y: -70)
        restart.zPosition = 100
        let messageToDisplay: SKSpriteNode = won ? nextLevel : restart
        addChild(messageToDisplay)
        
        player.physicsBody!.linearDamping = 1 // The Player Ship is slowed to a halt
                    
        gameState = .InLevelMenu // Change of gameState reflects the new end of level condition
    }
    
    /* LIST VARIABLES FOR LETTERS AS THEY ARE "FOUND" BY THE PLAYER */
    private var AsToRemove: [A] = []
    private var BsToRemove: [B] = []
    private var CsToRemove: [C] = []
    private var EsToRemove: [E] = []
    private var GsToRemove: [G] = []
    private var HsToRemove: [H] = []
    private var IsToRemove: [I] = []
    private var KsToRemove: [K] = []
    private var LsToRemove: [L] = []
    private var MsToRemove: [M] = []
    private var NsToRemove: [N] = []
    private var OsToRemove: [O] = []
    private var PsToRemove: [P] = []
    private var RsToRemove: [R] = []
    private var SsToRemove: [S] = []
    private var TsToRemove: [T] = []
    private var UsToRemove: [U] = []
    private var XsToRemove: [X] = []
    private var YsToRemove: [Y] = []
    
    
    func didBeginContact(contact:SKPhysicsContact) {
        /* This function determines the results of contact when detected between the Player's Ship and a variety of other physics objects in the scene. */
        
        let other = (contact.bodyA.categoryBitMask == PhysicsCategory.Player ?
        contact.bodyB : contact.bodyA)
        switch other.categoryBitMask {
            // If contact is with a Letter, add the node to the according list
            case PhysicsCategory.A: AsToRemove.append(other.node as A)
            case PhysicsCategory.B: BsToRemove.append(other.node as B)
            case PhysicsCategory.C: CsToRemove.append(other.node as C)
            case PhysicsCategory.E: EsToRemove.append(other.node as E)
            case PhysicsCategory.G: GsToRemove.append(other.node as G)
            case PhysicsCategory.H: HsToRemove.append(other.node as H)
            case PhysicsCategory.I: IsToRemove.append(other.node as I)
            case PhysicsCategory.K: KsToRemove.append(other.node as K)
            case PhysicsCategory.L: LsToRemove.append(other.node as L)
            case PhysicsCategory.M: MsToRemove.append(other.node as M)
            case PhysicsCategory.N: NsToRemove.append(other.node as N)
            case PhysicsCategory.O: OsToRemove.append(other.node as O)
            case PhysicsCategory.P: PsToRemove.append(other.node as P)
            case PhysicsCategory.R: RsToRemove.append(other.node as R)
            case PhysicsCategory.S: SsToRemove.append(other.node as S)
            case PhysicsCategory.T: TsToRemove.append(other.node as T)
            case PhysicsCategory.U: UsToRemove.append(other.node as U)
            case PhysicsCategory.X: XsToRemove.append(other.node as X)
            case PhysicsCategory.Y: YsToRemove.append(other.node as Y)
            // If contact is with the Boundary, rotate the ship to the new orientation
            case PhysicsCategory.Boundary: rotateShip(player.sprite)
            // If contact is with a Moon, make the ship spin out of control
            case PhysicsCategory.Moon: spin(player.sprite)
            // If contact is with the Laser, called the laserHit function
            case PhysicsCategory.EnemyLaser: laserHit()
        default: break;
        }
    }
    
    func rocketHit() {
        /* This function plays an explosion sound when called. */
        
        let rocketHitURL = NSBundle.mainBundle().URLForResource("EnemyExplodes.mp3", withExtension: nil)
        RocketAudio = AVAudioPlayer(contentsOfURL: rocketHitURL, error:nil)
        RocketAudio.numberOfLoops = 0
        RocketAudio.prepareToPlay()
        RocketAudio.play()
    }
    
    func laserHit() {
        /* This function plays a explosion sound when a laser contacts with the Play Ship and removes some of the Player's health. It also calls the checkShip function to remove a portion of the Player Ship's health. */
        
        let laserHitURL = NSBundle.mainBundle().URLForResource("LaserHit.mp3", withExtension: nil)
        LaserAudio = AVAudioPlayer(contentsOfURL: laserHitURL, error:nil)
        LaserAudio.numberOfLoops = 0
        LaserAudio.prepareToPlay()
        LaserAudio.play()
        
        shipHealth -= 1
        checkShip() // Updates the Ship's health display
    }
    
    func spin(sprite: SKSpriteNode) {
        /* This function spins the Player's Ship (called when it collides with a Moon) and plays a Hit sound. */
        
        let spinAction = SKAction.rotateByAngle(CGFloat(8 * M_PI), duration:2)
        let sequence = SKAction.sequence([spinAction, SKAction.waitForDuration(2)])
        
        sprite.runAction(sequence)
        sprite.zRotation = (0.5 * 3.142) + CGFloat(
            atan2(Double(-1 * player.Velocity.y), Double(-1 * player.Velocity.x))) - (0.5 * 3.142)
        
        if sprite == player.sprite {
            player.emitter.zRotation = player.sprite.zRotation - (0.5 * 3.142)
        }
        
        let laserHitURL = NSBundle.mainBundle().URLForResource("LaserHit.mp3", withExtension: nil)
        LaserAudio = AVAudioPlayer(contentsOfURL: laserHitURL, error:nil)
        LaserAudio.numberOfLoops = 0
        LaserAudio.prepareToPlay()
        LaserAudio.play()
    }
    
    func checkShip () {
        /* This function removes a green dot from the Player's Health bar on the hudLayerNode */
        if shipHealth == 6 {
            greenHealth7.removeFromParent()
        } else if shipHealth == 5 {
            greenHealth6.removeFromParent()
        } else if shipHealth == 4 {
            greenHealth5.removeFromParent()
        } else if shipHealth == 3 {
            greenHealth4.removeFromParent()
        } else if shipHealth == 2 {
            greenHealth3.removeFromParent()
        } else if shipHealth == 1 {
            greenHealth2.removeFromParent()
        } else if shipHealth == 0 {
            /* If the Player's Ship has run out of health, it calls the function to show the Ship blowing up and ends the level with a failure. */
            greenHealth.removeFromParent()
            explodePlayer()
            endLevelWithSuccess(false)
        }
    }
    
    func rotateShip(sprite: SKSpriteNode) {
        /* This function dictates how the Player's ship should rotate according to its position in the scene. */
        
        var ShipLoc = worldNode.childNodeWithName("player")?.position
        var PlayerPosition = ShipLoc!
        var PlayerPositionx = PlayerPosition.x
        var PlayerPositiony = PlayerPosition.y
        
        // If the Player Ship is not on the edges of the level, then it needs to Spin out of control
        if PlayerPositionx < 2300
            && PlayerPositionx > 35
            && PlayerPositiony > 35
            && PlayerPositiony < 1450 {
                spin(player.sprite)
                shipHealth -= 1 // Health is also removed in this instance.
                checkShip()
                
        } else // Otherwise, it will rotate to it's new direction as it bounces off the boundary.
        
        if PlayerPositionx < 55 { // If the Ship is on the left-hand edge of the level:
            
            player.sprite.zRotation = (0.5 * 3.142) + CGFloat(
                atan2(Double(player.Velocity.y), Double((-1 * player.Velocity.x)))) - (0.5 * 3.142)
            player.emitter.zRotation = player.sprite.zRotation - (0.5 * 3.142)
            
            let alteration = player.Velocity.x
            player.Velocity.x = (-1 * alteration) // The directional Velocity is reversed
        } else
        
        if PlayerPositionx > 2300 { // If the Ship is on the right-hand edge of the level:
            player.sprite.zRotation = (0.5 * 3.142) + CGFloat(
                atan2(Double(player.Velocity.y), Double((-1 * player.Velocity.x)))) - (0.5 * 3.142)
            player.emitter.zRotation = player.sprite.zRotation - (0.5 * 3.142)
            
            let alteration = player.Velocity.x
            player.Velocity.x = (-1 * alteration) // The directional Velocity is reversed
        }
        
        
        if PlayerPositiony < 35 { // If the Ship is on the bottom edge of the level:
            player.sprite.zRotation = (0.5 * 3.142) + CGFloat(
                atan2(Double((-1 * player.Velocity.y)), Double(player.Velocity.x))) - (0.5 * 3.142)
            player.emitter.zRotation = player.sprite.zRotation - (0.5 * 3.142)
            
            let alteration = player.Velocity.y
            player.Velocity.y = (-1 * alteration) // The directional Velocity is reversed
        }
        
        if PlayerPositiony > 1450 { // If the Ship is on the top edge of the level:
            player.sprite.zRotation = (0.5 * 3.142) + CGFloat(
                atan2(Double((-1 * player.Velocity.y)), Double(player.Velocity.x))) - (0.5 * 3.142)
            player.emitter.zRotation = player.sprite.zRotation - (0.5 * 3.142)
            
            let alteration = player.Velocity.y
            player.Velocity.y = (-1 * alteration) // The directional Velocity is reversed
        }
    }
    
    func createHUD() {
        /* This function creates and displays the elements of the game view that are fixed in locations and do not move when the Player Ship moves. */
        
        // First the hudLayerNode is added to which all other HUD elements will be added
        hudLayerNode = SKNode()
        let hudHeight: CGFloat = 70
        let backgroundSize = CGSize(width: size.width, height:hudHeight)
        let backgroundColor = SKColor.blueColor()
        let hudBarBackground = SKSpriteNode(color: backgroundColor, size: backgroundSize)
        hudBarBackground.position =
                    CGPoint(x:0, y: size.height - hudHeight)
        hudBarBackground.anchorPoint = CGPointZero
        addChild(hudLayerNode)
        hudLayerNode.zPosition = 100
        hudLayerNode.addChild(hudBarBackground)
        
        /*
        scoreLabel = SKLabelNode(fontNamed: "Edit Undo Line BRK")
        scoreLabel.fontSize = 50
        scoreLabel.text = "Score: 0"
        scoreLabel.name = "scoreLabel"
      
        scoreLabel.verticalAlignmentMode = .Center
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            // different placement on iPad
            scoreLabel.position = CGPoint(x: 200, y: size.height / 2 - 60)
        } else {
            scoreLabel.position = CGPoint(x: 0, y: size.height / 2 - 35) }
        scoreLabel.zPosition = 99*/
        
        // The rectange where the LetterBoxes will be displayed is placed at the top of the screen
        HUD.position = CGPoint(x: 0, y: size.height / 2 - 35)
        HUD.size = CGSizeMake(size.width, 70)
        hudLayerNode.addChild(HUD)
        
        addLetterBoxes() // This called the function that creates and places the LetterBoxes
        
        // The ShipStatus rectangle is created and placed at the bottom of the screen
        hudLayerNode.addChild(ShipStatus)
        ShipStatus.size = CGSizeMake(size.width, 70)
        let ShipStatusx = ShipStatus.position.x
        let ShipStatusy = (-1 * size.height/2) + ShipStatus.size.height/2
        ShipStatus.position = CGPoint(x: ShipStatusx, y: ShipStatusy)
        ShipStatus.zPosition = 91
        
        // The button for Fire is placed on the left-hand side of the Ship Status rectangle
        hudLayerNode.addChild(fire)
        fire.size = CGSizeMake(fire.size.width * 0.7, fire.size.height * 0.7)
        let firex = (-1 * size.width/2) + fire.size.width/2 + 8
        let firey = ShipStatusy
        fire.position = CGPoint(x: firex, y: firey)
        fire.zPosition = 92
        
        // The button for Pause is placed on the right-hand side of the Ship Status rectangle.
        hudLayerNode.addChild(pause)
        pause.size = CGSizeMake(pause.size.width * 0.6, pause.size.height * 0.6)
        let pausex = (size.width/2) - pause.size.width/2 - 8
        let pausey = ShipStatusy
        pause.position = CGPoint(x: pausex, y: pausey)
        pause.zPosition = 92
        
        // The green dots to display the Player Ship's health bar are add to the Ship Status location.
        // Dot 1
        greenHealth.size.width = 30
        greenHealth.size.height = 30
        greenHealth.position = CGPoint(x: -90, y: (-1 * size.height/2) + greenHealth.size.height/2 + 10)
        greenHealth.zPosition = 95
        hudLayerNode.addChild(greenHealth)
        
        // Dot 2
        greenHealth2.size.width = 30
        greenHealth2.size.height = 30
        greenHealth2.position = CGPoint(x: -60, y: (-1 * size.height/2) + greenHealth.size.height/2 + 10)
        greenHealth2.zPosition = 95
        hudLayerNode.addChild(greenHealth2)
        
        // Dot 3
        greenHealth3.size.width = 30
        greenHealth3.size.height = 30
        greenHealth3.position = CGPoint(x: -30, y: (-1 * size.height/2) + greenHealth.size.height/2 + 10)
        greenHealth3.zPosition = 95
        hudLayerNode.addChild(greenHealth3)
        
        // Dot 4
        greenHealth4.size.width = 30
        greenHealth4.size.height = 30
        greenHealth4.position = CGPoint(x: 0, y: (-1 * size.height/2) + greenHealth.size.height/2 + 10)
        greenHealth4.zPosition = 95
        hudLayerNode.addChild(greenHealth4)
        
        // Dot 5
        greenHealth5.size.width = 30
        greenHealth5.size.height = 30
        greenHealth5.position = CGPoint(x: 30, y: (-1 * size.height/2) + greenHealth.size.height/2 + 10)
        greenHealth5.zPosition = 95
        hudLayerNode.addChild(greenHealth5)
        
        // Dot 6
        greenHealth6.size.width = 30
        greenHealth6.size.height = 30
        greenHealth6.position = CGPoint(x: 60, y: (-1 * size.height/2) + greenHealth.size.height/2 + 10)
        greenHealth6.zPosition = 95
        hudLayerNode.addChild(greenHealth6)
        
        // Dot 7
        greenHealth7.size.width = 30
        greenHealth7.size.height = 30
        greenHealth7.position = CGPoint(x: 90, y: (-1 * size.height/2) + greenHealth.size.height/2 + 10)
        greenHealth7.zPosition = 95
        hudLayerNode.addChild(greenHealth7)
    }

    func addLetterBoxes() {
        /* This function adds the Letter Boxes to the hudLayerNode. How many boxes are added and to which locations in the screen are determined by the level number as different levels have different lengths of words. */
    
        if currentLevel <= 2 {
            letterBox1.position = CGPoint(x: xPosition - 125, y: size.height / 2 - 35)
            hudLayerNode.addChild(letterBox1)
            letterBox2.position = CGPoint(x: xPosition - 75, y: size.height / 2 - 35)
            hudLayerNode.addChild(letterBox2)
            letterBox3.position = CGPoint(x: xPosition - 25, y: size.height / 2 - 35)
            hudLayerNode.addChild(letterBox3)
            letterBox4.position = CGPoint(x: xPosition + 25, y: size.height / 2 - 35)
            hudLayerNode.addChild(letterBox4)
            letterBox5.position = CGPoint(x: xPosition + 75, y: size.height / 2 - 35)
            hudLayerNode.addChild(letterBox5)
            letterBox6.position = CGPoint(x: xPosition + 125, y: size.height / 2 - 35)
            hudLayerNode.addChild(letterBox6)
        }
        
        if currentLevel > 8 && currentLevel < 11 {
            letterBox1.position = CGPoint(x: xPosition - 125, y: size.height / 2 - 35)
            hudLayerNode.addChild(letterBox1)
            letterBox2.position = CGPoint(x: xPosition - 75, y: size.height / 2 - 35)
            hudLayerNode.addChild(letterBox2)
            letterBox3.position = CGPoint(x: xPosition - 25, y: size.height / 2 - 35)
            hudLayerNode.addChild(letterBox3)
            letterBox4.position = CGPoint(x: xPosition + 25, y: size.height / 2 - 35)
            hudLayerNode.addChild(letterBox4)
            letterBox5.position = CGPoint(x: xPosition + 75, y: size.height / 2 - 35)
            hudLayerNode.addChild(letterBox5)
            letterBox6.position = CGPoint(x: xPosition + 125, y: size.height / 2 - 35)
            hudLayerNode.addChild(letterBox6)
        }
        
        if currentLevel >= 3 && currentLevel < 6 {
            letterBox1.position = CGPoint(x: xPosition - 100, y: size.height / 2 - 35)
            hudLayerNode.addChild(letterBox1)
            letterBox2.position = CGPoint(x: xPosition - 50, y: size.height / 2 - 35)
            hudLayerNode.addChild(letterBox2)
            letterBox3.position = CGPoint(x: xPosition, y: size.height / 2 - 35)
            hudLayerNode.addChild(letterBox3)
            letterBox4.position = CGPoint(x: xPosition + 50, y: size.height / 2 - 35)
            hudLayerNode.addChild(letterBox4)
            letterBox5.position = CGPoint(x: xPosition + 100, y: size.height / 2 - 35)
            hudLayerNode.addChild(letterBox5)
        }
        
        if currentLevel > 6 && currentLevel < 9 {
            letterBox1.position = CGPoint(x: xPosition - 100, y: size.height / 2 - 35)
            hudLayerNode.addChild(letterBox1)
            letterBox2.position = CGPoint(x: xPosition - 50, y: size.height / 2 - 35)
            hudLayerNode.addChild(letterBox2)
            letterBox3.position = CGPoint(x: xPosition, y: size.height / 2 - 35)
            hudLayerNode.addChild(letterBox3)
            letterBox4.position = CGPoint(x: xPosition + 50, y: size.height / 2 - 35)
            hudLayerNode.addChild(letterBox4)
            letterBox5.position = CGPoint(x: xPosition + 100, y: size.height / 2 - 35)
            hudLayerNode.addChild(letterBox5)
        }
        
        if currentLevel == 6 {
            letterBox1.position = CGPoint(x: xPosition - 75, y: size.height / 2 - 35)
            hudLayerNode.addChild(letterBox1)
            letterBox2.position = CGPoint(x: xPosition - 25, y: size.height / 2 - 35)
            hudLayerNode.addChild(letterBox2)
            letterBox3.position = CGPoint(x: xPosition + 25, y: size.height / 2 - 35)
            hudLayerNode.addChild(letterBox3)
            letterBox4.position = CGPoint(x: xPosition + 75, y: size.height / 2 - 35)
            hudLayerNode.addChild(letterBox4)
        }
        
        if currentLevel == 11 {
            letterBox1.position = CGPoint(x: xPosition - 50, y: size.height / 2 - 35)
            hudLayerNode.addChild(letterBox1)
            letterBox2.position = CGPoint(x: xPosition, y: size.height / 2 - 35)
            hudLayerNode.addChild(letterBox2)
            letterBox3.position = CGPoint(x: xPosition + 50, y: size.height / 2 - 35)
            hudLayerNode.addChild(letterBox3)
        }
        
        /* A message appears on the screen when the scene loads instructing the user to "Tap the Screen To Explore!" This message is created with the below code which causes it to slowly fade until it is transparent. */
        let InstructionMessage = SKSpriteNode(imageNamed: "Instruction")
        hudLayerNode.addChild(InstructionMessage)
        InstructionMessage.zPosition = 100
        InstructionMessage.position = CGPoint(x: 0, y: 120)
        
        let fade = SKAction.fadeAlphaTo(0, duration: 2.0)
        let removeInstruction = SKAction.removeFromParent()
        let runSequence = SKAction.sequence([fade, removeInstruction])
        InstructionMessage.runAction(runSequence)
    }
    
    func centerViewOn(centerOn: CGPoint) {
            
            worldNode.position = getCenterPointWithTarget(centerOn)
    }
    
    func addAToHUD () {
        /* This function adds the 'A' Sprite Node to the correct LetterBox when "Found." This same method applies to all other add"letter"ToHUD functions. */
        
        // The correct image for the letter is assigned to "sprite"
        let atlasA = SKTextureAtlas(named: "letters")
        let textureA = atlasA.textureNamed("A")
        textureA.filteringMode = .Nearest
        let sprite = SKSpriteNode(texture: textureA)
        
        // The location of the sprite depends on the level number
        if currentLevel == 2 {
            // In this case, level 2 has just 1 'A', so it must have the below location:
            sprite.position = CGPoint(x: xPosition - 25, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            planetFound += 1 // The number of letters found in this letter increases by 1
        } else if currentLevel == 3 {
            sprite.position = CGPoint(x: xPosition, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            spaceFound += 1
        } else if currentLevel == 4 {
            sprite.position = CGPoint(x: xPosition, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            starsFound += 1
        } else if currentLevel == 5 {
            sprite.position = CGPoint(x: xPosition - 50, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            earthFound += 1
        } else if currentLevel == 9 {
            // If a level has multiple 'A's, then 2 locations are used for each 'A'.
            if numA == 0 {
                sprite.position = CGPoint(x: xPosition - 75, y: size.height / 2 - 35)
                makeStars(sprite)
                hudLayerNode.addChild(sprite)
                numA += 1
                galaxyFound += 1
            } else {
                sprite.position = CGPoint(x: xPosition + 25, y: size.height / 2 - 35)
                makeStars(sprite)
                hudLayerNode.addChild(sprite)
                numA = 0
                galaxyFound += 1
            }
        } else if currentLevel == 10 {
            sprite.position = CGPoint(x: xPosition + 125, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            nebulaFound += 1
        }
    }
    
    func addBToHUD () {
        /* This function adds the 'B' Sprite Node to the correct LetterBox when "Found." See the annotation in the addAToHUD function above. */
        
        let atlasB = SKTextureAtlas(named: "letters")
        let textureB = atlasB.textureNamed("B")
        textureB.filteringMode = .Nearest
        let sprite = SKSpriteNode(texture: textureB)
        
        if currentLevel == 7 {
            sprite.position = CGPoint(x: xPosition, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            orbitFound += 1
        } else if currentLevel == 10 {
            sprite.position = CGPoint(x: xPosition - 25, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            nebulaFound += 1
        }
    }
    
    func addCToHUD () {
        /* This function adds the 'C' Sprite Node to the correct LetterBox when "Found." See the annotation in the addAToHUD function above. */
        
        let atlasC = SKTextureAtlas(named: "letters")
        let textureC = atlasC.textureNamed("C")
        textureC.filteringMode = .Nearest
        let sprite = SKSpriteNode(texture: textureC)
        
        if currentLevel == 0 {
            sprite.position = CGPoint(x: xPosition - 25, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            rocketFound += 1
        } else if currentLevel == 1 {
            sprite.position = CGPoint(x: xPosition - 125, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            cosmosFound += 1
        } else if currentLevel == 3 {
            sprite.position = CGPoint(x: xPosition + 50, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            spaceFound += 1
        } else if currentLevel == 8 {
            sprite.position = CGPoint(x: xPosition - 100, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            cometFound += 1
        }
    }
    
    func addEToHUD () {
        /* This function adds the 'E' Sprite Node to the correct LetterBox when "Found." See the annotation in the addAToHUD function above. */
                
        let atlasE = SKTextureAtlas(named: "letters")
        let textureE = atlasE.textureNamed("E")
        textureE.filteringMode = .Nearest
        let sprite = SKSpriteNode(texture: textureE)
        
        if currentLevel == 0 {
            sprite.position = CGPoint(x: xPosition + 75, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            rocketFound += 1
        } else if currentLevel == 2 {
            sprite.position = CGPoint(x: xPosition + 75, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            planetFound += 1
        } else if currentLevel == 3 {
            sprite.position = CGPoint(x: xPosition + 100, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            spaceFound += 1
        } else if currentLevel == 5 {
            sprite.position = CGPoint(x: xPosition - 100, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            earthFound += 1
        } else if currentLevel == 8 {
            sprite.position = CGPoint(x: xPosition + 50, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            cometFound += 1
        } else if currentLevel == 10 {
            sprite.position = CGPoint(x: xPosition - 75, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            nebulaFound += 1
        }
    }
    
    func addGToHUD () {
        /* This function adds the 'G' Sprite Node to the correct LetterBox when "Found." See the annotation in the addAToHUD function above. */
        
        let atlasG = SKTextureAtlas(named: "letters")
        let textureG = atlasG.textureNamed("G")
        textureG.filteringMode = .Nearest
        let sprite = SKSpriteNode(texture: textureG)
        
        sprite.position = CGPoint(x: xPosition - 125, y: size.height / 2 - 35)
        makeStars(sprite)
        hudLayerNode.addChild(sprite)
        galaxyFound += 1
    }

    func addHToHUD () {
        /* This function adds the 'H' Sprite Node to the correct LetterBox when "Found." See the annotation in the addAToHUD function above. */
        
        let atlasH = SKTextureAtlas(named: "letters")
        let textureH = atlasH.textureNamed("H")
        textureH.filteringMode = .Nearest
        let sprite = SKSpriteNode(texture: textureH)
        
        sprite.position = CGPoint(x: xPosition + 100, y: size.height / 2 - 35)
        makeStars(sprite)
        hudLayerNode.addChild(sprite)
        earthFound += 1
    }
    
    func addIToHUD () {
        /* This function adds the 'I' Sprite Node to the correct LetterBox when "Found." See the annotation in the addAToHUD function above. */
        
        let atlasI = SKTextureAtlas(named: "letters")
        let textureI = atlasI.textureNamed("I")
        textureI.filteringMode = .Nearest
        let sprite = SKSpriteNode(texture: textureI)
        
        sprite.position = CGPoint(x: xPosition + 50, y: size.height / 2 - 35)
        makeStars(sprite)
        hudLayerNode.addChild(sprite)
        orbitFound += 1
    }
    
    func addKToHUD () {
        /* This function adds the 'K' Sprite Node to the correct LetterBox when "Found." See the annotation in the addAToHUD function above. */
                
        let atlasK = SKTextureAtlas(named: "letters")
        let textureK = atlasK.textureNamed("K")
        textureK.filteringMode = .Nearest
        let sprite = SKSpriteNode(texture: textureK)
        
        sprite.position = CGPoint(x: xPosition + 25, y: size.height / 2 - 35)
        makeStars(sprite)
        hudLayerNode.addChild(sprite)
        rocketFound += 1
    }
    
    func addLToHUD () {
        /* This function adds the 'L' Sprite Node to the correct LetterBox when "Found." See the annotation in the addAToHUD function above. */
                
        let atlasL = SKTextureAtlas(named: "letters")
        let textureL = atlasL.textureNamed("L")
        textureL.filteringMode = .Nearest
        let sprite = SKSpriteNode(texture: textureL)
        
        if currentLevel == 2 {
            sprite.position = CGPoint(x: xPosition - 75, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            planetFound += 1
        } else if currentLevel == 9 {
            sprite.position = CGPoint(x: xPosition - 25, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            galaxyFound += 1
        } else if currentLevel == 10 {
            sprite.position = CGPoint(x: xPosition + 75, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            nebulaFound += 1
        }
    }
    
    func addMToHUD () {
        /* This function adds the 'M' Sprite Node to the correct LetterBox when "Found." See the annotation in the addAToHUD function above. */
                
        let atlasM = SKTextureAtlas(named: "letters")
        let textureM = atlasM.textureNamed("M")
        textureM.filteringMode = .Nearest
        let sprite = SKSpriteNode(texture: textureM)
        
        if currentLevel == 1 {
            sprite.position = CGPoint(x: xPosition + 25, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            cosmosFound += 1
        } else if currentLevel == 6 {
            sprite.position = CGPoint(x: xPosition - 75, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            moonFound += 1
        } else if currentLevel == 8 {
            sprite.position = CGPoint(x: xPosition, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            cometFound += 1
        }
    }
    
    func addNToHUD () {
        /* This function adds the 'N' Sprite Node to the correct LetterBox when "Found." See the annotation in the addAToHUD function above. */
            
        let atlasN = SKTextureAtlas(named: "letters")
        let textureN = atlasN.textureNamed("N")
        textureN.filteringMode = .Nearest
        let sprite = SKSpriteNode(texture: textureN)
        
        if currentLevel == 2 {
            sprite.position = CGPoint(x: xPosition + 25, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            planetFound += 1
        } else if currentLevel == 6 {
            sprite.position = CGPoint(x: xPosition + 75, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            moonFound += 1
        } else if currentLevel == 10 {
            sprite.position = CGPoint(x: xPosition - 125, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            nebulaFound += 1
        } else if currentLevel == 11 {
            sprite.position = CGPoint(x: xPosition + 50, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            sunFound += 1
        }
    }


    func addOToHUD () {
        /* This function adds the 'O' Sprite Node to the correct LetterBox when "Found." See the annotation in the addAToHUD function above. */
            
        let atlasO = SKTextureAtlas(named: "letters")
        let textureO = atlasO.textureNamed("O")
        textureO.filteringMode = .Nearest
        let sprite = SKSpriteNode(texture: textureO)
        
        if currentLevel == 0 {
            sprite.position = CGPoint(x: xPosition - 75, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            rocketFound += 1
        } else if currentLevel == 1 {
            if numO == 0 {
                sprite.position = CGPoint(x: xPosition - 75, y: size.height / 2 - 35)
                makeStars(sprite)
                hudLayerNode.addChild(sprite)
                numO += 1
                cosmosFound += 1
            } else {
                sprite.position = CGPoint(x: xPosition + 75, y: size.height / 2 - 35)
                makeStars(sprite)
                hudLayerNode.addChild(sprite)
                numO = 0
                cosmosFound += 1
            }
        } else if currentLevel == 6 {
            if numO == 0 {
                sprite.position = CGPoint(x: xPosition - 25, y: size.height / 2 - 35)
                makeStars(sprite)
                hudLayerNode.addChild(sprite)
                numO += 1
                moonFound += 1
            } else {
                sprite.position = CGPoint(x: xPosition + 25, y: size.height / 2 - 35)
                makeStars(sprite)
                hudLayerNode.addChild(sprite)
                numO = 0
                moonFound += 1
            }
        } else if currentLevel == 7 {
            sprite.position = CGPoint(x: xPosition - 100, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            orbitFound += 1
        } else if currentLevel == 8 {
            sprite.position = CGPoint(x: xPosition - 50, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            cometFound += 1
        }
    }

    func addPToHUD () {
        /* This function adds the 'P' Sprite Node to the correct LetterBox when "Found." See the annotation in the addAToHUD function above. */
            
        let atlasP = SKTextureAtlas(named: "letters")
        let textureP = atlasP.textureNamed("P")
        textureP.filteringMode = .Nearest
        let sprite = SKSpriteNode(texture: textureP)
        
        if currentLevel == 2 {
            sprite.position = CGPoint(x: xPosition - 125, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            planetFound += 1
        } else if currentLevel == 3 {
            sprite.position = CGPoint(x: xPosition - 50, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            spaceFound += 1
        }
    }
    
    func addRToHUD () {
        /* This function adds the 'R' Sprite Node to the correct LetterBox when "Found." See the annotation in the addAToHUD function above. */
            
        let atlas = SKTextureAtlas(named: "letters")
        let texture = atlas.textureNamed("R")
        texture.filteringMode = .Nearest
        let sprite = SKSpriteNode(texture: texture)
           
        if currentLevel == 0 {
            sprite.position = CGPoint(x: xPosition - 125, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            rocketFound += 1
        } else if currentLevel == 4 {
            sprite.position = CGPoint(x: xPosition + 50, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            starsFound += 1
        } else if currentLevel == 5 {
            sprite.position = CGPoint(x: xPosition, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            earthFound += 1
        } else if currentLevel == 7 {
            sprite.position = CGPoint(x: xPosition - 50, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            orbitFound += 1
        }
    }
    
    func addSToHUD () {
        /* This function adds the 'S' Sprite Node to the correct LetterBox when "Found." See the annotation in the addAToHUD function above. */
            
        let atlasS = SKTextureAtlas(named: "letters")
        let textureS = atlasS.textureNamed("S")
        textureS.filteringMode = .Nearest
        let sprite = SKSpriteNode(texture: textureS)
        
        if currentLevel == 1 {
            if numS == 0 {
                sprite.position = CGPoint(x: xPosition - 25, y: size.height / 2 - 35)
                makeStars(sprite)
                hudLayerNode.addChild(sprite)
                numS += 1
                cosmosFound += 1
            } else {
                sprite.position = CGPoint(x: xPosition + 125, y: size.height / 2 - 35)
                makeStars(sprite)
                hudLayerNode.addChild(sprite)
                numS = 0
                cosmosFound += 1
            }
        } else if currentLevel == 3 {
            sprite.position = CGPoint(x: xPosition - 100, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            spaceFound += 1
        } else if currentLevel == 4 {
            if numS == 0 {
                sprite.position = CGPoint(x: xPosition - 100, y: size.height / 2 - 35)
                makeStars(sprite)
                hudLayerNode.addChild(sprite)
                numS += 1
                starsFound += 1
            } else {
                sprite.position = CGPoint(x: xPosition + 100, y: size.height / 2 - 35)
                makeStars(sprite)
                hudLayerNode.addChild(sprite)
                numS = 0
                starsFound += 1
            }
        } else if currentLevel == 11 {
            sprite.position = CGPoint(x: xPosition - 50, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            sunFound += 1
        }
    }

    
    func addTToHUD () {
        /* This function adds the 'T' Sprite Node to the correct LetterBox when "Found." See the annotation in the addAToHUD function above. */
                            
        let atlasT = SKTextureAtlas(named: "letters")
        let textureT = atlasT.textureNamed("T")
        textureT.filteringMode = .Nearest
        let sprite = SKSpriteNode(texture: textureT)
        
        if currentLevel == 0 {
            sprite.position = CGPoint(x: xPosition + 125, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            rocketFound += 1
        } else if currentLevel == 2 {
            sprite.position = CGPoint(x: xPosition + 125, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            planetFound += 1
        } else if currentLevel == 4 {
            sprite.position = CGPoint(x: xPosition - 50, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            starsFound += 1
        } else if currentLevel == 5 {
            sprite.position = CGPoint(x: xPosition + 50, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            earthFound += 1
        } else if currentLevel == 7 {
            sprite.position = CGPoint(x: xPosition + 100, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            orbitFound += 1
        } else if currentLevel == 8 {
            sprite.position = CGPoint(x: xPosition + 100, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            cometFound += 1
        }
    }
    
    func addUToHUD () {
        /* This function adds the 'U' Sprite Node to the correct LetterBox when "Found." See the annotation in the addAToHUD function above. */
        
        let atlasU = SKTextureAtlas(named: "letters")
        let textureU = atlasU.textureNamed("U")
        textureU.filteringMode = .Nearest
        let sprite = SKSpriteNode(texture: textureU)
        
        if currentLevel == 10 {
            sprite.position = CGPoint(x: xPosition + 25, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            nebulaFound += 1
        } else if currentLevel == 11 {
            sprite.position = CGPoint(x: xPosition, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            sunFound += 1
        }
    }
    
    func addXToHUD () {
        /* This function adds the 'X' Sprite Node to the correct LetterBox when "Found." See the annotation in the addAToHUD function above. */
        
        let atlasX = SKTextureAtlas(named: "letters")
        let textureX = atlasX.textureNamed("X")
        textureX.filteringMode = .Nearest
        let sprite = SKSpriteNode(texture: textureX)
        
        if currentLevel == 9 {
            sprite.position = CGPoint(x: xPosition + 75, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            galaxyFound += 1
        }
    }
    
    func addYToHUD () {
        /* This function adds the 'Y' Sprite Node to the correct LetterBox when "Found." See the annotation in the addAToHUD function above. */
        
        let atlasY = SKTextureAtlas(named: "letters")
        let textureY = atlasY.textureNamed("Y")
        textureY.filteringMode = .Nearest
        let sprite = SKSpriteNode(texture: textureY)
        
        if currentLevel == 9 {
            sprite.position = CGPoint(x: xPosition + 125, y: size.height / 2 - 35)
            makeStars(sprite)
            hudLayerNode.addChild(sprite)
            galaxyFound += 1
        }
    }
    
    func makeStars (sprite: SKSpriteNode) {
        /* This function adds the Stars.sks particle emitter to the screen. */
        
        // The starMusic.mp3 audio file is played at the same time as the Stars appear
        let backgroundMusicURL = NSBundle.mainBundle().URLForResource("starsMusic.mp3", withExtension: nil)
        backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: backgroundMusicURL, error:nil)
        backgroundMusicPlayer.numberOfLoops = 0
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
        
        let emitter = SKEmitterNode(fileNamed: "Stars")
        emitter.particleTexture!.filteringMode = .Nearest
        emitter.targetNode = parent
        emitter.zPosition = 100
        emitter.position = sprite.position
        emitter.runAction(SKAction.removeFromParentAfterDelay(1.0))
        addChild(emitter)
    }
    
    override func didSimulatePhysics() {
        /* The following commands are executed when some kind of Physics is simulated in the app. */
        
        // The view of the level is updated
        let target = getCenterPointWithTarget(player.position)
        worldNode.position += (target - worldNode.position) * 0.1
        
        // If this list is not empty, then the Sprite Nodes within it are actioned
        if !AsToRemove.isEmpty {
            for A in AsToRemove {
                A.runAction(SKAction.removeFromParent()) // The original Sprite is removed from scene
                addAToHUD() // The Sprite is then added to the appropriate LetterBox
                AsToRemove.removeAll() // All Sprite Nodes in the list are removed
            }
            checkWinner() // This function is called to check if that was the last letter needed
        }
        
        if !BsToRemove.isEmpty { // For annotations, see the "if !AsToRemove.isEmpty commands above
            for B in BsToRemove {
                B.runAction(SKAction.removeFromParent())
                addBToHUD()
                BsToRemove.removeAll()
            }
            checkWinner()
        }
        
        if !CsToRemove.isEmpty { // For annotations, see the "if !AsToRemove.isEmpty commands above
            for C in CsToRemove {
                C.runAction(SKAction.removeFromParent())
                addCToHUD()
                CsToRemove.removeAll()
            }
            checkWinner()
        }
        
        if !EsToRemove.isEmpty { // For annotations, see the "if !AsToRemove.isEmpty commands above
            for E in EsToRemove {
                E.runAction(SKAction.removeFromParent())
                addEToHUD()
                EsToRemove.removeAll()
            }
            checkWinner()
        }
        
        if !GsToRemove.isEmpty { // For annotations, see the "if !AsToRemove.isEmpty commands above
            for G in GsToRemove {
                G.runAction(SKAction.removeFromParent())
                addGToHUD()
                GsToRemove.removeAll()
            }
            checkWinner()
        }
        
        if !HsToRemove.isEmpty { // For annotations, see the "if !AsToRemove.isEmpty commands above
            for H in HsToRemove {
                H.runAction(SKAction.removeFromParent())
                addHToHUD()
                HsToRemove.removeAll()
            }
            checkWinner()
        }
        
        if !IsToRemove.isEmpty { // For annotations, see the "if !AsToRemove.isEmpty commands above
            for I in IsToRemove {
                I.runAction(SKAction.removeFromParent())
                addIToHUD()
                IsToRemove.removeAll()
            }
            checkWinner()
        }
        
        if !KsToRemove.isEmpty { // For annotations, see the "if !AsToRemove.isEmpty commands above
            for K in KsToRemove {
                K.runAction(SKAction.removeFromParent())
                addKToHUD()
                KsToRemove.removeAll()
            }
            checkWinner()
        }
        
        if !LsToRemove.isEmpty { // For annotations, see the "if !AsToRemove.isEmpty commands above
            for L in LsToRemove {
                L.runAction(SKAction.removeFromParent())
                addLToHUD()
                LsToRemove.removeAll()
            }
            checkWinner()
        }
        
        if !MsToRemove.isEmpty { // For annotations, see the "if !AsToRemove.isEmpty commands above
            for M in MsToRemove {
                M.runAction(SKAction.removeFromParent())
                addMToHUD()
                MsToRemove.removeAll()
            }
            checkWinner()
        }
        
        if !NsToRemove.isEmpty { // For annotations, see the "if !AsToRemove.isEmpty commands above
            for N in NsToRemove {
                N.runAction(SKAction.removeFromParent())
                addNToHUD()
                NsToRemove.removeAll()
            }
            checkWinner()
        }
        
        if !OsToRemove.isEmpty { // For annotations, see the "if !AsToRemove.isEmpty commands above
            for O in OsToRemove {
                O.runAction(SKAction.removeFromParent())
                addOToHUD()
                OsToRemove.removeAll()
            }
            checkWinner()
        }
        
        if !PsToRemove.isEmpty { // For annotations, see the "if !AsToRemove.isEmpty commands above
            for P in PsToRemove {
                P.runAction(SKAction.removeFromParent())
                addPToHUD()
                PsToRemove.removeAll()
            }
            checkWinner()
        }
        if !RsToRemove.isEmpty { // For annotations, see the "if !AsToRemove.isEmpty commands above
            for R in RsToRemove {
                R.runAction(SKAction.removeFromParent())
                RsToRemove.removeAll()
                addRToHUD()
            }
            checkWinner()
        }
                            
        if !SsToRemove.isEmpty { // For annotations, see the "if !AsToRemove.isEmpty commands above
            for S in SsToRemove {
                S.runAction(SKAction.removeFromParent())
                SsToRemove.removeAll()
                addSToHUD()
            }
            checkWinner()
        }
        
        if !TsToRemove.isEmpty { // For annotations, see the "if !AsToRemove.isEmpty commands above
            for T in TsToRemove {
                T.runAction(SKAction.removeFromParent())
                TsToRemove.removeAll()
                addTToHUD()
            }
            checkWinner()
        }
        
        if !UsToRemove.isEmpty { // For annotations, see the "if !AsToRemove.isEmpty commands above
            for U in UsToRemove {
                U.runAction(SKAction.removeFromParent())
                UsToRemove.removeAll()
                addUToHUD()
            }
            checkWinner()
        }
        
        if !XsToRemove.isEmpty { // For annotations, see the "if !AsToRemove.isEmpty commands above
            for X in XsToRemove {
                X.runAction(SKAction.removeFromParent())
                XsToRemove.removeAll()
                addXToHUD()
            }
            checkWinner()
        }
        
        if !YsToRemove.isEmpty { // For annotations, see the "if !AsToRemove.isEmpty commands above
            for Y in YsToRemove {
                Y.runAction(SKAction.removeFromParent())
                YsToRemove.removeAll()
                addYToHUD()
            }
            checkWinner()
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* This function is called when the user touches the device's screen */
        switch gameState {
            
            // Different actions are available depending on the gameState currently engaged
            
            case .MainMenu: // In the case of Main Menu
                let touchM = touches.anyObject() as UITouch
                let loc = touchM.locationInNode(self)
                
                if playGame.containsPoint(loc) {
                    /* If the playGame button is pressed, the gameState changes to .Playing and the Main Menu items are removed from view. */
                    gameState = .Playing
                    paused = false
                    playGame.hidden = true
                    MainBackground.hidden = true
                    Instructions.hidden = true
                    break
                } else if Instructions.containsPoint(loc) {
                    /* If the Instruction button is pressed, the Instructions image is add to the view and the gameState is changed to .Instructions. */
                    hudLayerNode.addChild(InstructionScreen)
                    InstructionScreen.size.width = size.width
                    InstructionScreen.size.height = size.height
                    InstructionScreen.zPosition = 100
                    gameState = .Instructions
                }
            
        case .Instructions: // In the case of .Instructions
            let touchM = touches.anyObject() as UITouch
            let loc = touchM.locationInNode(self)
            
            if InstructionScreen.containsPoint(loc) {
                /* If user presses anywhere on the screen, the view switches back to the Main Menu. */
                gameState = .MainMenu
                InstructionScreen.removeFromParent()
                break
            }
            
            case .Paused: // In the case of .Paused
                let touchM = touches.anyObject() as UITouch
                let loc = touchM.locationInNode(self)
                
                if Continue.containsPoint(loc) {
                    /* If user presses the Continue button, the game resumes and the Paused Menu items are removed from view. */
                    gameState = .Playing
                    paused = false
                    Continue.removeFromParent()
                    PauseBG.removeFromParent()
                    MainMenu.removeFromParent()
                    break
                    
                } else if MainMenu.containsPoint(loc) {
                    /* If user presses the Main Menu button, the gameState changes to .MainMenu, the Paused Menu items are removed from view and the GameScene is reloaded. */
                    gameState = .MainMenu
                    Continue.removeFromParent()
                    PauseBG.removeFromParent()
                    MainMenu.removeFromParent()
                    
                    let newScene = GameScene(size:size, level: currentLevel, inGame: 0)
                    view!.presentScene(newScene, transition: SKTransition.flipVerticalWithDuration(0))
                    
                    break
                }
                    
                if pause.containsPoint(loc) { // Do nothing if the user touches anywhere else.
                    break
                }
            
                fallthrough
            case .Playing: // In the case of .Playing
                let touch = touches.anyObject() as UITouch
                let touchLocation = touch.locationInNode(hudLayerNode)
                
                
                let pressFire: SKSpriteNode = fire
                let pressStatus: SKSpriteNode = ShipStatus
                
                if pressFire.containsPoint(touchLocation) {
                    /* If user presses the pressFire button, a Rocket is fired (via fireRocket() function) if there is an Enemy in the level and it is in range of the Player Ship. If it is Out of Range, a message flashes on the screen informing the user of this. */
                    if worldNode.childNodeWithName("baddie") != nil {
                        fireRocket()
                    } else {
                        let alertSound = SKAction.playSoundFileNamed("OutOfRangeSound.mp3", waitForCompletion: false)
                        runAction(alertSound)
                        
                        if (hudLayerNode.childNodeWithName("OutOfRange") == nil) {
                            let OutOfRangeMSG = SKSpriteNode(imageNamed: "OutOfRange")
                            hudLayerNode.addChild(OutOfRangeMSG)
                            OutOfRangeMSG.zPosition = 100
                            OutOfRangeMSG.size.height = 25
                            OutOfRangeMSG.size.width = 262
                            OutOfRangeMSG.position = CGPoint(x: 0, y: 150)
                            
                            let fade = SKAction.fadeAlphaTo(0, duration: 2.5)
                            let removeRange = SKAction.removeFromParent()
                            let runSequence = SKAction.sequence([fade, removeRange])
                            OutOfRangeMSG.runAction(runSequence)
                        }
                    }
                    break
                } else if pause.containsPoint(touchLocation) {
                    /* If user presses the Pause button, the gameState changes to .Paused and the Pause Menu items are added to the view. */
                    paused = true
                    
                    hudLayerNode.addChild(PauseBG)
                    PauseBG.zPosition = 60
                    PauseBG.size.width = size.width * 0.8
                    PauseBG.size.height = size.height * 0.4
                    PauseBG.anchorPoint = CGPointZero
                    PauseBG.position = CGPoint(x: -1 * PauseBG.size.width/2,
                                                y: -1 * PauseBG.size.height/2)
                    
                    hudLayerNode.addChild(Continue)
                    Continue.zPosition = 62
                    Continue.size.width = size.width * 0.7
                    Continue.size.height = 50
                    Continue.anchorPoint = CGPointZero
                    Continue.position = CGPoint(x: (-1 * Continue.size.width/2),
                        y: 30)
                    
                    hudLayerNode.addChild(MainMenu)
                    MainMenu.zPosition = 62
                    MainMenu.size.width = size.width * 0.7
                    MainMenu.size.height = 50
                    MainMenu.anchorPoint = CGPointZero
                    MainMenu.position = CGPoint(x: (-1 * Continue.size.width/2),
                        y: -30)
                    
                    gameState = .Paused
                    break
                } else if pressStatus.containsPoint(touchLocation) {
                    /* If user presses anywhere else in the Ship Status rectangle, nothing occurs. */
                    break
                } else if gameState != .MainMenu && gameState != .Paused {
                    /* If user presses anywhere else in the screen (when the game is not in the Main Menu or Pause state), the Player's Ship will move towards that touch location. */
                    player.sprite.removeAllActions()
                    player.emitter.removeAllActions()
                    player.moveToward(touch.locationInNode(worldNode))
                }
            
            case .InLevelMenu: // In the case of .InLevelMenu
                let touch = touches.anyObject() as UITouch
                let loc = touch.locationInNode(self)
                
                if let node = childNodeWithName("nextLevelLabel") {
                    /* If user presses the nextLevelLabel button, the GameScene is reloaded with the currentLevel variable increasing by 1. */
                    if node.containsPoint(loc) {
                        let newScene = GameScene(size:size, level: currentLevel+1, inGame: 1)
                                view!.presentScene(newScene, transition: SKTransition.flipVerticalWithDuration(0))
                        node.removeFromParent()
                        break
                    }
                }
                if let node2 = childNodeWithName("restartLabel") {
                    /* If user presses the restartLabel button, the GameScene is reloaded with the currentLevel variale remaining the same. */
                    if node2.containsPoint(loc) {
                        let newScene = GameScene(size:size, level: currentLevel, inGame: 1)
                        view!.presentScene(newScene, transition: SKTransition.flipVerticalWithDuration(0))
                        node2.removeFromParent()
                        break
                    }
            }
            case .GameLoad:
                break
        }
    }
    
    func fireRocket () { // If the User presses the "fire" button, this function is called.
        
        // The Player Ship and the Enemy Ship locations need to be gathered
        var EnemyPosition = worldNode.childNodeWithName("baddie")?.position
        var ShipLoc = worldNode.childNodeWithName("player")?.position
        var PlayerPosition = ShipLoc!
        var EnemyPositionx = (worldNode.childNodeWithName("baddie")?.position.x)
        var EnemyPositiony = worldNode.childNodeWithName("baddie")?.position.y
        var PlayerPositionx = PlayerPosition.x
        var PlayerPositiony = PlayerPosition.y
        
        // The difference between the locations of the 2 ships needs to be found
        var VectorPoint: CGPoint = (EnemyPosition! - PlayerPosition)
        let offset = CGPoint(x: EnemyPositionx! - PlayerPositionx,
            y: EnemyPositiony! - PlayerPositiony)
        var Offsetx: CGFloat = EnemyPositionx! - PlayerPositionx
        var Offsety: CGFloat = EnemyPositiony! - PlayerPositiony
        let length = sqrt(Double(Offsetx * Offsetx + Offsety * Offsety))
        let direction = CGPoint(x: Offsetx / CGFloat(length), y: Offsety / CGFloat(length))
        let rocketVelocity = CGPoint(x: direction.x, y: direction.y)
        
        let newLocation: CGPoint = EnemyPosition!
        
        // If the ships are close enough to each other for Rocket launch, the Rocket will be created
        if (abs(PlayerPositiony - EnemyPositiony!) <= 350)
            && (abs(PlayerPositionx - EnemyPositionx!) <= 280) {
                //This however will only happen if a Rocket is not already in the scene
                if (worldNode.childNodeWithName("rocket") == nil) {
                    
                    // The next few lines create the sound of the launching rocket
                    let PlayerRocketURL = NSBundle.mainBundle().URLForResource("RocketLaunch.mp3", withExtension: nil)
                    RocketSound = AVAudioPlayer(contentsOfURL: PlayerRocketURL, error:nil)
                    RocketSound.numberOfLoops = 0
                    RocketSound.prepareToPlay()
                    RocketSound.play()
        
                    // The Rocket sprite is added to the scene
                    worldNode.addChild(Rocket)
                    Rocket.name = "rocket"
                    Rocket.position = PlayerPosition
                    Rocket.zPosition = 36
                    Rocket.zRotation = (1 * 3.142)
                    // rotateSprite is called to ensure the Rocket faces the correct direction
                    rotateSprite(Rocket, direction: rocketVelocity)
                    
                    // Actions are created to dictate the Rocket's movement and removal from scene
                    let fire: SKAction = SKAction.moveTo(newLocation, duration: 0.5)
                    let actionRemove = SKAction.removeFromParent()
                    let wait = SKAction.waitForDuration(0.45)
                    // A sound is queued for the Enemy Ship's explosion
                    let actionsound = SKAction.playSoundFileNamed("EnemyExplodes.mp3", waitForCompletion: false)
                    Rocket.runAction(fire)
                    let sequence = SKAction.sequence([wait, actionRemove])
                    Rocket.runAction(sequence)
                    
                    // Actions are created for the Enemy Ship to be removed from the scene
                    let baddieRemove = SKAction.removeFromParent()
                    let wait2 = SKAction.waitForDuration(0.49)
                    let explode = SKAction.runBlock(self.explodeEnemy)
                    
                    let sequence3 = SKAction.sequence([wait2, explode, baddieRemove])
                    runAction(sequence3)
                }
        } else {
            /* If the Ship is out of range, an alert sound is played and a message is displayed. */
            
            let alertSound = SKAction.playSoundFileNamed("OutOfRangeSound.mp3", waitForCompletion: false)
            runAction(alertSound)
            
            if (hudLayerNode.childNodeWithName("OutOfRange") == nil) {
                let OutOfRangeMSG = SKSpriteNode(imageNamed: "OutOfRange")
                hudLayerNode.addChild(OutOfRangeMSG)
                OutOfRangeMSG.zPosition = 100
                OutOfRangeMSG.size.height = 25
                OutOfRangeMSG.size.width = 262
                OutOfRangeMSG.position = CGPoint(x: 0, y: 150)
                
                let fade = SKAction.fadeAlphaTo(0, duration: 2.5)
                let removeRange = SKAction.removeFromParent()
                let runSequence = SKAction.sequence([fade, removeRange])
                OutOfRangeMSG.runAction(runSequence)
            }
        }
    }
    
    func explodePlayer() { // If the Player Ship loses all health, this function is called.
        
        // The User's ship location needs to be gathered
        var PlayerPosition = worldNode.childNodeWithName("player")?.position
        let newLocation: CGPoint = PlayerPosition!
        
        // The explosion emitter needs to be added to the scene
        let emitter = SKEmitterNode(fileNamed: "EnemyExplodes")
        emitter.particleTexture!.filteringMode = .Nearest
        emitter.targetNode = parent
        emitter.zPosition = 100
        emitter.position = newLocation
        emitter.runAction(SKAction.removeFromParentAfterDelay(1.0))
        worldNode.addChild(emitter)
        
        // Explosion sound also added at the same time
        let actionsound = SKAction.playSoundFileNamed("EnemyExplodes.mp3", waitForCompletion: false)
        runAction(actionsound)
        
        // The Player's Ship is now removed from the scene
        worldNode.childNodeWithName("player")?.runAction(SKAction.removeFromParent())
    }
    
    func explodeEnemy() {
        /* This function removes the Enemy Ship from the level */
        
        var EnemyPosition = worldNode.childNodeWithName("baddie")?.position
        var EnemyPositionx = (worldNode.childNodeWithName("baddie")?.position.x)
        var EnemyPositiony = worldNode.childNodeWithName("baddie")?.position.y
        let newLocation: CGPoint = EnemyPosition!
        
        // The exploding emitter node will be added at the Enemy Ship Location
        let emitter = SKEmitterNode(fileNamed: "EnemyExplodes")
        emitter.particleTexture!.filteringMode = .Nearest
        emitter.targetNode = parent
        emitter.zPosition = 100
        emitter.position = newLocation
        emitter.runAction(SKAction.removeFromParentAfterDelay(1.0))
        worldNode.addChild(emitter)
        
        // The ship explosion sound will be played
        let actionsound = SKAction.playSoundFileNamed("EnemyExplodes.mp3", waitForCompletion: false)
        runAction(actionsound)
        
        // The Enemy Ship node is removed from the level
        worldNode.childNodeWithName("baddie")?.runAction(SKAction.removeFromParent())
    }

    
    func getCenterPointWithTarget(target: CGPoint) -> CGPoint {
        /* This function returns the point at which the middle of the screen should be for the "camera" view to centerd on as the Player Ship flies around. */
        let x = target.x.clamped(
            size.width / 2,
            backgroundLayer.layerSize.width - size.width / 2
            )
        let y = target.y.clamped(
            size.height / 2,
            backgroundLayer.layerSize.height - size.height / 2
            )
        return CGPoint(x: -x, y: -y)
    }
    
}

