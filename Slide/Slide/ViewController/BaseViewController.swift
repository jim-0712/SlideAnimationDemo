//
//  BaseViewController.swift
//  Slide
//
//  Created by JimFu on 2022/1/3.
//

import UIKit

class BaseViewController: UIViewController {
    
    var imageName: [String] = []
    var selectImage: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
}
