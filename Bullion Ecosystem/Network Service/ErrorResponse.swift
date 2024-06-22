//
//  ErrorResponse.swift
//  Bullion Ecosystem
//
//  Created by Cyberindo Sinergi Sistem on 22/06/24.
//

import Foundation

struct ErrorResponse: Codable, LocalizedError {
    let err_code: String
    let err_message: String
    let err_message_en: String
}
