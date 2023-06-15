//
//  DownloadOperation.swift
//  FirminiqMT
//
//  Created by Arun Vijay on 16/06/23.
//

import Foundation

/// Protocol to support the data transition  between DownloadOperation and  ImageDownloader
protocol DownloadOperationDelegate: AnyObject {
    func updateDownload(progress: Float, requestedURl: URL)
    func didDownloadImage(lcoalURl: URL, requestedURL: URL)
    
}

class DownloadOperation : Operation {
    
    weak var delegate: DownloadOperationDelegate?
    var task : URLSessionDownloadTask!
    var session : URLSession!
    var resumeData: Data?
    
    enum OperationState : Int {
        case ready
        case executing
        case finished
    }
    
    // default state is ready (when the operation is created)
    private var state : OperationState = .ready {
        willSet {
            self.willChangeValue(forKey: "isExecuting")
            self.willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            self.didChangeValue(forKey: "isExecuting")
            self.didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isReady: Bool { return state == .ready }
    override var isExecuting: Bool { return state == .executing }
    override var isFinished: Bool { return state == .finished }
    
    
    init(session: URLSession, delegate: DownloadOperationDelegate?, downloadTaskURL: URL, completionHandler: ((URL?, URLResponse?, Error?) -> Void)?) {
        
        self.delegate = delegate
        
        super.init()
        // use weak self to prevent retain cycle
        
        //overwrite the session configuration to set delegate to DownloadOperation(self)
        self.session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        
        task = self.session.downloadTask(with: downloadTaskURL)
    }
    
    override func start() {
        /*
         if the operation or queue got cancelled even
         before the operation has started, set the
         operation state to finished and return
         */
        if(self.isCancelled) {
            state = .finished
            return
        }
        
//        self.task.delegate = self
        
        // set the state to executing
        state = .executing
        
        // start the downloading
        self.task.resume()
    }
    
    override func cancel() {
        super.cancel()
        
        // cancel the downloading
        self.task.cancel()
    }
    
    /// Pause the image downloading.
    func pause(){
        print("task suspended")
        self.task.cancel { resumeDataOrNil in
            guard let resumeData = resumeDataOrNil else {
                // download can't be resumed; remove from UI if necessary
                return
            }
            self.resumeData = resumeData
        }
    }
    
    /// Resume the image downloading.
    func resumeDownload(){
        guard let resumeData = self.resumeData else {
            return
        }
        
        self.session.downloadTask(withResumeData: resumeData) { localUrl, URLResponse, error in
        }
    }
}

extension DownloadOperation: URLSessionTaskDelegate, URLSessionDownloadDelegate {
    
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        
        let totalDownloaded = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)/100
        self.delegate?.updateDownload(progress: totalDownloaded, requestedURl: (downloadTask.response?.url!)!)
    }
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        self.state = .finished
        self.delegate?.didDownloadImage(lcoalURl: location, requestedURL: (downloadTask.response?.url!)!)
        
    }
}
