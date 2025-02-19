//
//  Person.swift
//  People
//
//  Created by Melnik Sergey on 22/06/2024.
//

import Foundation
import SwiftData

@Model
class Person {
    var name: String = ""
    var emailAddress: String = ""
    var phone: String = ""
    var details: String = ""
    var countOpened: Int = 0
    @Attribute(.externalStorage) var photo: Data?

    init(name: String, emailAddress: String, phone: String, details: String, countOpened: Int = 0) {
        self.name = name
        self.emailAddress = emailAddress
        self.phone = phone
        self.details = details
        self.countOpened = countOpened
    }
}
