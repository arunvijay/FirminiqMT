//
//  HomeViewVM.swift
//  FirminiqMT
//
//  Created by Arun Vijay on 15/06/23.
//

import Foundation

class HomeViewVM {
    
    public static let sharedVM = HomeViewVM()
    private var imageURLs = [String]()
    
    func getImageURLs() -> [String] {
        imageURLs = DataProcessor.getImageURLs()
        return imageURLs
    }
    
    func getImageCount() -> Int {
        return imageURLs.count
    }
}
