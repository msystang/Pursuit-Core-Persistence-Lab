//
//  PhotoAPIClient.swift
//  Persistence-FileManager
//
//  Created by Sunni Tang on 9/30/19.
//  Copyright © 2019 Sunni Tang. All rights reserved.
//

import Foundation

struct PhotoAPIClient {
    
    // MARK: - Static Properties
    
    static let manager = PhotoAPIClient()
    
    // MARK: - Instance Methods
    

    
    static func getSearchResultsURLStr(from searchString: String) -> String {
        return "....\(searchString)"
    }
    
    func getPhotos(urlStr: String, completionHandler: @escaping (Result<[Photo], AppError>) -> ())  {
        
        guard let url = URL(string: urlStr) else {
            print(AppError.notAnImage)
            return
        }
        
        NetworkHelper.manager.performDataTask(withUrl: url, andMethod: .get) { (results) in
            switch results {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                do {
                    let photoInfo = try Photo.decodePhotosFromData(from: data)
                    completionHandler(.success(photoInfo))
                }
                catch {
                    completionHandler(.failure(.couldNotParseJSON(rawError: error)))
                }
                
            }
        }
    }
    
    
    // MARK: - Private Properties and Initializers
    
    private init() {}
}
