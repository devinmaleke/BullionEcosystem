//
//  TapImageVC.swift
//  Bullion Ecosystem
//
//  Created by Cyberindo Sinergi Sistem on 22/06/24.
//

import UIKit

class TapImageVC: UIViewController {

    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet var mainView: UIView!
    
    private var image: UIImage?
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTappedDismiss(tapGestureRecognizer:)))
        previewImage.isUserInteractionEnabled = true
        previewImage.addGestureRecognizer(tapGestureRecognizer)
        mainView.isUserInteractionEnabled = true
        mainView.addGestureRecognizer(tapGestureRecognizer)
        previewImage.image = image
    }
    
    @objc func imageTappedDismiss(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.dismiss(animated: false)
    }
}
