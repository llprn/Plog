//  ViewController.swift


import UIKit
import CoreLocation
import MapKit //지도
import SwiftUI

import KakaoSDKAuth
import KakaoSDKUser

import FirebaseFirestore

//marker class
class Marker:NSObject,MKAnnotation{
    let title:String?
    let coordinate:CLLocationCoordinate2D
    init(title:String?,
         coordinate:CLLocationCoordinate2D){
        self.title = title
        self.coordinate = coordinate
        super.init()
    }
}
class ViewController: UIViewController,MKMapViewDelegate {
    //db
    var documentIDString: String!
    let db = Firestore.firestore()
    var uuid: String = ""
    
    @IBOutlet weak var location: UILabel!
    //날씨
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    
    //지도
    @IBOutlet weak var mapView: MKMapView!
    let mark = Marker(
        title: "숙명여대",
        coordinate:CLLocationCoordinate2D(latitude:37.54638593013086,longitude: 126.96369838218818))
    
    
    @IBOutlet weak var weatherImg: UIImageView!
    var weather: Weather?
    var main: Main?
    var name: String?
    @IBOutlet weak var testt: UILabel!

    @IBOutlet weak var test: UILabel! //del
    
    @IBOutlet weak var weatherDescription: UILabel!
    //   var locationManager = CLLocationManager()
    var locationManager: CLLocationManager!
    var currentLocation: String?

    var longitude: Double!
    var latitude: Double!
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
        mapView.addAnnotation(mark) //지도
        locationManager = CLLocationManager()
        locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //위도,경도 정보
        let coor = locationManager.location?.coordinate
                latitude = coor?.latitude
                longitude = coor?.longitude
        
        switch locationManager.authorizationStatus{
            case .denied:
            print("위치 비허용")
        case .notDetermined, .restricted:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
        test.text = ("\(longitude ?? 0)")
        
       //map marker 수정필요
 /*       db.collection("startAndEndPoints").document(self.uuid).getDocument { [self] snapshot, error in
        guard let data = snapshot?.data(), error == nil else {
                return
            }
            print("hi")
      //      self.startPoint.text = data["startPoint"] as? String
      //      self.endPoint.text = data["endPoint"] as? String
                
         
            }*/
      //map marker

        //weather
        WeatherService().getWeather{ result in
                    switch result{
                    case .success(let weatherResponse): DispatchQueue.main.async {
                        self.weather = weatherResponse.weather.first
                        self.main = weatherResponse.main
                        self.name = weatherResponse.name
                        self.setWeather()
                        
                    }
                    case .failure(_ ):
                        print("error")
                        
                    }
                   
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
 //   }
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


