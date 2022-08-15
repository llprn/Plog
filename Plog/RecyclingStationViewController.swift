//
//  RecyclingStationViewController.swift
//  Plog
//
//  Created by HR on 2022/08/08.
//

import UIKit
import MapKit
import CoreLocation

class RecyclingStationViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate {

    @IBOutlet var myMap2: MKMapView!
    @IBAction func backToCurrentLocBtn(_ sender: Any) {
        myMap2.setUserTrackingMode(.follow, animated: true)
    }
    
    @IBAction func addRecyclingStationBtn(_ sender: Any) {
            _ = navigationController?.popViewController(animated: true)
        }
        
        
        let locationManager = CLLocationManager()
        var oLongTapGesture = UILongPressGestureRecognizer()
    
        @objc func handleLongtapGesture(gestureRecognizer: UILongPressGestureRecognizer) {
            
            if gestureRecognizer.state != UIGestureRecognizer.State.ended {
                myMap2.removeAnnotations(myMap2.annotations)
                
                let touchLocation = gestureRecognizer.location(in: myMap2)
                let locationCoordinate = myMap2.convert(touchLocation, toCoordinateFrom: myMap2)
                
                print("Tapped at Latitude: \(locationCoordinate.latitude), Longitude:\(locationCoordinate.longitude)")
                
                let myPin = MKPointAnnotation()
                myPin.coordinate = locationCoordinate
//                myPin.title = "Latitude: \(locationCoordinate.latitude), Longitude: \(locationCoordinate.longitude)"
                myMap2.addAnnotation(myPin)
            }
            //
            if gestureRecognizer.state != UIGestureRecognizer.State.began {
                return
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
                
                // 정확도를 최고로 설정
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                // 위치 데이터를 추적하기 위해 사용자에게 승인 요구
                locationManager.requestWhenInUseAuthorization()
                // 위치 업데이트를 시작
                locationManager.startUpdatingLocation()
                // 위치 보기 설정
                myMap2.showsUserLocation = true
                // 현재 내 위치 기준으로 지도를 움직임
                myMap2.setUserTrackingMode(.follow, animated: true)
                
                
                oLongTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(RecyclingStationViewController.handleLongtapGesture(gestureRecognizer:)))
                self.myMap2.addGestureRecognizer(oLongTapGesture)
        }
}


// custom pin annotation
extension RecyclingStationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        guard !(annotation is MKUserLocation) else {
            return nil
        }
        var annotationView = myMap2.dequeueReusableAnnotationView(withIdentifier: "custom")
        
        if annotationView == nil {
            //Create new view
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            annotationView?.canShowCallout = false
        }
        else {
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: "recycle-bin")
        
        return annotationView
    }
}
