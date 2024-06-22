//
//  LoginModel.swift
//  Bullion Ecosystem
//
//  Created by Cyberindo Sinergi Sistem on 22/06/24.
//

import Foundation

struct LoginModel: Decodable{
    let name: String
    let email: String
    let token: String
    
    init(name: String, email: String, token: String) {
        self.name = name
        self.email = email
        self.token = token
    }
}
