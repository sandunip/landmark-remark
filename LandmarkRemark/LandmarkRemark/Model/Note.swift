//
//  Note.swift
//  LandmarkRemark
//
//  Created by Sanduni Perera on 20/2/22.
//  Copyright © 2022 Sanduni Perera. All rights reserved.
//

import Foundation

typealias Notes = [Note]

struct Note {
    var user: String
    var note: String
    var userLocation: UserLocation
}

struct UserLocation {
    var latitude: NSNumber
    var longitude: NSNumber
}
