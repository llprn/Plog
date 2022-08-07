
//  DiscussionRegisterViewController.swift
//  Plog


import UIKit

class DiscussionRegisterViewController: UIViewController, UITextFieldDelegate,UITextViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    let imagePickerController = UIImagePickerController()
    
  //  @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var contentTV: UITextView!
    
    @IBOutlet weak var titleTF: UITextField!
    
    @IBAction func img(_ sender: Any) {
    imagePickerController.sourceType = .photoLibrary //앨범에서 선택
        self.present(imagePickerController, animated: true, completion: nil)
     //   titleTF.text = "hi"
    }
    
    @IBAction func registerButton(_ sender:Any){
        dismiss(animated: false)
        //화면 합치고 수정하기
    }
 
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var countTitle: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.titleTF.layer.borderWidth=0.5
        self.titleTF.layer.borderColor=UIColor.black.cgColor
       
        
        self.contentTV.layer.borderWidth=0.5
        self.contentTV.layer.borderColor=UIColor.black.cgColor
        
        contentTV.delegate = self
        
        titleTF.delegate = self
      
        imagePickerController.delegate = self
        
    }

    
    // textField 글자 수 제한
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if(textField.text?.count ?? 0 > 20){
            textField.deleteBackward()
            return false
        }
        
        let startLength = textField.text?.count ?? 0
        let lengthAdd = string.count
        let lengthreplace = range.length
        let newLength = startLength + lengthAdd - lengthreplace
        countTitle.text = "\(newLength)/20"
        //countTitle.text = "\(textField.text?.count)/20"
        
        return true
    }
    
    // textView 글자 수 제한
    func textViewDidBeginEditing(_ textView: UITextView){
        textView.text = nil
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {
            return false }
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        countLabel.text = "\(changedText.count)/100"
        return changedText.count < 100
    }
    
    //사진
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.imgView.image = image
        }
        dismiss(animated: true, completion: nil) //컨트롤러 닫기
        
    }
    
   
}

