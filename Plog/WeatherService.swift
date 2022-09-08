//  WeatherService.swift
//  Plog
import Foundation
import CoreLocation

// 에러 정의
enum NetworkError: Error {
    case badUrl
    case noData
    case decodingError
}



/*class Mark{
    let coordinate:CLLocationCoordinate2D
    init(
         coordinate:CLLocationCoordinate2D){
        self.coordinate = coordinate
    }
}*/
/*
class LocationService {
    static var shared = LocationService()
    var longitude:Double!
    var latitude:Double!
}*/
class WeatherService {
    // API 호출을 위한 URL
    let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=seoul&appid=6cb03060feeddc6a874d4e5aabfe15f9")
  
//                "Latitude: \(locationCoordinate.latitude),
  //  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
 /*   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation],completion:@escaping (Result<WeatherResponse, NetworkError>) -> Void) {
        if let location = locations.first {
           let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
           guard let url = URL(string:
                                "https://api.openweathermap.org/data/2.5/weather?appid=6cb03060feeddc6a874d4e5aabfe15f9&lat=\(latitude)&lon=\(longitude)") else{
               return completion(.failure(.badUrl))*/
        //}
        //    getWeather(latitude:lat,longitude:lon)
        //    print(lat,lon)
     //   }
       
         
       // } locationManager
    
   //func getWeather(/*_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation],*/ /*latitude:CLLocationDegrees,longitude:CLLocationDegrees,url,*/completion: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
      
        
    //    guard let location = locations.first
   //     else {return}
//        let latitude = location.coordinate.latitude
//        let longitude = location.coordinate.longitude
      //  test.text = ("\(longitude ?? 0)")

   //     guard let url = "\(wurl)&lat=\(latitude)&lon=\(longitude)" else{
/*핸드폰으로 돌려보기  "\(details.rate)"
    let longitude = LocationService.shared.longitude! as? Int
     let latitude = LocationService.shared.latitude! as? Int

    let url = URL(string:
                    "https://api.openweathermap.org/data/2.5/weather?appid=6cb03060feeddc6a874d4e5aabfe15f9&lat=\(LocationService.shared.longitude!)&lon=\(LocationService.shared.latitude!)")*/
 
    func getWeather(completion: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
        guard let url = url else {
            return completion(.failure(.badUrl))
        }
       
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
           
           // Data 타입으로 받은 리턴을 디코드
            let weatherResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data)

           // 성공
            if let weatherResponse = weatherResponse {
               print(weatherResponse)
               completion(.success(weatherResponse)) // 성공한 데이터 저장
            } else {
               completion(.failure(.decodingError))
           }
       }.resume() // 이 dataTask 시작
    }
   
}
