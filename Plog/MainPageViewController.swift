//
//  MainPageViewController.swift
//  Plog


import UIKit
import CoreLocation
import MapKit

class MainPageViewController: UIViewController, CLLocationManagerDelegate{
    //위치 권한
    var locationManager: CLLocationManager!
//    var latitude: Double?
  //  var longtitude: Double?
    
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var current: UILabel!
    @IBAction func bnt(_ sender: Any) {
        temp.text = "hi"
        
    }
    @IBOutlet weak var touch: UIButton!
    @IBAction func touch(_ sender: Any) {
        print("hi")
        //       current.text = (String(latitude ?? 0)+String(longtitude ?? 0))
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

   //     locationManager.startUpdatingLocation()
/*
        let space = locationManager.location?.coordinate
        latitude = space?.latitude
        longtitude = space?.longitude
        */
        if(locationManager.authorizationStatus == .authorizedWhenInUse){
            temp.text = "hii"
        }
      switch locationManager.authorizationStatus {
      case .authorizedWhenInUse:
          print("access")
              case .denied:
                  // 거부 상태라면 알럿을 띄워 허용하도록 유도하는 코드를 넣을 수 있다.
                  print("위치 비허용")
              case .notDetermined, .restricted:
                  // request
                  locationManager.requestWhenInUseAuthorization()
              default:
                  break
              }

    }
  
}
