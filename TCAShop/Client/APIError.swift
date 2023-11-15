//
//  APIError.swift
//  TCAPedro
//
//  Created by User on 14.11.2023.
//

import Foundation

enum APIError: Error {
    case failedPayment
    
    var description: String {
        switch self {
        case .failedPayment:
            "the payment has failed"
        }
    }
}
