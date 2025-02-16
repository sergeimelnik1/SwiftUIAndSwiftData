//
//  Event.swift
//  People
//
//  Created by Melnik Sergey on 22/06/2024.
//

import Foundation
import SwiftData

@Model
class Event {
    var name: String = ""
    var location: String = ""
    var people: [Person]? = [Person]()

    init(name: String, location: String) {
        self.name = name
        self.location = location
    }
}
