//
//  MapViewController.swift
//  GiftGift
//
//  Created by Caio Cesar on 26/05/19.
//  Copyright © 2019 FIAP. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class MapViewController: UIViewController {
    
    let lat: CLLocationDegrees = -23.520361
    let long: CLLocationDegrees = -46.680801

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    let collection = "presentes"
    var firestoreListener: ListenerRegistration!
    var firestore: Firestore = {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        var firestore = Firestore.firestore()
        firestore.settings = settings
        return firestore
    }()
    var gifts: [Gift] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.userTrackingMode = .follow
        
        requestAuthorization()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        listItems()
    }
    
    func listItems() {
        
        firestoreListener = firestore.collection(collection).order(by: "name", descending: false).addSnapshotListener(includeMetadataChanges: true){ (snapshot, error) in
            
            if error != nil {
                print(error!)
            }
            
            guard let snapshot = snapshot else {return}
            if snapshot.metadata.isFromCache || snapshot.documentChanges.count > 0 {
                self.showItems(snapshot: snapshot)
            }
            
        }
    }
    
    func showItems(snapshot: QuerySnapshot) {
        gifts.removeAll()
        for document in snapshot.documents {
            let data = document.data()
            if let name = data["name"] as? String,
                let place = data["place"] as? String,
                let value = data["value"] as? Float {
                let giftItem = Gift(id: document.documentID, name: name, place: place, value: value)
                gifts.append(giftItem)
                
                loadPOIs(text: giftItem.place ?? "")
                
            }
        }
        
    }
    
    func loadPOIs(text: String){
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = text
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if error == nil {
                guard let response = response else{return}

                for item in response.mapItems {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    annotation.subtitle = item.url?.absoluteString
                    self.mapView.addAnnotation(annotation)
                }
                self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            }
        }
    }
  
}

extension MapViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let annotation = view.annotation else {return}
        let coordinates = annotation.coordinate
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: mapView.userLocation.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinates))
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            
            guard let response = response, let route = response.routes.first else {return}
            
            mapView.addOverlay(route.polyline)
            mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            
        }
        
    }
    
    func requestAuthorization(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
}
