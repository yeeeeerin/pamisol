//
//  SignUpViewController1.swift
//  pamisol
//
//  Created by 이예린 on 2018. 1. 22..
//  Copyright © 2018년 Yerin. All rights reserved.
//
//회원가입페이지1

import UIKit
import Alamofire

class SignUpViewController1: UIViewController{

    
    @IBOutlet var email: UITextField!
    @IBOutlet var name: UITextField!
    @IBOutlet var password: UITextField!
    
    @IBOutlet var nextBtn: UIButton!
    @IBOutlet var joinManager: UIButton!
    
    var is_shopkeeper:Bool = false
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        joinUI()
        
    }
    
    //ui관련 처리
    func joinUI(){
        email.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        name.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        password.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        
        
        //각각 버튼에 대한 border 설정
        nextBtn.layer.borderWidth = 1
        nextBtn.layer.borderColor = UIColor(rgb: 0xDEDEDE).cgColor
        nextBtn.layer.cornerRadius = 5
        
        joinManager.layer.borderWidth = 1
        joinManager.layer.borderColor = UIColor(rgb: 0xDEDEDE).cgColor
        joinManager.layer.cornerRadius = 5
    }

    @IBAction func joinUser() {
        
        let parameters:[String:[String:Any]] = [
            "user":[
                "email":email.text!,
                "username":name.text!,
                "password":password.text!,
                "is_shopkeeper":is_shopkeeper
            ]
        ]
        
        Alamofire.request("http://192.168.0.10:8001/local_auth/signup/", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                
                return .success
            }
            .responseJSON { response in
                debugPrint(response)
                switch response.result {
                //성공일 때
                case .success( _):

                    if let JSON = response.result.value as? [String : Any] {
                        var is_success = false
                        for data in JSON{
                            if data.key == "code"{
                                if data.value as! Int == 1000{
                                    is_success = true
                                    let storyboard: UIStoryboard = self.storyboard!
                                    let nextView = storyboard.instantiateViewController(withIdentifier: "Login Page")
                                    self.present(nextView, animated: true, completion: nil)
                                    print("success")
                                }
                                
                            }
                            
                        }
                    }
                    
                //실패했을 시
                case .failure(_):
                    debugPrint(response)
                    
                    if let JSON = response.result.value as? [String : Any] {
                      
                        for data in JSON{
                            if data.key == "email"{
                                print("이미존재하는 아이디입니다.")
                            }
                            if data.key == "username"{
                                
                            }
                            
                        }
                    }
                    
                }
        }
        
    }
    

}

extension SignUpViewController1:UITextFieldDelegate{
    //delegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
