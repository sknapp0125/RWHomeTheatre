/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import AVKit

class PlayVideoViewController: UIViewController {
  
  // MARK: - Outlets
  
  @IBOutlet weak var durationLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  
  // MARK: - Instance Variables
  
    var asset: AVAsset!
    var video: Video! {
        didSet {
        asset = AVAsset(URL: video.videoURL)
        }
    }
    var videoCategory: VideoCategory!
    var embeddedPlayerViewController: AVPlayerViewController!
    let playerViewControllerSegueIdentifier = "PlayerViewControllerSegue"
    var fullScreenPlayerViewController: AVPlayerViewController!
  
  // MARK: - View Lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFullScreenBarButtonItem()
       
    }
     func setupFullScreenBarButtonItem() {
        let fullScreenButton = UIBarButtonItem(title: "Full Screen",
        style: .Plain,
        target: self,
        action: "fullScreenButtonPressed:")
        navigationItem.leftBarButtonItem = fullScreenButton
    }
    func fullScreenButtonPressed(button: AnyObject) {
            
        func setLabelsText() {
            // 1
            titleLabel.text = video.title
            // 2
            asset.loadValuesAsynchronouslyForKeys(["duration"], completionHandler: { [unowned self]() in
                // 3
                var error: NSError?
                let status = self.asset.statusOfValueForKey("duration", error: &error)
                if status != AVKeyValueStatus.Loaded {
                print("Unable to load video duration")
                    if let error = error {
                    print("\(error)")
                    }
                    return
                }
                // 4
                let totalTimeInSeconds = CMTimeGetSeconds(self.asset.duration)
                let displayMinutes = Int(totalTimeInSeconds / 60)
                let displaySeconds = Int(totalTimeInSeconds % 60)
                // 5
                dispatch_async(dispatch_get_main_queue(), { () -> Void in self.durationLabel.text = "\(displayMinutes):" + "\(displaySeconds)"
                })
            })
        }
            
            // 1
            let embeddedPlayer = embeddedPlayerViewController.player!
            let rate = embeddedPlayer.rate
            let seekTime = embeddedPlayer.currentTime()
            // 2
            embeddedPlayer.pause()
            embeddedPlayerViewController.player = embeddedPlayer
            // 3
            let playerItem = AVPlayerItem(asset: asset)
            let fullScreenPlayer = AVPlayer(playerItem: playerItem)
            fullScreenPlayer.rate = rate
            // 4
            if seekTime.isValid {
            fullScreenPlayer.seekToTime(seekTime)
            }
            // 5
            fullScreenPlayerViewController = AVPlayerViewController()
            fullScreenPlayerViewController!.player = fullScreenPlayer
            presentViewController(fullScreenPlayerViewController!,
            animated: true, completion: nil)
    }
    
    // 1
     override func prepareForSegue(segue: UIStoryboardSegue,
        sender: AnyObject?) {
            
            // 1
            func viewWillAppear(animated: Bool) {
            super.viewWillAppear(animated)
            updateEmbeddedPlayerFromFullScreenPlayer()
            }
            func updateEmbeddedPlayerFromFullScreenPlayer() {
            // 2
            guard let fullScreenPlayerViewController =
            self.fullScreenPlayerViewController
            else {
            return
            }
            // 3
            let fullScreenPlayer = fullScreenPlayerViewController.player
            let seekTime = fullScreenPlayer!.currentTime()
            let rate = fullScreenPlayer!.rate
            fullScreenPlayer?.pause()
            // 4
            let embeddedPlayer = embeddedPlayerViewController.player!
            if seekTime.isValid {
            embeddedPlayer.seekToTime(seekTime)
            }
            embeddedPlayer.rate = rate
            embeddedPlayerViewController.player = embeddedPlayer
            }
            
        // 2
        if segue.identifier == playerViewControllerSegueIdentifier {
        embeddedPlayerViewController = segue.destinationViewController as!
        AVPlayerViewController
        // 3
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        embeddedPlayerViewController.player = player
        } }
    
 }

// MARK: - Class Construtors
extension PlayVideoViewController {
  
  class func instanceWithVideo(video: Video, videoCategory: VideoCategory) -> PlayVideoViewController {
    
    let bundle = NSBundle.mainBundle()
    let storyboard = UIStoryboard(name: "Main", bundle: bundle)
    let identifier = "PlayVideoViewController"
    
    let viewController = storyboard.instantiateViewControllerWithIdentifier(identifier) as!
    PlayVideoViewController
    viewController.video = video
    viewController.videoCategory = videoCategory
    viewController.title = videoCategory.name
    return viewController
  }
}
