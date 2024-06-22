//
//  ViewController.swift
//  Bullion Ecosystem
//
//  Created by Cyberindo Sinergi Sistem on 21/06/24.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLogin()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkLogin()
    }
    
    private func checkLogin(){
        let token = UserDefaultService.shared.getToken()
        
        if token.isNilOrEmpty{
            navigationController?.pushViewController(LoginVC(), animated: false)
        } else {
            navigationController?.pushViewController(HomeVC(), animated: false)
        }
    }
}

