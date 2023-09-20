//
//  MapViewController.swift
//  Airbnb
//
//  Created by Altan on 18.09.2023.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        view.addSubview(mapView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mapView.frame = view.bounds
    }


}
