
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
/*
func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    
    guard let location = locations.first
    else {return}
    let latitude = location.coordinate.latitude
    let longtitude = location.coordinate.longitude
        
}*/

class WeatherService {
    // API 호출을 위한 URL
    let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=seoul&appid=6cb03060feeddc6a874d4e5aabfe15f9")
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
