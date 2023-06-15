//
//  HomeViewController.swift
//  FirminiqMT
//
//  Created by Arun Vijay on 14/06/23.
//

import UIKit

var isSerial = true

class HomeViewController: UIViewController {
    
    @IBOutlet weak var downloadButton: MultiActionButton!
    @IBOutlet weak var syncAsyncSelector: UISegmentedControl!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    var downloadButtonTitle : String = "Start" {
        didSet {
            self.downloadButton.setTitle(downloadButtonTitle, for: .normal)
        }
    }
    
    var collectionViewDataSource = [ImageRecord]()

    override func viewDidLoad() {
        super.viewDidLoad()

        HomeViewVM.sharedVM.delegate = self
        downloadButton.action = .start
        downloadButtonTitle = "Start"
        
        collectionViewDataSource = HomeViewVM.sharedVM.getImageRecords()
    }

    @IBAction func downloadButtonAction(_ sender: Any) {
        
        HomeViewVM.sharedVM.resetDownloadedImages()
        reloadImageCV()
        self.syncAsyncSelector.isEnabled = false
        
        switch downloadButton.action {
            case .start:
                self.downloadButton.action = .pause
                self.downloadButtonTitle = "Pause"
                HomeViewVM.sharedVM.fetchImages(isAsync: !isSerial)
            case .pause:
                self.downloadButton.action = .resume
                self.downloadButtonTitle = "Resume"
                HomeViewVM.sharedVM.pauseDownload()
            case .resume:
                self.downloadButton.action = .pause
                self.downloadButtonTitle = "Pause"
                HomeViewVM.sharedVM.resumeDownload()
            case .finished:
                self.downloadButton.action = .finished
                self.downloadButtonTitle = "Finished"
        }
    }
    
    @IBAction func didChangeSyncOrAsync(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                isSerial = true
            case 1:
                isSerial = false
            default:
                break
        }
    }
    
}

extension HomeViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionViewDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCollectionViewCell", for: indexPath) as! ImagesCollectionViewCell
        cell.configureCellWith(imageRecord: collectionViewDataSource[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let xPadding = 15
        let yPadding = 15
        let width = (Int(collectionView.bounds.size.width) - xPadding)/2
        let height = (Int(collectionView.bounds.size.height) - yPadding)/2
        
        return CGSize(width: width, height: height)
    }
    
}

extension HomeViewController : HomeViewVMDelegate {
    /// Reset the startDownloadButton title to "Finisj Download"  when all images downloaded Async  or Sync
    func didDownloadAllImages() {
        DispatchQueue.main.async {
            self.downloadButtonTitle = "Finished Download"
            self.downloadButton.action = .finished
            self.downloadButton.isEnabled = false
            self.syncAsyncSelector.isEnabled = false
        }
    }
    
    func reloadImageCV() {
        DispatchQueue.main.async {
            self.mainCollectionView.reloadData()
        }
    }
}
