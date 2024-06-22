//
//  RegisterUserModel.swift
//  Bullion Ecosystem
//
//  Created by Cyberindo Sinergi Sistem on 22/06/24.
//

import Foundation

struct RegisterUserModel: Decodable{
    let name: String
    let email: String
    
    init(name: String, email: String) {
        self.name = name
        self.email = email
    }
    
}
