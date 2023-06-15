//
//  ImagesCollectionViewCell.swift
//  FirminiqMT
//
//  Created by Arun Vijay on 15/06/23.
//

import UIKit

class ImagesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var downloadProgressView: UIProgressView!
    @IBOutlet weak var downloadProgressLabel: UILabel!
    @IBOutlet weak var downloadErrorLabel: UILabel!
    
    var downloadProgress : Float = 0 {
        didSet {
            DispatchQueue.main.async {
                self.downloadProgressView.progress = self.downloadProgress
                self.downloadProgressLabel.text = String(format: "%.2f", self.downloadProgress*100) + "%"
            }
        }
    }
    
    var downloadedImage : UIImage = UIImage(named: "placeholder") ?? UIImage() {
        didSet {
            DispatchQueue.main.async {
                self.mainImageView.image = self.downloadedImage
            }
        }
    }
    
    override func awakeFromNib() {
        downloadProgressView.transform = downloadProgressView.transform.scaledBy(x: 1, y: 7)
        downloadedImage = UIImage(named: "placeholder") ?? UIImage()
        ImageDownloader.sharedDownloader.delegate = self
    }
    
    func configureCellWithImage(url:String) {
        ImageDownloader.sharedDownloader.downloadImageFrom(url: url)
    }
}

extension ImagesCollectionViewCell : ImageDownloaderDelegate {
    func updateDownload(progress: Float) {
        self.downloadProgress = progress
    }
    
    func didDownload(image: Data) {
        if let img = UIImage(data: image) {
            downloadedImage = img
        }
    }
    
    
}
