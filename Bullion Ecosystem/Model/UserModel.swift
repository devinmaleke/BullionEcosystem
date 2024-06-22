//
//  UserModel.swift
//  Bullion Ecosystem
//
//  Created by Cyberindo Sinergi Sistem on 22/06/24.
//

import Foundation

struct UserModel: Decodable{
    let _id: String
    let name: String
    let gender: String
    let date_of_birth: String
    let email: String
    let photo: String
    let phone: String
    let address: String
    
    init(_id: String, name: String, gender: String, date_of_birth: String, email: String, photo: String, phone: String, address: String) {
        self._id = _id
        self.name = name
        self.gender = gender
        self.date_of_birth = date_of_birth
        self.email = email
        self.photo = photo
        self.phone = phone
        self.address = address
    }
}
