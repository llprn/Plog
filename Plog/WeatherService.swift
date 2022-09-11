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

class WeatherService:NSObject, CLLocationManagerDelegate{
    let uurl: String = "https://api.openweathermap.org/data/2.5/weather?"
    let aid: String = "&appid=6cb03060feeddc6a874d4e5aabfe15f9"

    func getWeather(lat:Double,lon:Double,completion: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
        let lati = "lat=\(lat)&"
        let longi = "lon=\(lon)"
        guard let url:URL = URL(string:uurl+lati+longi+aid) else{
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
               completion(.success(weatherResponse)) //데이터 저장
            } else {
                print(url)
                completion(.failure(.decodingError))
           }
       }.resume()
    }
}


    
