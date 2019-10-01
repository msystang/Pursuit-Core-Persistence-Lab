//
//  FavoriteViewController.swift
//  Persistence-FileManager
//
//  Created by Sunni Tang on 9/30/19.
//  Copyright © 2019 Sunni Tang. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    var favorites = [Photo]() {
        didSet {
            favoritesCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    private func configureCollectionView() {
        favoritesCollectionView.delegate = self
        favoritesCollectionView.dataSource = self
    }
 
    private func loadData() {
        do {
            favorites = try PhotoPersistenceHelper.manager.getPhotos()
        } catch {
            print(error)
        }
    }
}

extension FavoriteViewController: UICollectionViewDelegateFlowLayout {}

extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let favoriteCell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCell", for: indexPath) as? FavoriteCollectionViewCell else {
            fatalError("no cell ID")
        }
        
        let favorite = favorites[indexPath.row]
        
        ImageHelper.manager.getImage(urlStr: favorite.imageURL) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let imageFromOnline):
                    favoriteCell.photoImage.image = imageFromOnline
                }
            }
        }
        return favoriteCell
    }
    
}
