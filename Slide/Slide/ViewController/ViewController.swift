//
//  ViewController.swift
//  Slide
//
//  Created by JimFu on 2022/1/3.
//

import UIKit


class ViewController: UIViewController {
    
    class ListItem: Hashable {
        private let identifier = UUID()
        let title: String
        let imagename: [String]
        let controller: UIViewController.Type?
        
        init(title: String, imagename: [String] = [], vc: UIViewController.Type? = nil) {
            self.title = title
            self.imagename = imagename
            self.controller = vc
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
        
        static func == (lhs: ViewController.ListItem, rhs: ViewController.ListItem) -> Bool {
            return lhs.identifier == rhs.identifier
        }
    }
    
    private let lists: [ListItem] = [ListItem(title: "FullImage", imagename: ["cat", "tiger", "panda"], vc: FirstViewController.self)]
    private var dataSource: UICollectionViewDiffableDataSource<Int, ListItem>! = nil
    private var collectionViews: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "Main"
        configureCollectionView()
        configureDataSource()
    }
}

extension ViewController {
    func configureCollectionView() {
        collectionViews = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        collectionViews.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionViews)
        collectionViews.delegate = self
    }
    
    
    func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let items = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.2))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [items])
        
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func configureDataSource() {
        
        let cellRegister = UICollectionView.CellRegistration<TextCell, String> { cell, indexPath, itemIdentifier in
            cell.label.text = itemIdentifier
            cell.contentView.backgroundColor = .lightGray
            cell.layer.borderWidth = 1.0
        }
            
        dataSource = UICollectionViewDiffableDataSource<Int, ListItem>(collectionView: collectionViews) { (collectionView: UICollectionView, indexPath: IndexPath, identifier: ListItem) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegister, for: indexPath, item: identifier.title)
        }
        
        var snapShot = NSDiffableDataSourceSnapshot<Int, ListItem>()
        snapShot.appendSections([1])
        snapShot.appendItems(lists)
        dataSource.apply(snapShot)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let listItem = dataSource.itemIdentifier(for: indexPath),
              let viewcontroller = listItem.controller,
              let base = viewcontroller.init() as? BaseViewController else { return }
        base.imageName = listItem.imagename
        base.modalPresentationStyle = .fullScreen
        self.present(base, animated: true, completion: nil)
    }
}
