//
//  ViewController.swift
//  Persistence-FileManager
//
//  Created by Sunni Tang on 9/30/19.
//  Copyright © 2019 Sunni Tang. All rights reserved.
//

import UIKit

class PhotoListViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    var photos = [Photo]() {
        didSet {
            photoCollectionView.reloadData()
        }
    }
    
    var searchString: String? = nil {
        didSet {
            photoCollectionView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedIndex = photoCollectionView.indexPath(for: sender as! UICollectionViewCell) else { print("no index selected")
            return }
        guard segue.identifier == "photoToDetailSegue" else { print("no ID'd segue")
            return }
        guard let photoDetailVC = segue.destination as? PhotoDetailViewController else {
            print("no destination VC")
            return }

        photoDetailVC.photo
         = photos[selectedIndex.row]
        
    }
    
    private func configureCollectionView() {
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
    }
    
    private func configureSearchBar() {
        searchBar.delegate = self
    }
    
    private func loadData() {
        if let searchString = searchString {
            let urlStr = PhotoAPIClient.getSearchResultsURLStr(from: searchString)
            print(urlStr)
            
            PhotoAPIClient.manager.getPhotos(urlStr: urlStr) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let dataFromOnline):
                        self.photos = dataFromOnline
                    }
                }
            }
        }
    }
}

extension PhotoListViewController: UICollectionViewDelegateFlowLayout {
}

extension PhotoListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCollectionViewCell else {
            fatalError("no cell ID")
        }
        
        let photo = photos[indexPath.row]
              
        ImageHelper.manager.getImage(urlStr: photo.imageURL) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let imageFromOnline):
                    photoCell.photoImage.image = imageFromOnline
                }
            }
        }
        
        return photoCell
    }
}

extension PhotoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchString = searchText
        loadData()
    }
}
