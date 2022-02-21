//
//  NotesViewModel.swift
//  LandmarkRemark
//
//  Created by Sanduni Perera on 21/2/22.
//  Copyright © 2022 Sanduni Perera. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation
import FirebaseDatabase

protocol NotesViewModelDelegate: class {
    func updateList(_ notes : [Note])
}

class NotesViewModel {
    var delegate : NotesViewModelDelegate?
    
    private let databaseRef = Database.database().reference(withPath : DBConstants.Path.NotesTable)
    
    func addNote(text : String, locationManager : CLLocationManager) {
        let incrementedNumber = Int.random(in: 0 ... 100)
        let userName = UserDefaultsManager.getUserName()
        let location = [DBConstants.Field.Latitude: locationManager.location!.coordinate.latitude, DBConstants.Field.Longtitude: locationManager.location!.coordinate.longitude]
        let entry : [String : Any]  =  [
            DBConstants.Field.UserLocation : location,
            DBConstants.Field.UserNote : text,
            DBConstants.Field.UserName : userName
        ]
        databaseRef.child(String(incrementedNumber)).setValue(entry)
        fetchUserNotes()
    }
    
    func searchNotes(searchText : String, isSelectedUsernameSearch:Bool) {
        var searchField = DBConstants.Field.UserName
        if !isSelectedUsernameSearch {
            searchField = DBConstants.Field.UserNote
        }
        let ref = databaseRef.queryOrdered(byChild: searchField).queryEqual(toValue: searchText)
        ref.observe(.value, with:{ (snapshot: DataSnapshot) in
            print(snapshot)
            self.delegate?.updateList(self.decodeData(snapshot: snapshot))
        })
    }
    
    func fetchUserNotes() {
        databaseRef.observeSingleEvent(of: .value, with: { snapshot in
            self.delegate?.updateList(self.decodeData(snapshot: snapshot))
        })
    }
    
    func decodeData(snapshot : DataSnapshot) -> Notes{
        var notesArray = [Note]()
        for entry in snapshot.children.allObjects as! [DataSnapshot] {
            guard let object = entry.value as? [String: Any] else { continue }
            let userName = object[DBConstants.Field.UserName] as! String
            let note = object[DBConstants.Field.UserNote] as! String
            let userLocation = object[DBConstants.Field.UserLocation] as! [String : NSNumber]
            let latitude = userLocation[DBConstants.Field.Latitude]
            let longitude = userLocation[DBConstants.Field.Longtitude]
            let location = UserLocation(latitude: latitude!, longitude: longitude!)
            let noteObj = Note(user: userName, note: note, userLocation: location)
            notesArray.append(noteObj)
        }
        return notesArray
    }
}


