//
//  ViewController.swift
//  airplaytest
//
//  Created by apple on 29/04/2016.
//  Copyright (c) 2016 katie mcgowan. All rights reserved.
//

import UIKit
import MediaPlayer
import YouTubePlayer

//let playerFrame =

var videoPlayer = YouTubePlayerView(frame: CGRect(x: 0, y: 0, width: 1280, height: 720))

class VideoView: UIViewController {
    
    var secondWindow : UIWindow?
    var secondScreenView : UIView?
    var externalLabel = UILabel()
    var currentScreens = 0
    var loadImage = UIImage()
    
    let videos = buildVideos()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setupScreen()
        videoPlayer.delegate = self
        
    }
    
    @IBAction func play(sender: AnyObject) {
        currentScreens = sender.tag!
        
        if UIScreen.screens().count > 1 {
            playvideo()
            performSegueWithIdentifier("VideoDetail", sender: videos[sender.tag!])
        } else {
            performSegueWithIdentifier("NoAirplay", sender: videos[sender.tag!])
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "VideoDetail" {
            let vc = segue.destinationViewController as! DetailView
            vc.video = sender as! Video
        }
        
        if segue.identifier == "NoAirplay" {
            let vc = segue.destinationViewController as! NoAirplay
            vc.video = videos[currentScreens
            ]
            
        }
    }
    
    
    
    func setupScreen(){
        if UIScreen.screens().count > 1 {
            //find the second screen (the 'as! UIScreen' is not needed in Xcode 7 and above)
            let secondScreen = UIScreen.screens()[1]
            
            //set up a window for the screen using the screens pixel dimensions
            secondWindow = UIWindow(frame: secondScreen.bounds)
            
            //tell the window which screen to use
            secondWindow?.screen = secondScreen
            
            //set the dimensions for the view for the external screen so it fills the screen
            secondScreenView = UIView(frame: secondWindow!.frame)
            
            //add the view to the second screens window
            secondWindow?.addSubview(secondScreenView!)
            
            //unhide the window
            secondWindow?.hidden = false
            
            //customised the view
            secondScreenView!.backgroundColor = UIColor.blackColor()
            
            
            videoPlayer.frame = secondScreenView!.bounds
            
            let width = secondScreenView!.bounds.size.width
            let height = secondScreenView!.bounds.size.height
            
            
            
            let myImage = UIImage(named: "logoLight.png")
            let myImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
            myImageView.image = myImage
            
            secondScreenView!.addSubview(myImageView)
            
        }
    }
    
    
    
    
    
    func registerForScreenNotifications(){
        let notificationCentre = NSNotificationCenter.defaultCenter()
        notificationCentre.addObserver(self, selector: Selector("setupScreen"), name: UIScreenDidConnectNotification, object: nil)
    }
    
    func playvideo() {
        
        secondScreenView!.addSubview(videoPlayer)
        
        videoPlayer.loadVideoID(videos[currentScreens].id)
        if videoPlayer.ready {
            //            videoPlayer.playerVars = [
            //                "controls": "0",
            //                "showinfo": "0",
            //                "rel" : 0,
            //                "showinfo" : 0
            //            ]
            videoPlayer.play()
            
        }
        
    }
    
    
    
}

extension VideoView: YouTubePlayerDelegate {
    
    func playerReady(playerView: YouTubePlayerView) {
        
    }
    
    func playerStateChanged(playerView: YouTubePlayerView, playerState: YouTubePlayerState) {
        if playerState == YouTubePlayerState.Ended {
            setupScreen()
        }
        
    }
    
    func playerQualityChanged(videoPlayer: YouTubePlayerView, playbackQuality: YouTubePlaybackQuality) {
        
    }
    
    
}


