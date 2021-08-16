//
//  LocationPickerViewController.swift
//  iMessenger
//
//  Created by Charlie Nguyen on 16/08/2021.
//

import UIKit
import CoreLocation
import MapKit

class LocationPickerViewController: UIViewController {
    
    public var completion: ((CLLocationCoordinate2D) -> Void)?
    private var coordinates: CLLocationCoordinate2D?
    private var isPickable = true
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        return mapView
    }()
    
    init(coordinates: CLLocationCoordinate2D?) {
        self.coordinates = coordinates
        self.isPickable = false
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        if isPickable {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(sendButtonTapped))
            
            mapView.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self,
                                                 action: #selector(didTapMap(_:)))
            gesture.numberOfTouchesRequired = 1
            gesture.numberOfTapsRequired = 1
            mapView.addGestureRecognizer(gesture)
        }
        else {
            // Just showing location
            guard let coordinates = self.coordinates else {
                return
            }
            // Drop a pin on that location
            let pin = MKPointAnnotation()
            pin.coordinate = coordinates
            mapView.addAnnotation(pin)
        }
        
        view.addSubview(mapView)
        
    }
    
    override func viewDidLayoutSubviews() {
        mapView.frame = view.bounds
    }
    
    @objc private func sendButtonTapped() {
        guard let coordinates = coordinates else {
            return
        }
        navigationController?.popViewController(animated: true)
        completion?(coordinates)
    }
    
    @objc private func didTapMap(_ gesture: UITapGestureRecognizer) {
        let locationInView = gesture.location(in: mapView)
        let coordinates = mapView.convert(locationInView, toCoordinateFrom: mapView)
        self.coordinates = coordinates
        
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
        }
        
        // Drop a pin on that location
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        
        mapView.addAnnotation(pin)
    }
}
