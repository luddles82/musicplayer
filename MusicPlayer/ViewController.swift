//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Nick Ludlow on 22/05/2015.
//  Copyright (c) 2015 Nick Ludlow. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    var musicPlayer: AVAudioPlayer = AVAudioPlayer()
    var musicFiles = [String]()
    var currentIndex: Int = 0
    
    var timer: NSTimer = NSTimer()
    
    
    @IBOutlet weak var volumeSlider: UISlider!
    
    @IBAction func volumeSliderChanged(sender: AnyObject) {
        
        musicPlayer.volume = volumeSlider.value
    }
    
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    @IBAction func back(sender: AnyObject) {
        
        currentIndex -= 1
        if currentIndex < 0 {
            currentIndex = musicFiles.count - 1
        }
        
        playMusic()
    }
    
    
    @IBAction func next(sender: AnyObject) {
        
        currentIndex += 1
        if currentIndex == musicFiles.count {
            currentIndex = 0
        }
        playMusic()
    }
    
    @IBAction func stop(sender: AnyObject) {
        
        musicPlayer.stop()
        musicPlayer.currentTime = 0
    }

    
    @IBAction func play(sender: AnyObject) {
        musicPlayer.play()
    }
    
    
    @IBAction func pause(sender: AnyObject) {
        musicPlayer.pause()
    }
    
    @IBOutlet weak var musicSlider: UISlider!
    
    
    @IBAction func musicSliderChnagesd(sender: AnyObject) {
        
        if musicPlayer.playing{
            musicPlayer.currentTime = NSTimeInterval(musicSlider.value)
        }
        
    }
    
    func playMusic() {
        //println("Play music has been called")
        
        var filePath = NSString(string: NSBundle.mainBundle().pathForResource(musicFiles[currentIndex], ofType: "mp3")!)
        //println(filePath)
        
        var fileURL = NSURL(fileURLWithPath: filePath as String)
        
        musicPlayer = AVAudioPlayer(contentsOfURL: fileURL, error: nil)
        musicPlayer.delegate = self
        musicSlider.minimumValue = 0
        musicSlider.maximumValue = Float(musicPlayer.duration)
        
        musicSlider.value = Float(musicPlayer.currentTime)
        
        musicPlayer.volume = volumeSlider.value
        
        musicPlayer.play()
    
    }
    
    func updateSlider() {
        //println("Update Slider")
        
        musicSlider.value = Float(musicPlayer.currentTime)
        timeLabel.text = updateTime(musicPlayer.currentTime)
        
    
    }
    
    func updateTime(currentTime: NSTimeInterval) -> String {
        
        let current: Int = Int(currentTime)
        
        let minutes = current / 60
        let seconds = current % 60
        let minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        let secondsString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        
        return minutesString + ":" + secondsString
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        let random = arc4random_uniform(UInt32(musicFiles.count))
            currentIndex = Int(random)
            playMusic()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1...10 {
            musicFiles.append("\(i)")
        }
        
        timeLabel.text = "00:00"
        
        playMusic()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateSlider"), userInfo: nil, repeats: true)
        
    }

}

