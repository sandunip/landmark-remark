//
//  AppConstants.swift
//  LandmarkRemark
//
//  Created by Sanduni Perera on 21/2/22.
//  Copyright © 2022 Sanduni Perera. All rights reserved.
//

import Foundation

class NavigationConstants {
    struct Segue {
        static let HOMESCREEN_SEGUE = "HomeScreenSegue"
    }
}

class DBConstants {
    struct Path {
        static let NotesTable = "UserNotes"
    }
    struct Field {
        static let UserName = "user"
        static let UserNote = "note"
        static let UserLocation = "userLocation"
        static let Latitude = "latitude"
        static let Longtitude = "longitude"
    }
}
