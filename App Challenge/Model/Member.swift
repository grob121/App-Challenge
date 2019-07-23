//
//  Member.swift
//  App Challenge
//
//  Created by Allan Pagdanganan on 22/07/2019.
//  Copyright © 2019 Allan Pagdanganan. All rights reserved.
//

import Foundation
import CoreData

@objc(Member)
class Member: NSManagedObject, Codable {
    
    // MARK: - Coding Keys Enumeration
    enum CodingKeys: String, CodingKey {
        case loanReasons
        case requestedAmount
        case duration
        case email
        case password
        case firstName
        case lastName
        case title
        case dateOfBirth
        case mobileNumber
    }
    
    // MARK: - Core Data Managed Object
    @NSManaged var requestedAmount: String?
    @NSManaged var duration: String?
    @NSManaged var loanReasons: String?
    @NSManaged var email: String?
    @NSManaged var password: String?
    @NSManaged var title: String?
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var dateOfBirth: String?
    @NSManaged var mobileNumber: String?
    
    // MARK: - Decodable
    required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Member", in: managedObjectContext) else {
                fatalError("Failed to decode Member")
        }

        self.init(entity: entity, insertInto: managedObjectContext)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.requestedAmount = try container.decodeIfPresent(String.self, forKey: .requestedAmount)
        self.duration = try container.decodeIfPresent(String.self, forKey: .duration)
        self.loanReasons = try container.decodeIfPresent(String.self, forKey: .loanReasons)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.password = try container.decodeIfPresent(String.self, forKey: .password)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        self.dateOfBirth = try container.decodeIfPresent(String.self, forKey: .dateOfBirth)
        self.mobileNumber = try container.decodeIfPresent(String.self, forKey: .mobileNumber)
    }

    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(requestedAmount, forKey: .requestedAmount)
        try container.encode(duration, forKey: .duration)
        try container.encode(loanReasons, forKey: .loanReasons)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
        try container.encode(title, forKey: .title)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(dateOfBirth, forKey: .dateOfBirth)
        try container.encode(mobileNumber, forKey: .mobileNumber)
    }
}

extension CodingUserInfoKey {
    // Helper property to retrieve the context
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}
