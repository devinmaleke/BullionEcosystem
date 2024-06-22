//
//  UserDefaults.swift
//  Bullion Ecosystem
//
//  Created by Cyberindo Sinergi Sistem on 22/06/24.
//

import Foundation

class UserDefaultService{
    static let shared = UserDefaultService()
    
    private let tokenKey = "AuthToken"
    
    func getToken() -> String?{
        return UserDefaults.standard.string(forKey: tokenKey) ?? ""
    }
    
    func saveToken(_ token:String){
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    
    func deleteToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
}
