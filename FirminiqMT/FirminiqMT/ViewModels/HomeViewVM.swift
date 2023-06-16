//
//  HomeViewVM.swift
//  FirminiqMT
//
//  Created by Arun Vijay on 15/06/23.
//

import Foundation
import UIKit

protocol HomeViewVMDelegate {
    func reloadImageCV()
    func didDownloadAllImages()
}

class HomeViewVM {
    
    public static let sharedVM = HomeViewVM()
    public var delegate : HomeViewVMDelegate?
    private var imageURLs = [String]()
    private var imgRecords = [ImageRecord]()
    
    init() {
        ImageDownloader.sharedDownloader.delegate = self
    }
    
    func getImageRecords() -> [ImageRecord] {
        imageURLs = DataProcessor.getImageURLs()
        for urlStr in imageURLs {
            imgRecords.append(ImageRecord(imageUrl: urlStr))
        }
        return imgRecords
    }
    
    func getImageCount() -> Int {
        return imgRecords.count
    }
    
    /// Fetch all images asynchronous or synchronous
    /// - Parameter isAsync: set this to true to download concurrently, false to download serially
    func fetchImages(isAsync: Bool){
        ImageDownloader.sharedDownloader.delegate = self
        ImageDownloader.sharedDownloader.downloadImages(isAsync: isAsync, imageList: imgRecords)
    }
    
    /// Exposed to view to send the pause action from the UI
    func pauseDownload(){
        ImageDownloader.sharedDownloader.pauseDownload()
    }
    
    /// Exposed to view to send the resume action from the UI
    func resumeDownload(){
        ImageDownloader.sharedDownloader.resumeDownload()
    }
    
    /// To reset the datasource's downloaded images , when a new start download begins.
    func resetDownloadedImages(){
        for (index, _) in self.imgRecords.enumerated() {
            self.imgRecords[index].imageValue = nil
            self.imgRecords[index].progressValue = 0.0
        }
    }
}

extension HomeViewVM : ImageDownloaderDelegate {
    /// Callback method from ImageDownloader to update download progres.
    /// - Parameters:
    ///   - progress: Percentage of downloading completed
    ///   - requestedURL: Used to map the percentage againts correct object in datasource
    func updateDownload(progress: Float, requestedURL: URL) {
        if let row = self.imgRecords.firstIndex(where: {$0.imageUrl == requestedURL.absoluteString}) {
            self.imgRecords[row].progressValue = progress
        }
        self.delegate?.reloadImageCV()
        
    }
    
    /// Invoked when all images downloaded completely
    func downloadCompleted() {
        self.delegate?.didDownloadAllImages()
    }
    
    /// Invoked when an image download completed
    /// - Parameters:
    ///   - downloadedImage: Downloaded image as UIImage instance
    ///   - requestedURL: Used to map the percentage againts correct object in datasource
    func didDownload(image: UIImage, requestedURL: URL) {
        if let row = self.imgRecords.firstIndex(where: {$0.imageUrl == requestedURL.absoluteString}) {
            self.imgRecords[row].imageValue = image
            self.imgRecords[row].hasImageDwonloaded = true
        }
        self.delegate?.reloadImageCV()
    }
}
