//
//  ViewController.swift
//  MandoRecords
//
//  Created by Mohamed El Hanafi on 13/02/2018.
//  Copyright © 2018 Mohamed El Hanafi. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVAudioRecorderDelegate {

    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var recordedAudio: MyAudio!
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title="Record"
    }
    override func viewWillAppear(_ animated: Bool) {
        recordLabel.isHidden=true
        stopButton.isHidden=true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startRecording(_ sender: Any) {
        stopButton.isHidden=false
        recordLabel.isHidden=false
        recordButton.isEnabled=false
        recordAudio()
    }
    
    @IBAction func stoRecording(_ sender: Any) {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch let error {
            print("stop recording error \(error)")
        }
    }
    
    
    func recordAudio(){
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let currentDateTime = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.string(from: currentDateTime as Date)+".m4a"
        let pathArray = [dirPath,recordingName]
        let pathFile=NSURL.fileURL(withPathComponents: pathArray)
        print(pathFile!.absoluteString)
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.setActive(true)
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
            ]
            try audioRecorder = AVAudioRecorder(url: pathFile!, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            
        } catch let error {
            print("recording audio error \(error.localizedDescription)")
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            recordedAudio = MyAudio()
            recordedAudio.pathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            self.performSegue(withIdentifier:"goToDisplay", sender: recordedAudio)
        }else{
            print("Recording was not succesfull ")
            recordButton.isEnabled=true
            recordLabel.isHidden=true
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="goToDisplay"{
            let displayVC:DisplayViewController = segue.destination as! DisplayViewController
            let data = sender as! MyAudio
            displayVC.recievedaudio = data
            recordButton.isEnabled=true
        }
    }
}

