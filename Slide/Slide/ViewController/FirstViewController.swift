//
//  FirstViewController.swift
//  Slide
//
//  Created by JimFu on 2022/1/3.
//

import UIKit
import SnapKit

class FirstViewController: BaseViewController {
    
    var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("X", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        return button
    }()
    
    var dataSource: UICollectionViewDiffableDataSource<Int, Int>! = nil
    var collectionView: UICollectionView! = nil
    var animator: ImageAnimator?
    var selectedCell: ImageCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollection()
        configureDataSource()
        
        self.view.addSubview(button)
        button.snp.makeConstraints { make in
            make.top.leading.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.width.height.equalTo(30)
        }
    }
}

extension FirstViewController {
    func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.4))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func configureCollection() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    
    func configureDataSource() {
        let cellRegister = UICollectionView.CellRegistration<ImageCell, Int> { cell, indexPath, identifier in
            cell.image.image = UIImage(named: self.imageName[indexPath.row])
            cell.layer.borderWidth = 1.0
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, Int> (collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegister, for: indexPath, item: identifier)
        }
        
        var snapShot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapShot.appendSections([1])
        snapShot.appendItems(Array(1 ... imageName.count))
        dataSource.apply(snapShot)
    }
}

extension FirstViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectImage = imageName[indexPath.row]
        selectedCell = collectionView.cellForItem(at: indexPath) as? ImageCell
        guard let image = UIImage(named: selectImage) else { return }
        presentSecondImageVC(with: image)
    }
}

extension FirstViewController: UIViewControllerTransitioningDelegate {
    func presentSecondImageVC(with image: UIImage) {
        let secondViewController = SecondImageViewController()
        secondViewController.transitioningDelegate = self
        secondViewController.modalPresentationStyle = .fullScreen
        secondViewController.image.image = image
        self.present(secondViewController, animated: true, completion: nil)
    }
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let image = UIImage(named: selectImage),
              let cell = selectedCell,
              let destVC = presented as? SecondImageViewController else { return nil }
        animator = ImageAnimator(duration: 0.2, image: image, type: .present, originView: cell.image, destView: destVC.image)
        return animator
    }

    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let image = UIImage(named: selectImage),
              let cell = selectedCell,
              let secondImageVC = dismissed as? SecondImageViewController else { return nil }
        animator = ImageAnimator(duration: 0.2, image: image, type: .dismiss, originView: secondImageVC.image, destView: cell.image)
        return animator
    }
}
