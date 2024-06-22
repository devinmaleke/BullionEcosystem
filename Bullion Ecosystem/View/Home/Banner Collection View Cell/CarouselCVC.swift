//
//  CarouselCVC.swift
//  Bullion Ecosystem
//
//  Created by Cyberindo Sinergi Sistem on 21/06/24.
//

import UIKit

class CarouselCVC: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 8
    }
    
    
    func setup(data: String){
        imageView.image = UIImage(named: data)
    }
    

}
