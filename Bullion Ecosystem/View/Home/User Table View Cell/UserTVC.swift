//
//  UserTVC.swift
//  Bullion Ecosystem
//
//  Created by Cyberindo Sinergi Sistem on 21/06/24.
//

import UIKit

class UserTVC: UITableViewCell {
    
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 8
        bgView.shadowUIView(offset: CGSize(width: 0, height: 2), opacity: 0.15, radius: 2)
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
    }
    
    func setup(data: UserModel){
        nameLabel.text = data.name
        emailLabel.text = data.email
        profileImage.image = Functions.convertUTF64ToImage(stringIMG: data.photo)
        dateLabel.text = data.date_of_birth.toFormattedDate(format: "MMM dd, YYYY")
    }
    
}
