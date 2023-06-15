//
//  ImageDownloader.swift
//  FirminiqMT
//
//  Created by Arun Vijay on 15/06/23.
//

import Foundation

protocol ImageDownloaderDelegate : AnyObject {
    func updateDownload(progress:Float)
    func didDownload(image:Data)
}

class ImageDownloader : NSObject {
    static let sharedDownloader = ImageDownloader()
    public weak var delegate : ImageDownloaderDelegate?
    
    var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = isSerial ? 1 : HomeViewVM.sharedVM.getImageCount()
        return queue
      }()
    
    func downloadImageFrom(url: String) {
        let operation = BlockOperation {
            if let imgURL = URL(string: url) {
                let config = URLSessionConfiguration.default
                let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
                session.downloadTask(with: URLRequest(url: imgURL)).resume()
            }
        }
        downloadQueue.addOperation(operation)
    }
    
    func pauseDownload() {
        downloadQueue.isSuspended = true
    }
    
    func resumeDownload() {
        downloadQueue.isSuspended = false
    }
}

extension ImageDownloader : URLSessionDelegate, URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do {
            let imgData = try Data(contentsOf: location)
            self.delegate?.didDownload(image: imgData)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
        self.delegate?.updateDownload(progress: progress)
    }
}
