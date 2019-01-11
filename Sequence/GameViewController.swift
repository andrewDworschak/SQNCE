//
//  GameViewController.swift
//  Sequence
//
//  Created by Andy Dworschak on 2016-03-06.
//  Copyright (c) 2016 App App n Away. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class GameViewController: UIViewController {
    
    let backgroundMusic = try! AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Daybreak", ofType: "mp3")!), fileTypeHint: "mp3")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let musicVolume = defaults.stringForKey("musicVolume") {
            if (Float(musicVolume) != nil){
                backgroundMusic.volume = Float(musicVolume)!
            }
            else {
                backgroundMusic.volume = 1
            }
        }
        else {
            backgroundMusic.volume = 1
        }
        backgroundMusic.numberOfLoops = -1
        backgroundMusic.play()
        
        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .ResizeFill
            
            skView.presentScene(scene)
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
