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
    
    var downloadButtonTitle : String = "Start" {
        didSet {
            self.downloadButton.setTitle(downloadButtonTitle, for: .normal)
        }
    }
    
    var collectionViewDataSource = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        downloadButton.action = .start
        downloadButtonTitle = "Start"
        
        collectionViewDataSource = HomeViewVM.sharedVM.getImageURLs()
    }

    @IBAction func downloadButtonAction(_ sender: Any) {
        switch downloadButton.action {
            case .start:
                self.downloadButton.action = .pause
                self.downloadButtonTitle = "Pause"
            case .pause:
                self.downloadButton.action = .resume
                self.downloadButtonTitle = "Resume"
            case .resume:
                self.downloadButton.action = .pause
                self.downloadButtonTitle = "Pause"
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
        cell.configureCellWithImage(url: collectionViewDataSource[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.size.width/2.09
        let height = collectionView.bounds.size.height/2.09
        
        return CGSize(width: width, height: height)
    }
    
}
