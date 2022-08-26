//쓰레기통 API 받아오기 위한 구조체

import Foundation

struct recyclingData_dalseo: Decodable{
    let page: Int
    let perPage: Int
    let totalCount: Int
    let currentCount: Int
    let matchCount: Int
    let data: [rData_dalseo]?
}

struct rData_dalseo: Decodable{
    var 위도: String?
    var 경도: String?
    var 설치주소: String?
//    var 설치지점: String
    var 수거쓰레기종류: String
//    var 담당부서: String
//    var 기준일자: String
    
    enum CodingKeys: String, CodingKey {
        case 위도, 경도
        case 설치주소 = "설치 주소"
        case 수거쓰레기종류 = "수거쓰레기 종류"
    }
}

