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
        playAudiofromLocalFile(2)
    }
    @IBAction func playslowly(sender: AnyObject) {
       
        playAudiofromLocalFile(0.5)
    }

    @IBAction func playvader(sender: AnyObject) {
        playAudioWithVariablePitch(-1000)
    }
    @IBAction func stopPlayback(sender: AnyObject) {
        stopAndResetPlaybackState()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//       //pitch processer
        
        audioEngine = AVAudioEngine()
        audioFile = try? AVAudioFile(forReading: receivedAudio.filePathUrl)
        
        let localFilePath = receivedAudio.filePathUrl
        do {
            audio = try AVAudioPlayer(contentsOfURL: localFilePath)
        } catch let error as NSError {
            print(error)
            audio = nil
        }
        audio.enableRate = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playAudiofromLocalFile(speedOfPlayback: Float) {
      stopAndResetPlaybackState()
        
        audio.rate = speedOfPlayback
        audio.prepareToPlay()
        audio.play()
        

    }
    func playAudioWithVariablePitch(pitch: Float){
        stopAndResetPlaybackState()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        do {
            try audioEngine.start()
        }
            catch let error as NSError {
                print("error starting up Audio Engine: \(error.localizedDescription)")
                return
            }
        
        audioPlayerNode.play()
    }
    func stopAndResetPlaybackState(){
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        audioEngine.stop()
        audioEngine.reset()
    }
    

}
