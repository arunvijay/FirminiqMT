//
//  ImageDownloader.swift
//  FirminiqMT
//
//  Created by Arun Vijay on 15/06/23.
//

import Foundation
import UIKit

protocol ImageDownloaderDelegate : AnyObject {
    func updateDownload(progress:Float, requestedURL:URL)
    func downloadCompleted()
    func didDownload(image:UIImage, requestedURL:URL)
}

class ImageDownloader : NSObject {
    static let sharedDownloader = ImageDownloader()
    public weak var delegate : ImageDownloaderDelegate?
    
    var queue : OperationQueue!
    var session : URLSession!
    var operation: DownloadOperation?
    
    /// Handles the pause download, communicating to DownloadOperation
    func pauseDownload(){
        operation?.pause()
    }
    
    
    /// Handles the resume download, communicating to DownloadOperation
    func resumeDownload(){
        operation?.resumeDownload()
    }
    
    /// Initiate the imagedownloading
    /// - Parameters:
    ///   - isASyncDownloadEnabled: Indicates whether the user selected Async  mode for downloading.
    ///   - imageList: Datasource with image objects whch contains images urls
    func downloadImages(isASyncDownloadEnabled: Bool, imageList: [ImageRecord]){
        session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
        queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        if isASyncDownloadEnabled {
            queue.maxConcurrentOperationCount = 4
        }
        
        let completionOperation = BlockOperation {
            self.delegate?.downloadCompleted()
        }
        
        for (_, url) in imageList.enumerated() {
            operation = DownloadOperation(session: session, delegate: self, downloadTaskURL:URL(string: url.imageUrl)!, completionHandler: { (localURL, urlResponse, error) in
            })
            
            completionOperation.addDependency(self.operation!)
            self.queue.addOperation(self.operation!)
        }
        self.queue.addOperation(completionOperation)
    }
}

extension ImageDownloader : DownloadOperationDelegate {
    
    /// Update the progress of download percentage
    /// - Parameters:
    ///   - progress: Download progress value as Float
    ///   - requestedURL:  The request url , to map the downloaded image with datasource.
    func updateDownload(progress: Float, requestedURl: URL) {
        self.delegate?.updateDownload(progress: progress, requestedURL: requestedURl)
    }
    
    /// Indicates a single image downloaded successfully
    /// - Parameters:
    ///   - lcoalURl: Local file path in tmp folder, the file downloaded to.
    ///   - requestedURL: The request url , to map the downloaded image with datasource.
    func didDownloadImage(lcoalURl: URL, requestedURL: URL) {
        do{
            let reader = try FileHandle(forReadingFrom: lcoalURl)
            let data = reader.readDataToEndOfFile()
            guard let img = UIImage(data: data) else { return }
            self.delegate?.didDownload(image: img, requestedURL: requestedURL)
        }catch{
            
        }
    }
}
