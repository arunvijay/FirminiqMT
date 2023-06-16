//
//  ImagesModel.swift
//  FirminiqMT
//
//  Created by Arun Vijay on 15/06/23.
//

import Foundation
import UIKit

// MARK: - Images Model

struct Images: Codable {
    let images: [String]
}

class ImageRecord {
    var imageUrl: String
    var hasImageDwonloaded: Bool = false
    var imageValue: UIImage?
    var progressValue: Float = 0.0
    
    init(imageUrl: String){
        self.imageUrl = imageUrl
    }
}
