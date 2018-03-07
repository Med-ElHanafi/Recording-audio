//
//  DisplayViewController.swift
//  MandoRecords
//
//  Created by Mohamed El Hanafi on 13/02/2018.
//  Copyright © 2018 Mohamed El Hanafi. All rights reserved.
//

import UIKit
import AVFoundation
class DisplayViewController: UIViewController {

    var recievedaudio:MyAudio!
    var audioPlayer:AVAudioPlayer!
    var audioEngine: AVAudioEngine!
    var audiofile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title="Play sound"
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: recievedaudio.pathUrl)
            audioPlayer.enableRate=true
        } catch let error {
            print("Recieved audio \(error.localizedDescription)")
        }
        
        audioEngine = AVAudioEngine()
        
        do {
            try audiofile = AVAudioFile(forReading: recievedaudio.pathUrl)
        } catch let error {
            print(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlow(_ sender: Any) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        audioPlayer.rate = 0.5
        audioPlayer.play()
    }
    
    @IBAction func playFast(_ sender: Any) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        audioPlayer.rate = 2
        audioPlayer.play()
    }
    
    @IBAction func stop(_ sender: Any) {
        audioPlayer.stop()
    }
    
    @IBAction func playChipmunkSound(_ sender: Any) {
        playAudioWithPitch(pitch: 1000)
    }
    
    @IBAction func playBearSound(_ sender: Any) {
        playAudioWithPitch(pitch: -1000)
    }
    func playAudioWithPitch(pitch :Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let avAudioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(avAudioPlayerNode)
        
        let changeAudioPitch = AVAudioUnitTimePitch()
        changeAudioPitch.pitch = pitch
        audioEngine.attach(changeAudioPitch)
        
        audioEngine.connect(avAudioPlayerNode, to: changeAudioPitch, format: nil)
        audioEngine.connect(changeAudioPitch, to: audioEngine.outputNode, format: nil)
        
        avAudioPlayerNode.scheduleFile(audiofile, at: nil, completionHandler: nil)
        do {
            try audioEngine.start()
            avAudioPlayerNode.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
