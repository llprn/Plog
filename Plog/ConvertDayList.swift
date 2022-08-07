//배열 형태의 요일 목록을 문자열으로 변환


import Foundation

class ConvertDayList: ObservableObject {
    private let dayArray: Array<Bool>
    
    init(dayArray: Array<Bool>){
        self.dayArray = dayArray
    }
    
    func convertDay () -> String {
        var daysString = ""
        if dayArray[0] == true {
            daysString = daysString + "일"
        }
        if dayArray[1] == true {
            if daysString != "" {
                daysString = daysString + ", "
            }
            daysString = daysString + "월"
        }
        if dayArray[2] == true {
            if daysString != "" {
                daysString = daysString + ", "
            }
            daysString = daysString + "화"
        }
        if dayArray[3] == true {
            if daysString != "" {
                daysString = daysString + ", "
            }
            daysString = daysString + "수"
        }
        if dayArray[4] == true {
            if daysString != "" {
                daysString = daysString + ", "
            }
            daysString = daysString + "목"
        }
        if dayArray[5] == true {
            if daysString != "" {
                daysString = daysString + ", "
            }
            daysString = daysString + "금"
        }
        if dayArray[6] == true {
            if daysString != "" {
                daysString = daysString + ", "
            }
            daysString = daysString + "토"
        }
        daysString = daysString + "요일"
        return daysString
    }
}
