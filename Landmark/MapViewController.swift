//
//  MapViewController.swift
//  Landmark
//
//  Created by Ryan Zhou on 2/6/24.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var HUDContent: UILabel!
    @IBOutlet weak var HUD: UIView!
    @IBOutlet weak var HUDTitleLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var favoritePlaces: UIButton!
    
    var places = [Place]()
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        guard let placeName = HUDTitleLabel.text else { return }
        
        if sender.isSelected {
            DataManager.sharedInstance.deleteFavorite(place: placeName)
        } else {
            DataManager.sharedInstance.saveFavorites(place: placeName)
        }
        sender.isSelected.toggle()
    }
    
    @IBAction func favoritePlacesButtonTapped(_ sender: UIButton) {
        if let favoritesViewController = storyboard?.instantiateViewController(identifier: "FavoritesViewController") as? FavoritesViewController {
            favoritesViewController.delegate = self
            if let sheetController = favoritesViewController.sheetPresentationController {
                sheetController.detents = [.medium()]
            }
            present(favoritesViewController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
        
        loadPlacesFromPlist()
        
        for place in places {
            mapView.addAnnotation(place)
        }
        
        if let initialPlace = findPlaceByName("John Crerar Library") {
            let region = MKCoordinateRegion(center: initialPlace.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
            mapView.selectAnnotation(initialPlace, animated: true)
        }
        

        // Do any additional setup after loading the view.
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Place {
            let identifier = "Place"
            var view: PlaceMarkerView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? PlaceMarkerView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = PlaceMarkerView(annotation: annotation, reuseIdentifier: identifier)
            }
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let placeAnnotation = view.annotation as? Place {
            HUDTitleLabel.text = placeAnnotation.name
            HUDContent.text = placeAnnotation.longDescription
        }
    }
    
    func loadPlacesFromPlist() {
        if let path = Bundle.main.path(forResource: "Data", ofType: "plist"),
           let plistDict = NSDictionary(contentsOfFile: path) as? [String: Any],
           let dataArray = plistDict["places"] as? [[String: Any]] {
            for dict in dataArray {
                let place = Place()
                place.name = dict["name"] as? String
                place.longDescription = dict["description"] as? String
                if let latitude = dict["lat"] as? CLLocationDegrees,
                   let longitude = dict["long"] as? CLLocationDegrees {
                    place.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                }
                places.append(place)
            }
        }
    }
}

extension MapViewController: PlacesFavoritesDelegate {
    func favoritePlace(name: String){
        guard let place = findPlaceByName(name) else { return }
        let region = MKCoordinateRegion(center: place.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        
        HUDTitleLabel.text = place.name
        HUDContent.text = place.longDescription
        
        updateFavoriteButtonState(for: place)
    }
    
    func updateFavoriteButtonState(for place: Place) {
        let favorites = DataManager.sharedInstance.listFavorites()
        favoriteButton.isSelected = favorites.contains(place.name ?? "")
    }
    
    func findPlaceByName(_ name: String) -> Place? {
        return places.first { $0.name == name}
    }
}

