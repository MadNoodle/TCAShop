//
//  Prfile.swift
//  TCAPedro
//
//  Created by User on 14.11.2023.
//

import Foundation

struct Profile: Decodable, Equatable {
    let id: Int
    let email: String
    let firstname: String
    let lastname: String
}

extension Profile {
    private enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case firstname
        case lastname
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.email = try container.decode(String.self, forKey: .email)
        
        let nameContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .name)
        self.firstname = try nameContainer.decode(String.self, forKey: .firstname)
        self.lastname = try nameContainer.decode(String.self, forKey: .lastname)
    }
}


extension Profile {
    static var sample: Profile {
        .init(
            id: 1,
            email: "hello@demo.com",
            firstname: "Mathieu",
            lastname: "Janneau"
        )
    }
    
    static var `default`: Profile {
        .init(
            id: 0,
            email: "",
            firstname: "",
            lastname: ""
        )
    }
}
