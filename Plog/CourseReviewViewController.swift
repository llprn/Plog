//
//  CourseReviewViewController.swift
//  Plog
//
//  Created by HR on 2022/08/08.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import CoreLocation

class CourseReviewViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    // 이동 경로 이미지, 이동 시간, 이동 거리
    var routeImageSent: UIImage!
    var ploggingTimeSent: String?
    var ploggingDistSent: String?
    var startPoint: CLLocationCoordinate2D?
    var endPoint: CLLocationCoordinate2D?
    
    @IBOutlet var routeImage: UIImageView!
    @IBOutlet var ploggingTime: UILabel!
    @IBOutlet var ploggingDist: UILabel!
    
    // 이동 동선
    @IBOutlet var routeText: UITextField!
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        routeText.resignFirstResponder()
        return true
    }
    
    
    // 플로깅 전/후 사진
    @IBOutlet var beforePlogging: UIImageView!
    @IBOutlet var afterPlogging: UIImageView!
    @IBOutlet var beforeLogo: UIImageView!
    @IBOutlet var afterLogo: UIImageView!
    
    

    
    var imgPickerController = UIImagePickerController()
    var selectedView: UIView!
    
    @objc func chooseImage(_ gesture: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            selectedView = gesture.view
            present(imgPickerController, animated: true)
        }
    }
    
    // 쓰레기 양
    @IBOutlet var trashAmount_l: UIButton!
    @IBOutlet var trashAmount_m: UIButton!
    @IBOutlet var trashAmount_s: UIButton!
    var trashAmountString: String! = "많음"
    
    
    @IBAction func trashAmount(_ sender: UIButton) {
        if sender.tag == 1 {
            trashAmount_l.isSelected = true
            trashAmount_m.isSelected = false
            trashAmount_s.isSelected = false
            trashAmountString = "많음"
        }
        else if sender.tag == 2 {
            trashAmount_l.isSelected = false
            trashAmount_m.isSelected = true
            trashAmount_s.isSelected = false
            trashAmountString = "보통"
        }
        else if sender.tag == 3 {
            trashAmount_l.isSelected = false
            trashAmount_m.isSelected = false
            trashAmount_s.isSelected = true
            trashAmountString = "적음"
        }
    }
    
    // 가장 많았던 쓰레기 종류
    @IBOutlet var plastic: UIButton!
    @IBOutlet var can: UIButton!
    @IBOutlet var vinyl: UIButton!
    @IBOutlet var paper: UIButton!
    @IBOutlet var trash: UIButton!
    var theMostTrashString: String! = "플라스틱"
    
    
    @IBAction func theMostTrash(_ sender: UIButton) {
        if sender.tag == 1 {
            plastic.isSelected = true
            can.isSelected = false
            vinyl.isSelected = false
            paper.isSelected = false
            trash.isSelected = false
            theMostTrashString = "플라스틱"
        }
        else if sender.tag == 2 {
            plastic.isSelected = false
            can.isSelected = true
            vinyl.isSelected = false
            paper.isSelected = false
            trash.isSelected = false
            theMostTrashString = "캔"
        }
        else if sender.tag == 3 {
            plastic.isSelected = false
            can.isSelected = false
            vinyl.isSelected = true
            paper.isSelected = false
            trash.isSelected = false
            theMostTrashString = "비닐"
        }
        else if sender.tag == 4 {
            plastic.isSelected = false
            can.isSelected = false
            vinyl.isSelected = false
            paper.isSelected = true
            trash.isSelected = false
            theMostTrashString = "종이"
        }
        else if sender.tag == 5 {
            plastic.isSelected = false
            can.isSelected = false
            vinyl.isSelected = false
            paper.isSelected = false
            trash.isSelected = true
            theMostTrashString = "일반"
        }
    }
    
    // 달리기 후기
    @IBOutlet var joggingReview: UITextView!

    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func placeholderSetting() {
        joggingReview.delegate = self
        joggingReview.text = "최소 10자 이상"
        joggingReview.textColor = UIColor.lightGray
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "최소 10자 이상"
            textView.textColor = UIColor.lightGray
        }
        if textView.text.count >= 10 {
            self.toggleUploadBtn()
        } else {
            uploadBtn.isUserInteractionEnabled = false
            uploadBtn.alpha = 0.5
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 100 {
            textView.deleteBackward()
        }
    }
    
    
    
    let db = Firestore.firestore()
    var storageRef: StorageReference!
    var currentDate: String!
    var uuid: String = ""
    var pathList: Array<String> = ["routeImage", "beforePlogging", "afterPlogging"]
    var path1: String = ""
    var path2: String = ""
    var path3: String = ""
    var imgDataList: Array<Data> = []
    
    // 등록 버튼
    @IBOutlet var uploadBtn: UIButton!
    @IBAction func uploadReviewBtn(_ sender: Any) {
        
        // 등록 날짜 생성
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "yyyy-MM-dd"
        currentDate = formatter1.string(from: Date())
        
        uuid = UUID().uuidString
        storageRef = Storage.storage().reference()
        
        uploadImgToStorage {
            // do your next work here
            self.uploadDataToDB()
            self.moveToNewVC()
        }
    }
    
    func uploadImgToStorage(completion:@escaping () -> Void ) {
//        uuid = UUID().uuidString
//        let storageRef = Storage.storage().reference()
        
        guard let imageData1 = routeImage.image!.jpegData(compressionQuality: 0.8) else {
            completion() ; return }
        guard let imageData2 = beforePlogging.image!.jpegData(compressionQuality: 0.8) else { completion() ; return }
        guard let imageData3 = afterPlogging.image!.jpegData(compressionQuality: 0.8) else { completion() ; return }
        imgDataList.append(imageData1)
        imgDataList.append(imageData2)
        imgDataList.append(imageData3)
        
        print("starting image upload!")
        
        path1 = "review/\(uuid)/routeImage.jpg"
        let fileRef1 = storageRef.child(path1)
        fileRef1.putData(imgDataList[0], metadata: nil) { (metadata, error) in
            
            guard let metadata = metadata else {
                return
            }
            fileRef1.downloadURL { (url, error) in
                guard let urlStr = url else {
                    return
                }
                let urlFinal = (urlStr.absoluteString)
                print(urlFinal)
                completion()
            }
        }
        
        path2 = "review/\(uuid)/beforePlogging.jpg"
        let fileRef2 = storageRef.child(path2)
        fileRef2.putData(imgDataList[1], metadata: nil) { (metadata, error) in
            
            guard let metadata = metadata else {
                return
            }
            fileRef2.downloadURL { (url, error) in
                guard let urlStr = url else {
                    return
                }
                let urlFinal = (urlStr.absoluteString)
                print(urlFinal)
                completion()
            }
        }
        
        path3 = "review/\(uuid)/afterPlogging.jpg"
        let fileRef3 = storageRef.child(path3)
        fileRef3.putData(imgDataList[2], metadata: nil) { (metadata, error) in
            
            guard let metadata = metadata else {
                return
            }
            fileRef3.downloadURL { (url, error) in
                guard let urlStr = url else {
                    return
                }
                let urlFinal = (urlStr.absoluteString)
                print(urlFinal)
                completion()
            }
        }
        
    }

    
    func uploadDataToDB() {
        self.db.collection("review").document(self.uuid).setData([
            "routeImage" : path1,
            "ploggingTime" : self.ploggingTimeSent!,
            "ploggingDist" : self.ploggingDistSent!,
            "routeText" : self.routeText.text!,
            "beforePlogging" : path2,
            "afterPlogging" : path3,
            "trashAmount" : self.trashAmountString!,
            "theMostTrash" : self.theMostTrashString!,
            "joggingReview" : self.joggingReview.text!,
            "date" : currentDate!
        ]) { err in
            if let err = err {
                print(err)
            } else {
                print("DB Success")
            }
        }
        
        // 시작/종료 지점 좌표 db에 저장
        if (startPoint != nil && endPoint != nil) {
//            DB Success 3번씩 돼서 이렇게 하면 3개가 따로따로 들어감
//            self.db.collection("startAndEndPoints").addDocument(data: [
            self.db.collection("startAndEndPoints").document(self.uuid).setData([
                "startPoint" : GeoPoint(latitude: startPoint!.latitude, longitude: startPoint!.longitude),
                "endPoint" : GeoPoint(latitude: endPoint!.latitude, longitude: endPoint!.longitude)
            ]) { err in
                if let err = err {
                    print(err)
                } else {
                    print("DB Success")
                }
            }
        } else {
            print("pointss is empty! Will not pass startAndEndPoints to DB")
        }
        
        
    }
    
    func moveToNewVC() {
        print("I am moving!")
        
        let newVC = UIStoryboard(name: "dbTest", bundle: nil).instantiateViewController(withIdentifier: "dbTestViewController") as! dbTestViewController
        newVC.modalPresentationStyle = .fullScreen
        newVC.modalTransitionStyle = .crossDissolve

        // newVC.documentIDString = makeDocumentID
        newVC.uuid = self.uuid
        
        self.present(newVC, animated: true, completion: nil)
    }
    
    
    // 등록 버튼 활성화
    private func toggleUploadBtn() {
        if
            !routeText.text!.isEmpty,
            joggingReview.text.count >= 10,
            !beforePlogging.isEqual(afterPlogging)
        {
            uploadBtn.isUserInteractionEnabled = true
            uploadBtn.alpha = 1.0
        } else {
            uploadBtn.isUserInteractionEnabled = false
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text!.count > 0 {
            self.toggleUploadBtn()
        } else {
            uploadBtn.isUserInteractionEnabled = false
            uploadBtn.alpha = 0.5
        }
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        uploadBtn.isUserInteractionEnabled = false
        uploadBtn.alpha = 0.5
        
        routeImage.image = routeImageSent
        ploggingTime.text = ploggingTimeSent
        ploggingDist.text = ploggingDistSent
        
        routeText.delegate = self
        
        
        joggingReview.delegate = self
        placeholderSetting()
        joggingReview.layer.borderWidth = 0.8
        joggingReview.layer.borderColor = UIColor.lightGray.cgColor
        joggingReview.layer.cornerRadius = 8
        
        
        imgPickerController.delegate = self
        imgPickerController.sourceType = .savedPhotosAlbum
        imgPickerController.allowsEditing = false
        
        [beforePlogging, afterPlogging].forEach {
            $0?.isUserInteractionEnabled = true
            $0?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseImage)))
        }
    }
}
    
extension CourseReviewViewController: UIImagePickerControllerDelegate,  UINavigationControllerDelegate{
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let img = info[UIImagePickerController.InfoKey.originalImage]{
//            beforePlogging.image = img as? UIImage
//        }
//        dismiss(animated: true, completion: nil)
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            (selectedView as? UIImageView)?.image = info[.originalImage] as? UIImage
        dismiss(animated: true)
        if beforePlogging.image != nil {
            beforeLogo.image = nil
        }
        if afterPlogging.image != nil {
            afterLogo.image = nil
        }
        self.toggleUploadBtn()
        }
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
