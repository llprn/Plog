//쓰레기통 API 받아오기 위한 구조체

import Foundation

struct recyclingData: Decodable{
    let page: Int
    let perPage: Int
    let totalCount: Int
    let currentCount: Int
    let matchCount: Int
    let data: [rData]?
}

struct rData: Decodable{
    //var 소재지도로명: String
    var 소재지도로명주소: String
    //var 소재지지번주소: String
    //var 상세위치: String?
    var 위도: String?
    var 경도: String?
    //var 설치장소유형: String
    var 수거쓰레기종류: String
    //var 쓰레기통형태: String
    //var 관리기관명: String
    //var 관리기관전화번호: String
    //var 데이터기준일자: String
}
