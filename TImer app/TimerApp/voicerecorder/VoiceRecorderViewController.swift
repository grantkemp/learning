//
//  VoiceRecorderViewController.swift
//  TimerApp
//
//  Created by Grant Kemp on 4/5/15.
//  Copyright (c) 2015 alexanderkustov. All rights reserved.
//

import UIKit
import AVFoundation

class VoiceRecorderViewController: UIViewController,AVAudioRecorderDelegate{

    var audioRecorder:AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    @IBOutlet var recordingtext: UILabel!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var out_playbackbutton: UIButton!
    
    
    //BUTTON  ACTIONS
    
    @IBAction func microphoneButton(sender: AnyObject) {
        
        
       
        out_playbackbutton.hidden = false
        recordButton.enabled = false
        recordingtext.hidden = false
        recordingtext.text = "Recording"
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        guard let filePathURL = NSURL.fileURLWithPathComponents(pathArray) else {
            print("Unknown error setting up URL: \(pathArray)")
            return
        }
        
        let session = AVAudioSession.sharedInstance()
       
        do {
        try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            
        } catch {
            print("error")
        }
        

        do {
            audioRecorder = try AVAudioRecorder(URL: filePathURL, settings: [:])
        } catch let error as NSError {
            print("error setting up Audio Recorder: \(error.localizedDescription)")
            return
        }
        
        
        audioRecorder.delegate = self

        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    
    
    
    @IBAction func playbackButton(sender: AnyObject) {
        
        out_playbackbutton.hidden = true
        recordButton.enabled = true
        
        recordingtext.text = "Tap to Record"
        //Stops recording
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch _ {
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    override func viewWillAppear(animated: Bool) {
        out_playbackbutton.hidden = true
        recordButton.enabled = true
        recordingtext.text = "Tap to Record"
    }
    
       func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag){
        // Save contents
        recordedAudio = RecordedAudio(path: recorder.url, mainTitle: recorder.url.lastPathComponent!)
       
        //Send via Segue
        performSegueWithIdentifier("showRecordingPlayback", sender: recordedAudio)
        }
        else {
            print("Recording was not successful")
        }
        out_playbackbutton.hidden = true
        recordButton.enabled = true
       recordingtext.text = "Tap to Record"

        
     
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showRecordingPlayback") {
            let playsoundsvc: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playsoundsvc.receivedAudio = data
        }
    }
    
}
