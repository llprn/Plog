//  ViewController.swift


import UIKit
import CoreLocation
import MapKit //지도
import SwiftUI

import KakaoSDKAuth
import KakaoSDKUser

class ViewController: UIViewController {
    @IBOutlet weak var location: UILabel!
    //날씨
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    
    @IBOutlet weak var weatherImg: UIImageView!
    var weather: Weather?
    var main: Main?
    var name: String?
    
    
 //   var locationManager = CLLocationManager()
    var locationManager: CLLocationManager!
    var currentLocation: String?
    
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
    }
    
}

extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdatedLocations locations: [CLLocation]){
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        currentLocation = "\(locValue.latitude),\(locValue.longitude)"
    }
    
    private func setWeather(){
        let url = URL(string: "https://openweathermap.org/img/wn/\(self.weather?.icon ?? "00")@2x.png")
        let data = try? Data(contentsOf: url!)
            if let data = data {
               weatherImg.image = UIImage(data: data)
           }
        location.text = name
           currentTemp.text = "\(Int(main!.temp-273))"
           maxTemp.text = "\(Int(main!.temp_max-273))"
        minTemp.text = "\(Int(main!.temp_min-273))"
    }
}

/*class LocationService {
    static var shared = LocationService()
    var longitude:Double!
    var latitude:Double!
}
*/
