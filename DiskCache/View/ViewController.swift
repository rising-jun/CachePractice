//
//  ViewController.swift
//  DiskCache
//
//  Created by 김동준 on 2022/07/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var doodleCount = 0
    private var doodleImageData: [Data] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "ImageCell", bundle: .main), forCellWithReuseIdentifier: "ImageCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let usecase = DoodleUsecase()
        usecase.updateImageData = updateImage
        usecase.requestDoodleJson()
        
    }
    
    private lazy var updateImage: ((Data) -> ()) = { [weak self] imageData in
        guard let self = self else { return }
        DispatchQueue.main.async {
            self.doodleImageData.append(imageData)
            self.collectionView.insertItems(at: [IndexPath(item: self.doodleImageData.count - 1, section: 0)])
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        doodleImageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell else { return UICollectionViewCell() }
        let imageData = doodleImageData[indexPath.item]
        cell.imageView.image = UIImage(data: imageData)
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 90
        let size = CGSize(width: width, height: width)
        return size
    }
}
