//
//  MapViewController.swift
//  LandmarkRemark
//
//  Created by Sanduni Perera on 19/2/22.
//  Copyright © 2022 Sanduni Perera. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet var mapView : MKMapView!
    @IBOutlet var searchBar : UISearchBar!
    @IBOutlet var searchByUserImage : UIImageView!
    @IBOutlet var searchByNoteImage : UIImageView!
    var isSelectedUsernameSearch : Bool = true
    let minNumCharacters = 1
    let locationManager = CLLocationManager()
    lazy var viewModel = {
        NotesViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure location services
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        if let coordinates = mapView.userLocation.location?.coordinate{
            mapView.setCenter(coordinates, animated: true)
        }
        
        viewModel.delegate = self
        viewModel.fetchUserNotes()
    }
    
    func createAnnotations(notes : Notes) {
        // Delete existing annotations
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        //Create annotations
        DispatchQueue.main.async {
            for note in notes {
                let pin = MKPointAnnotation()
                pin.title = note.user
                pin.subtitle = note.note
                let longitude = CLLocationDegrees(truncating: note.userLocation.longitude)
                let latitude = CLLocationDegrees(truncating: note.userLocation.latitude)
                pin.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: CLLocationDegrees(longitude))
                self.mapView.addAnnotation(pin)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        mapView.mapType = MKMapType.standard
        
        let span = MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    //MARK: Button click actions
    @IBAction func onClickAddNote(sender : AnyObject){
        let alertController = UIAlertController(title: "Add notes here", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let textField = alertController.textFields![0] as UITextField
            if (textField.text?.count)! > self.minNumCharacters {
                self.viewModel.addNote(text: textField.text!, locationManager: self.locationManager)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
            textField.placeholder = "Search"
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func onClickSearchbyUsername(sender : AnyObject){
        isSelectedUsernameSearch = true
        searchByUserImage.image = UIImage(named: "Checked")
        searchByNoteImage.image = UIImage(named: "Unchecked")
    }
    
    @IBAction func onClickSearchbyNote(sender : AnyObject){
        isSelectedUsernameSearch = false
        searchByNoteImage.image = UIImage(named: "Checked")
        searchByUserImage.image = UIImage(named: "Unchecked")
    }
}

extension MapViewController : NotesViewModelDelegate {
    func updateList(_ notes: [Note]) {
        createAnnotations(notes: notes)
    }
}

extension MapViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text?.count)! > minNumCharacters {
            viewModel.searchNotes(searchText: searchBar.text!, isSelectedUsernameSearch: isSelectedUsernameSearch)
            self.searchBar.endEditing(true)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" || searchText.isEmpty {
            self.searchBar.endEditing(true)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        self.searchBar.endEditing(true)
        self.viewModel.fetchUserNotes()
    }
}
