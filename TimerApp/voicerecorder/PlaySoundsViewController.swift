//
//  PlaySoundsViewController.swift
//  TimerApp
//
//  Created by Grant Kemp on 4/5/15.
//  Copyright (c) 2015 alexanderkustov. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audio:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    @IBOutlet var stopPlaybackButton: UIButton!
    //BUTTONS
    
    @IBAction func playchipmunk(sender: AnyObject) {
        playAudioWithVariablePitch(1000)
        
    }
    @IBAction func playfast(sender: AnyObject) {
        playAudiofromLocalFile(2,chipmunk: false)
    }
    @IBAction func playslowly(sender: AnyObject) {
       
        playAudiofromLocalFile(0.5,chipmunk: false)
    }

    @IBAction func playvader(sender: AnyObject) {
        playAudioWithVariablePitch(-1000)
    }
    @IBAction func stopPlayback(sender: AnyObject) {
        audio.stop()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//       //pitch processer
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
        var localFilePath = receivedAudio.filePathUrl
        var errorReport: NSError?
        audio = AVAudioPlayer(contentsOfURL: localFilePath, error: &errorReport)
        audio.enableRate = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playAudiofromLocalFile(speedOfPlayback: Float,chipmunk: Bool) {
        audio.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        audio.rate = speedOfPlayback
        audio.prepareToPlay()
        audio.play()
        

    }
    func playAudioWithVariablePitch(pitch: Float){
        audio.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    

}
