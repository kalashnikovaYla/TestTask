//
//  GridViewController.swift
//  TestTask
//
//  Created by sss on 12.05.2023.
//

import UIKit


final class GridViewController: UIViewController {

    //MARK: - Properties
    
    var data: [URL]?
    var networkManager = NetworkManager()
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let row = 3
        let width = (Int(view.bounds.width) - 4 * (row + 1)) / row
        
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumInteritemSpacing = 4
        layout.sectionInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.self,
                                    forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = "https://it-link.ru/test/images.txt"
        
        networkManager.loadDataFromTextFile(string: url) { [weak self] array in
            DispatchQueue.main.async {
                self?.data = array
                self?.collectionView.reloadData()
            }
        }
        
        view.backgroundColor = UIColor.systemBackground

        settingsCollectionView()
    }
    
    
    
    //MARK: - Method
    
    private func settingsCollectionView() {
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
        collectionView.backgroundColor = UIColor.systemBackground
    }

}


//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension GridViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let url = data?[indexPath.row] {
            networkManager.loadImage(with: url) { image in
                DispatchQueue.main.async {
                    cell.photoImageView.image = image
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let url = data?[indexPath.row] else {return}
        let detailVC = DetailViewController(url: url)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
