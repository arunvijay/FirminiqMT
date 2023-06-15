//
//  DataProcessor.swift
//  FirminiqMT
//
//  Created by Arun Vijay on 15/06/23.
//

import Foundation

class DataProcessor {
    
    public static let shared = DataProcessor()
    
    private static func getImageURLsFrom(File fileName: String) -> Images? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(Images.self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
    static func getImageURLs() -> [String] {
        let images = getImageURLsFrom(File: "Images")
        return images?.images ?? [String]()
    }
}
