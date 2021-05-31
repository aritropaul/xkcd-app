//
//  Extensions.swift
//  XKCD
//
//  Created by Aritro Paul on 31/05/21.
//

import Foundation
import UIKit

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
    
    func enableZoom() {
      let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
      isUserInteractionEnabled = true
      addGestureRecognizer(pinchGesture)
    }

    @objc
    private func startZooming(_ sender: UIPinchGestureRecognizer) {
      let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
      guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
      sender.view?.transform = scale
      sender.scale = 1
    }
}

extension UIImage {
    func getImageRatio() -> CGFloat {
        let imageRatio = CGFloat(self.size.width / self.size.height)
        return imageRatio
    }
}


func getDim(urlString: String) -> (CGFloat, CGFloat) {
    if let url = URL(string: urlString) {
        if let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil) {
         if let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as Dictionary? {
              let pixelWidth = imageProperties[kCGImagePropertyPixelWidth] as! CGFloat
              let pixelHeight = imageProperties[kCGImagePropertyPixelHeight] as! CGFloat
              return (pixelWidth, pixelHeight)
           }
       }
    }
    return (0.0, 0.0)
}
