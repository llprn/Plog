//배열 형태의 분리수거 목록을 문자열으로 변환


import Foundation

class ConvertTrashList: ObservableObject {
    private let trashArray: Array<Bool>
    
    init(trashArray: Array<Bool>){
        self.trashArray = trashArray
    }
    
    func convertTrash () -> String {
        var trashString = ""
        if trashArray[0] == true {
            trashString = trashString + "캔"
        }
        if trashArray[1] == true {
            if trashString != "" {
                trashString = trashString + ", "
            }
            trashString = trashString + "종이"
        }
        if trashArray[2] == true {
            if trashString != "" {
                trashString = trashString + ", "
            }
            trashString = trashString + "비닐"
        }
        if trashArray[3] == true {
            if trashString != "" {
                trashString = trashString + ", "
            }
            trashString = trashString + "플라스틱"
        }
        if trashArray[4] == true {
            if trashString != "" {
                trashString = trashString + ", "
            }
            trashString = trashString + "일반쓰레기"
        }
        return trashString
    }
}
