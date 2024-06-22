//
//  UserDetailVC.swift
//  Bullion Ecosystem
//
//  Created by Cyberindo Sinergi Sistem on 21/06/24.
//

import UIKit

class UserDetailVC: UIViewController {
    
    @IBOutlet weak var dismissView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    
    @IBOutlet weak var dobLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var editUserButton: UIButton!
    
    private lazy var viewModel = UserDetailVM()
    var userID: String?
    var user: UserDetailModel?
    var completion: (() -> Void)?
    
    init(userID: String) {
        self.userID = userID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getUserDetail()
    }
    
    
    @IBAction func didTapButton(_ sender: UIButton) {
        if sender == closeButton{
            self.dismiss(animated: true, completion: nil)
            self.completion?()
        }else{
            guard let user = user else {
                return
            }
            let vc = EditUserVC(data: user)
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.completion = { [weak self] in
                self?.getUserDetail()
            }
            present(vc, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        bgView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 24)
    }
    
    private func setupUI(){
        editUserButton.layer.cornerRadius = 20
        editUserButton.layer.masksToBounds = true
        dismissView.backgroundColor = .black.withAlphaComponent(0.5)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewDismiss))
        dismissView.addGestureRecognizer(tapGesture)
        profilePicture.layer.cornerRadius = profilePicture.frame.width / 2
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(didTapProfileImage(tap:)))
        profilePicture.isUserInteractionEnabled = true
        profilePicture.addGestureRecognizer(tapImage)
    }
    
    @objc func viewDismiss() {
        dismiss(animated: true)
        self.completion?()
    }
    
    @objc private func didTapProfileImage(tap: UITapGestureRecognizer){
        let tappedImage = tap.view as! UIImageView
        guard
            let image = tappedImage.image
        else {return}
        
        let vc = TapImageVC(image: image)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true)
    }
    
    private func getUserDetail(){
        guard let userID = userID else{
            showToast(message: "Failed to get user")
            return
        }
        showLoading(true)
        viewModel.getUserDetail(id: userID)
        { [weak self] message, success, data in
            guard let self = self else {return}
            showLoading(false)
            if success {
                nameLabel.text = "\(data?.first_name ?? "") \(data?.last_name ?? "")"
                emailLabel.text = data?.email
                genderLabel.text = data?.gender.uppercased()
                phoneNumberLabel.text = data?.phone
                dobLabel.text = data?.date_of_birth.toFormattedDate(format: "dd MMM YYYY")
                addressLabel.text = data?.address
                profilePicture.image = Functions.convertUTF64ToImage(stringIMG: data?.photo ?? "")
                user = data
            }else{
                showToast(message: message ?? "unkown error")
            }
           
        }
    }
    
    
}
