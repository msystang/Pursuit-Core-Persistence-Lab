//
//  ImageHelper.swift
//  Persistence-FileManager
//
//  Created by Sunni Tang on 9/30/19.
//  Copyright © 2019 Sunni Tang. All rights reserved.
//

import UIKit

class ImageHelper {
    
    // MARK: - Static Properties
    static let manager = ImageHelper()
    
    // MARK: - Instance Methods
    func getImage(urlStr: String, completionHandler: @escaping (Result<UIImage, AppError>) -> ()) {
        
        guard let url = URL(string: urlStr) else {
            completionHandler(.failure(.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard error == nil else {
                completionHandler(.failure(.badURL))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.noDataReceived))
                return
            }
            
            guard let image = UIImage(data: data) else {
                completionHandler(.failure(.notAnImage))
                return
            }
            
            completionHandler(.success(image))
            } .resume()
    }
    
    // MARK: - Private Properties and Initializers
    private init() {}
}

