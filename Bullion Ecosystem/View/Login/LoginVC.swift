//
//  LoginVC.swift
//  Bullion Ecosystem
//
//  Created by Cyberindo Sinergi Sistem on 21/06/24.
//

import UIKit
import CryptoKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var botView: UIView!
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var addNewUserButton: UIButton!
    
    @IBOutlet weak var revealButton: UIButton!
    private lazy var viewModel = LoginVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    
    @IBAction func didTapButton(_ sender: UIButton) {
        if sender == signInButton{
            prosesLogin()
        }else if sender == addNewUserButton{
            let vc = RegistrationVC()
            navigationController?.pushViewController(vc, animated: true)
        }else{
            Functions.securedField(textField: passwordTF, sender: sender)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        botView.roundCorners(corners: [.topLeft, .topRight], radius: 24)
    }
    
    private func setupUI(){
        topView.setGradientBackground(colorOne: UIColor.init(hex: "F05A2A"), colorTwo: UIColor.init(hex: "F89576"))
        emailTF.layer.cornerRadius = 20
        emailTF.layer.borderWidth = 1
        emailTF.layer.borderColor = UIColor.init(hex: "D1D1D6").cgColor
        emailTF.layer.masksToBounds = true
        
        passwordTF.layer.cornerRadius = 20
        passwordTF.layer.borderWidth = 1
        passwordTF.layer.borderColor = UIColor.init(hex: "D1D1D6").cgColor
        passwordTF.layer.masksToBounds = true
        
        signInButton.layer.cornerRadius = 20
        addNewUserButton.layer.cornerRadius = 20
        signInButton.layer.masksToBounds = true
        addNewUserButton.layer.masksToBounds = true
    }
    
    private func prosesLogin(){
        
        guard
            let email = emailTF.text,
            email.isValidEmail()
        else {
            showToast(message: "Input valid email")
            return
        }
        
        guard
            !passwordTF.text.isNilOrEmpty,
            let password = passwordTF.text
        else {
            showToast(message: "Password required")
            return
        }
        
        let inputData = password.data(using: .utf8)!
        let hashString = Functions.hash(data: inputData)
        
        showLoading(true)
        viewModel.signInUser(email: email, password: hashString){ [weak self] message, success in
            guard let self = self else {return}
            showLoading(false)
            if success{
                print("Bearer " + (UserDefaultService.shared.getToken() ?? ""))
                let vc = HomeVC()
                navigationController?.pushViewController(vc, animated: true)
            } else{
                showToast(message: message ?? "unkown error")
            }
        }
        
        
    }
    

}
