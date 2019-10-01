//
//  PhotoDetailViewController.swift
//  Persistence-FileManager
//
//  Created by Sunni Tang on 9/30/19.
//  Copyright © 2019 Sunni Tang. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {

    var photo: Photo!
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLabels()
        loadImage()
    }
    
    @IBAction func saveFavoriteButtonPressed(_ sender: UIButton) {
        do {
            try PhotoPersistenceHelper.manager.save(newPhoto: photo)
        } catch {
            print(error)
        }
    }
    
    
    func configureLabels() {
        idLabel.text = "\(photo.id)"
        tagLabel.text = photo.tags
    }
    
    func loadImage() {
        ImageHelper.manager.getImage(urlStr: photo.imageURL) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure (let error):
                    print(error)
                case .success (let imageFromOnline):
                    self.photoImage.image = imageFromOnline
                }
            }
        }
    }
    

}
