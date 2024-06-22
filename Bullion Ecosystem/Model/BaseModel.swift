//
//  BaseModel.swift
//  Bullion Ecosystem
//
//  Created by Cyberindo Sinergi Sistem on 22/06/24.
//

import Foundation

struct BaseModel<T:Decodable>: Decodable{
    let status: Int
    let iserror: Bool
    let message: String
    let data: T?
    
    init(status: Int, iserror: Bool, message: String, data: T?) {
        self.status = status
        self.iserror = iserror
        self.message = message
        self.data = data
    }
}
