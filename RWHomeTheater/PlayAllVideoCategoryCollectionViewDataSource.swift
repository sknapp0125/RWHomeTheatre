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

struct PlayAllVideoCategoryIdentifiers {
  static let VideoCell = "VideoCell"
}

class PlayAllVideoCategoryCollectionViewDataSource: NSObject {
    
  var videoCategory: VideoCategory?
  
  func videoForIndexPath(indexPath: NSIndexPath) -> Video? {
    
    guard let videoCategory = self.videoCategory else {
      return nil
    }
    
    return videoCategory.videos[indexPath.row]
  }
}

extension PlayAllVideoCategoryCollectionViewDataSource: UICollectionViewDataSource {
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    guard let videoCategory = self.videoCategory else {
      return 0
    }
    
    return videoCategory.videos.count
  }
  
  func collectionView(collectionView: UICollectionView,
    cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      
      let identifier = PlayAllVideoCategoryIdentifiers.VideoCell
      
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier,
        forIndexPath: indexPath) as! VideoCell
      cell.video = videoForIndexPath(indexPath)
      return cell
  }
}
