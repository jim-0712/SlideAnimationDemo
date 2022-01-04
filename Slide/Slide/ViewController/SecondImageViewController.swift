//
//  SecondImageViewController.swift
//  Slide
//
//  Created by JimFu on 2022/1/4.
//

import UIKit
import SnapKit

class SecondImageViewController: BaseViewController {
    
    var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        configureImage()
        self.view.backgroundColor = .white
    }
    
    private func configureImage() {
        self.view.addSubview(image)
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            image.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            image.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        self.view.addSubview(button)
        button.snp.makeConstraints { make in
            make.top.leading.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.width.height.equalTo(30)
        }
    }
}
