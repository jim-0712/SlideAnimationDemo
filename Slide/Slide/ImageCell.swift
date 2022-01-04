//
//  ImageCell.swift
//  Slide
//
//  Created by JimFu on 2022/1/3.
//

import UIKit

class ImageCell: UICollectionViewCell {
    var image = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
}

extension ImageCell {
    func configure() {
        image.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(image)
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
