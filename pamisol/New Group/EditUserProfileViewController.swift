//
//  EditUserProfileViewController.swift
//  pamisol
//
//  Created by 이예린 on 2018. 2. 6..
//  Copyright © 2018년 Yerin. All rights reserved.
//

import UIKit
import Alamofire

class EditUserProfileViewController: UIViewController {
    
    let picker = UIImagePickerController()
    
    @IBOutlet var profileImage: UIImageView!
    
    @IBOutlet var email: UITextField!
    @IBOutlet var name: UITextField!
    @IBOutlet var password: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func changeimg(_ sender: UIButton) {
        
        let alert =  UIAlertController(title: "사진을 선택해주세요", message: "사지인!", preferredStyle: .actionSheet)
        
        //이 Action Sheet가 클릭되었을 때 할 행동을 클로져로 만들어줌
        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary()
        }
        
        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
            self.openCamera()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        //action 연결
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func submitBtn() {
       //jsonEdit()
        
        
        //let image:NSData = UIImageJPEGRepresentation(profileImage.image!, 100)! as NSData
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let Auth_header = ["Authorization":"Token "+appDelegate.token]
        let url = try! URLRequest(url: "http://192.168.0.10:8003/profile/\(appDelegate.userPK)/", method: .put, headers: Auth_header)
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(UIImagePNGRepresentation(self.profileImage.image!)!, withName: "image", mimeType: "image/png")
        }, with: url) {  result in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    debugPrint(response)
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
 
    }
    
    //회원정보 수정 보내기
    func jsonEdit() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let Auth_header = ["Authorization":"Token "+appDelegate.token]
        //let imageData:NSData = UIImageJPEGRepresentation(profileImage.image!, 100)! as NSData
        let parameters:[String:Any] = [
            "image" : "https://goo.gl/images/TYpk1a"
        ]
        
        Alamofire.request("http://192.168.0.10:8003/profile/\(appDelegate.userPK)/", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: Auth_header)
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                print("success")
                return .success
            }
            .responseJSON { response in
                switch response.result {
                //성공일 때
                case .success(_):
                    print("dd")
                    debugPrint(response)
                //실패했을 시
                case .failure(_):
                    debugPrint(response)
                }
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EditUserProfileViewController : UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    
    //picker의 소스타입을 사진 라이브러리로 지정
    func openLibrary(){
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    //picker의 소스타입을 사진 카메라로 지정
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            present(picker, animated: false, completion: nil)
        }
        else{
            print("Camera not available")
        }

    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            profileImage.image = image
            print(info)
        }
        dismiss(animated: true, completion: nil)
        print("imagePickerController out")
    }
    

    
}


