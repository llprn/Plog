//
//  CourseReviewViewController.swift
//  Plog
//
//  Created by HR on 2022/08/08.
//

import UIKit

class CourseReviewViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    // 이동 경로 이미지, 이동 시간, 이동 거리
    var routeImageSent: UIImage!
    var ploggingTimeSent: String?
    var ploggingDistSent: String?
    
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
    
    @IBAction func trashAmount(_ sender: UIButton) {
        if sender.tag == 1 {
            trashAmount_l.isSelected = true
            trashAmount_m.isSelected = false
            trashAmount_s.isSelected = false
            //result.text = "L Selected!"
        }
        else if sender.tag == 2 {
            trashAmount_l.isSelected = false
            trashAmount_m.isSelected = true
            trashAmount_s.isSelected = false
            //result.text = "M Selected!"
        }
        else if sender.tag == 3 {
            trashAmount_l.isSelected = false
            trashAmount_m.isSelected = false
            trashAmount_s.isSelected = true
            //result.text = "S Selected!"
        }
    }
    
    // 가장 많았던 쓰레기 종류
    @IBOutlet var plastic: UIButton!
    @IBOutlet var can: UIButton!
    @IBOutlet var vinyl: UIButton!
    @IBOutlet var paper: UIButton!
    @IBOutlet var trash: UIButton!
    
    @IBAction func theMostTrash(_ sender: UIButton) {
        if sender.tag == 1 {
            plastic.isSelected = true
            can.isSelected = false
            vinyl.isSelected = false
            paper.isSelected = false
            trash.isSelected = false
        }
        else if sender.tag == 2 {
            plastic.isSelected = false
            can.isSelected = true
            vinyl.isSelected = false
            paper.isSelected = false
            trash.isSelected = false
        }
        else if sender.tag == 3 {
            plastic.isSelected = false
            can.isSelected = false
            vinyl.isSelected = true
            paper.isSelected = false
            trash.isSelected = false
        }
        else if sender.tag == 4 {
            plastic.isSelected = false
            can.isSelected = false
            vinyl.isSelected = false
            paper.isSelected = true
            trash.isSelected = false
        }
        else if sender.tag == 5 {
            plastic.isSelected = false
            can.isSelected = false
            vinyl.isSelected = false
            paper.isSelected = false
            trash.isSelected = true
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
        joggingReview.text = "10~100자 이내로 코스가 어땠는지 설명해주세요"
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
            textView.text = "10~100자 이내로 코스가 어땠는지 설명해주세요"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 100 {
            textView.deleteBackward()
        }
    }
    
    // 등록 버튼
    @IBAction func uploadReviewBtn(_ sender: Any) {
        // 코스 후기 게시판으로 이동
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

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
        }
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
