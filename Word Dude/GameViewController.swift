//
//  GameViewController.swift
//  PestControl
//
//  Created by Steve O'Gallagher on 09/02/2015.
//  Copyright (c) 2015 Steve O'Gallagher. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

extension SKNode {
    
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController {
    
    var backgroundMusicPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        
        var backgroundMusicPlayer: AVAudioPlayer!
        super.viewDidLoad()
        let scene = GameScene(size: view.bounds.size)
        let skView = view as SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = false
        scene.scaleMode = .ResizeFill
        skView.presentScene(scene)
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // When the first scene loads onto the device, the background music "WordDudeBG.mp3" will play.
    override func viewDidAppear(animated: Bool) {
        
        // The URL for the music file is retrieved
        let backgroundMusicURL = NSBundle.mainBundle().URLForResource("WordDudeBG.mp3", withExtension: nil)
        
        // The parameters for the music player system are declared
        backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: backgroundMusicURL, error:nil)
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.prepareToPlay()
        
        // The music will begin to play when the next line is executed.
        backgroundMusicPlayer.play()
    }

}
