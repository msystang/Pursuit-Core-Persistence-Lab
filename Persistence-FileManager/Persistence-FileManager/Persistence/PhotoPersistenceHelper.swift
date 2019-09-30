//
//  PhotoPersistenceHelper.swift
//  Persistence-FileManager
//
//  Created by Sunni Tang on 9/30/19.
//  Copyright © 2019 Sunni Tang. All rights reserved.
//

import Foundation

struct PhotoPersistenceHelper {
    static let manager = PhotoPersistenceHelper()

    func save(newPhoto: Photo) throws {
        try persistenceHelper.save(newElement: newPhoto)
    }

    func getPhotos() throws -> [Photo] {
        return try persistenceHelper.getObjects()
    }

    private let persistenceHelper = PersistenceHelper<Photo>(fileName: "photo.plist")

    private init() {}
}
