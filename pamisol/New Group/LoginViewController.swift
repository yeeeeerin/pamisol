//
//  LoginViewController.swift
//  pamisol
//
//  Created by 이예린 on 2018. 1. 22..
//  Copyright © 2018년 Yerin. All rights reserved.
//
//로그인 페이지

import UIKit
import Alamofire
import DKLoginButton

class LoginViewController: UIViewController{
    
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    
    
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var oauthBtn: UIButton!
    @IBOutlet var joinBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginUI()

    }
    
    //로그인과 관련된 ui 처리
    func loginUI() {
        //UITextField 에 밑에 선만 보이게 하기
        email.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        password.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        
        //각각 버튼에 대한 border 설정
        loginBtn.layer.borderWidth = 1
        loginBtn.layer.borderColor = UIColor(rgb: 0xDEDEDE).cgColor
        
        oauthBtn.layer.borderWidth = 1
        oauthBtn.layer.borderColor = UIColor(rgb: 0xDEDEDE).cgColor
        
        joinBtn.layer.borderWidth = 1
        joinBtn.layer.borderColor = UIColor(rgb: 0xDEDEDE).cgColor
        
        
        
    }
    
    //auth server에 로그인 정보를 넘겨주고 토큰을 받아옴
    func jsonLogin(){
        
        let parameters:[String:[String:String]] = [
            "user":[
                "email":email.text!,
                "password":password.text!
            ]
        ]
   
        Alamofire.request("http://192.168.0.10:8001/local_auth/login/", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                print("success")
                return .success
            }
            .responseJSON { response in
                debugPrint(response)
                switch response.result {
                //성공일 때
                case .success( _):
                    
                    if let JSON = response.result.value as? [String : [String : Any]] {
                        
                        if let user = JSON["user"] { //Its giving me the error here
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            
                            var is_success:Bool = false
                            for info in user {
                        
                                if info.key == "code"{
                                    let value:Int = info.value as! Int
                                    if value == 1010{
                                        is_success = true
                                    }
                                }
                                

                                //성공코드가 온다면
                                if is_success == true{
                                    if info.key == "data"{
                                        //let data = info.value as! [String : Any]
                                        if let datas:[String:Any] = info.value as? [String : Any] {
                                            for data in datas{
                                                print(data.key)
                                                //pk값 넣기
                                                if data.key == "user_id"{
                                                    appDelegate.userPK = data.value as! Int

                                                }
                                                //토큰 값 넣기
                                                if data.key == "token"{
                                                    appDelegate.token = data.value as! String
                                                    print("in!")

                                                }
                                                
                                                if data.key == "profile_id"{
                                                    appDelegate.profilePK = data.value as! Int
                                                }
                                                
                                                //만약 첫 로그인 이라면??
                                                if data.key == "login_count"{
                                                    let count:Int = data.value as! Int
                                                    if count == 1{
                                                        let storyboard: UIStoryboard = self.storyboard!
                                                        let nextView = storyboard.instantiateViewController(withIdentifier: "SignUp2")
                                                        self.present(nextView, animated: true, completion: nil)
                                                    }
                                                }
                                                
                                            }
                                            let storyboard: UIStoryboard = self.storyboard!
                                            let nextView = storyboard.instantiateViewController(withIdentifier: "Feed")
                                            self.present(nextView, animated: true, completion: nil)
                                        }
                                    }
                                   
                                }
                            }
                        }
                    }

                //실패했을 시
                case .failure(_):
                    debugPrint(response)
                }


                
                
        }
        
    }
    
    @IBAction func clickLoginBtn() {

        jsonLogin()
    }
    
    @IBAction func clickOAuthBtn() {
        print("clickOAuthBtn()")
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

extension LoginViewController:UITextFieldDelegate{
    //delegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//bottom border를 위한
extension UITextField {
    func addBorderBottom(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height-height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}
//hex code로 색을 넣어주기 위한

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
