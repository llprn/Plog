//  ViewController.swift


import UIKit
import CoreLocation
import MapKit //지도
import SwiftUI

import KakaoSDKAuth
import KakaoSDKUser

import FirebaseFirestore

class ViewController: UIViewController {
 //   var locationManager = CLLocationManager()
    var locationManager: CLLocationManager!
    var currentLocation: String?
    let db = Firestore.firestore()
   
    @IBOutlet var myMap: MKMapView!
    
    @IBAction func logout(_ sender: Any) {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("로그아웃 성공")
                let newVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                newVC.modalPresentationStyle = .fullScreen // 전체화면으로 보이게
                newVC.modalTransitionStyle = .crossDissolve // 전환 애니메이션 설정
                self.present(newVC, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myMap.delegate = self
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //
        switch locationManager.authorizationStatus{
            case .denied:
            print("위치 비허용")
        case .notDetermined, .restricted:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
        
    /*    locationManager = CLLocationManager()
        locationManager.delegate = self
        switch locationManager.authorizationStatus {
        case .denied:
            print("위치 비허용 상태")
        case .notDetermined, .restricted:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        db.collection("startAndEndPoints").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print(err)
            } else {
                for document in querySnapshot!.documents {
                    // 시작 지점
                    let startPoint = document.data() ["startPoint"] as! GeoPoint
                    print(startPoint)
                    let startAnnotation = MKPointAnnotation()
                    startAnnotation.coordinate = CLLocationCoordinate2DMake(startPoint.latitude, startPoint.longitude)
                    self.myMap.addAnnotation(startAnnotation)
                    
                    // 종료 지점
                    let endPoint = document.data() ["endPoint"] as! GeoPoint
                    print(endPoint)
                    print("==============")
                    let endAnnotation = MKPointAnnotation()
                    endAnnotation.coordinate = CLLocationCoordinate2DMake(endPoint.latitude, endPoint.longitude)
                    self.myMap.addAnnotation(endAnnotation)
                }
            }
        }
    }
    
}

//주석처리
class LocationService {
    static var shared = LocationService()
    var longitude: Double!
    var latitude: Double!

}
//
extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        if let location = locations.first {
            print("위치 업데이트!")
            print("위도 : \(location.coordinate.latitude)")
            print("경도 : \(location.coordinate.longitude)")
        }
    }
        
    // 위치 가져오기 실패
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
    }

 /*   func locationManager(_ manager: CLLocationManager, didUpdatedLocations locations: [CLLocation]){
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        currentLocation = "\(locValue.latitude),\(locValue.longitude)"
        testt.text = currentLocation

    }*/

    private func setWeather(){
        let url = URL(string: "https://openweathermap.org/img/wn/\(self.weather?.icon ?? "00")@2x.png")
        let data = try? Data(contentsOf: url!)
            if let data = data {
               weatherImg.image = UIImage(data: data)
           }
        weatherDescription.text = weather?.description
        location.text = name
        currentTemp.text = "\(Int(main!.temp-273))"
        maxTemp.text = "\(Int(main!.temp_max-273))"
        minTemp.text = "\(Int(main!.temp_min-273))"
    }
    
    
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        
        // resize image
        let pinImage = UIImage(named: "sprout.png")
        let size = CGSize(width: 25, height: 25)
        UIGraphicsBeginImageContext(size)
        pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()

        annotationView!.image = resizedImage
       
        return annotationView
    }
}

/*class LocationService {
    static var shared = LocationService()
    var longitude:Double!
    var latitude:Double!
}
*/
