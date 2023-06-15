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
    
    /// Fetch all images in asynchronous or synchronous
    /// - Parameter isASyncDownloadEnabled: Flag to decide sync or async download to be perform..
    func fetchImages(isAsync: Bool){
        ImageDownloader.sharedDownloader.delegate = self
        ImageDownloader.sharedDownloader.downloadImages(isASyncDownloadEnabled: isAsync, imageList: imgRecords)
    }
    
    
    /// Used to communicate between HomeViewController and APIManager for "Pause Download"
    func pauseDownload(){
        ImageDownloader.sharedDownloader.pauseDownload()
    }
    
    /// Used to communicate between HomeViewController and APIManager for "Resume Download"
    func resumeDownload(){
        ImageDownloader.sharedDownloader.resumeDownload()
    }
    
    /// Used to reset the datasource's downloaded images , when a new start download begins.
    func resetDownloadedImages(){
        for (index, _) in self.imgRecords.enumerated() {
            self.imgRecords[index].imageValue = nil
            self.imgRecords[index].progressValue = 0.0
            
        }
    }
    
    
//    func startDownload() {
//        for item in imgRecords {
//            ImageDownloader.sharedDownloader.downloadImageFrom(url: item.imageUrl)
//        }
//    }
}

extension HomeViewVM : ImageDownloaderDelegate {
    /// Callback method from APIManager to perform download progres update
    /// - Parameters:
    ///   - progress: Percentage of downloading image
    ///   - requestedURL: Used to map the percentage againts correct object in datasource
    func updateDownload(progress: Float, requestedURL: URL) {
        if let row = self.imgRecords.firstIndex(where: {$0.imageUrl == requestedURL.absoluteString}) {
            self.imgRecords[row].progressValue = progress
        }
        self.delegate?.reloadImageCV()
    }
    
    /// Notifies all images downloaded completely
    func downloadCompleted() {
        self.delegate?.didDownloadAllImages()
    }
    
    /// Notifies when an image downloaded completely
    /// - Parameters:
    ///   - downloadedImage: UImage downloaded
    ///   - requestedURL: Used to map the percentage againts correct object in datasource
    func didDownload(image: UIImage, requestedURL: URL) {
        if let row = self.imgRecords.firstIndex(where: {$0.imageUrl == requestedURL.absoluteString}) {
            self.imgRecords[row].imageValue = image
        }
        self.delegate?.reloadImageCV()
    }
    
    
    
    
    /*
    func updateDownload(progress: Float, requestedURL: URL) {
        if let row = self.imgRecords.firstIndex(where: {$0.imageUrl == requestedURL.absoluteString}) {
            self.imgRecords[row].progressValue = progress
        }
        self.delegate?.reloadImageCV()
    }
    
    func didDownload(image: Data, requestedURL: URL) {
        if let img = UIImage(data: image) {
            if let row = self.imgRecords.firstIndex(where: {$0.imageUrl == requestedURL.absoluteString}) {
                self.imgRecords[row].imageValue = img
            }
        }
        else {
            return
        }
        self.delegate?.reloadImageCV()
    } */
    
}
