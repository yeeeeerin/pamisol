//
//  SignUpViewController2.swift
//  pamisol
//
//  Created by 이예린 on 2018. 2. 7..
//  Copyright © 2018년 Yerin. All rights reserved.
//

import UIKit
import Alamofire

class SignUpViewController2: UIViewController {
    
    
    var url:String = ":8003/profile/"

    var arr:[String]=["경기도","인천","서울시"]
    
    var sigArr:[String:[String]] = [:]
    
    //광역시도 드롭다운 버튼,talbe
    @IBOutlet var gysDropDownBtn: UIButton!
    @IBOutlet var gysTableview: UITableView!
    //시군구 드롭다운 버튼,table
    @IBOutlet var sigDropDownBtn: UIButton!
    @IBOutlet var sigTableView: UITableView!
    
    @IBOutlet var name: UITextField!
    
    @IBOutlet var profileImg: UIImageView!
    
    @IBOutlet var nextBtn: UIButton!
    
    @IBOutlet var f1: UIButton!
    @IBOutlet var f2: UIButton!
    @IBOutlet var f3: UIButton!
    @IBOutlet var f4: UIButton!
    @IBOutlet var f5: UIButton!
    @IBOutlet var f6: UIButton!
    @IBOutlet var f7: UIButton!
    @IBOutlet var f8: UIButton!
    @IBOutlet var f9: UIButton!
    @IBOutlet var f10: UIButton!
    @IBOutlet var f11: UIButton!
    
    
    var favoriteArrBtn:[String:UIButton]!
    
    let picker = UIImagePickerController()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
        favoriteArrBtn = ["한식":self.f1,
                          "패스트\n 푸드":self.f2,
                          "양식":self.f3,
                          "중국집":self.f4,
                          "분식":self.f5,
                          "경양식":self.f6,
                          "인디":self.f7,
                          "태국":self.f8,
                          "디저트":self.f9,
                          "퓨전":self.f10,
                          "일식":self.f11]
        
        sigArr=[
            self.arr[0]:["성남시","고양시","수원시","안양시","부천시"],
            self.arr[1]:["부평구","연수구","남동구","서구","계양구"],
            self.arr[2]:["강남역","가로수길","신사/압구정","청담동","신천/잠실"]
        ]
        
        signUp2UI()
        
        
    }
    
    func signUp2UI(){
        //테이블 뷰 숨기기
        self.gysTableview.isHidden = true
        self.sigTableView.isHidden = true
        
        //닉네임 textfield 꾸미기
        name.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        
        //button bottom border add
        gysDropDownBtn.addBottomBorderWithColor(color: UIColor.black, width: 2)
        sigDropDownBtn.addBottomBorderWithColor(color: UIColor.black, width: 2)
        
        //tableview border radius add
        gysTableview.layer.cornerRadius = 5
        sigTableView.layer.cornerRadius = 5

        gysTableview.layer.borderWidth = 1
        gysTableview.layer.borderColor = UIColor(rgb: 0xDEDEDE).cgColor
        
        sigTableView.layer.borderWidth = 1
        sigTableView.layer.borderColor = UIColor(rgb: 0xDEDEDE).cgColor
        
        gysTableview.separatorStyle = .none
        sigTableView.separatorStyle = .none
        
        //profile image radius add
        profileImg.layer.cornerRadius = 32
        profileImg.layer.borderColor = UIColor(rgb: 0xDEDEDE).cgColor
        profileImg.clipsToBounds = true
        
        //nextbtn border + radius
        nextBtn.layer.borderWidth = 1
        nextBtn.layer.borderColor = UIColor(rgb: 0xDEDEDE).cgColor
        nextBtn.layer.cornerRadius = 5
        
        //favorite menu 글자 처리
        //favorite menu border + radius 처리
        for data in favoriteArrBtn{
            data.value.layer.borderWidth = 1
            data.value.layer.borderColor = UIColor(rgb: 0xDEDEDE).cgColor
            data.value.layer.cornerRadius = 24
            
            data.value.setTitle(data.key, for: .normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //선호하는 메뉴를 눌렀을 때
    @IBAction func clickFavoriteMenu(_ sender: UIButton) {
        
        if sender.currentTitleColor == .red{
            sender.setTitleColor(.black, for: .normal)
            sender.layer.borderColor = UIColor(rgb: 0xDEDEDE).cgColor
        }
        else{
            sender.setTitleColor(.red, for: .normal)
            sender.layer.borderColor = UIColor(rgb: 0xFF0000).cgColor
        }
    }
    
    //선호하는 메뉴 리턴 값
    func returnFavoriteMenu() -> String{
        var strFavoriteMenu:String = ""
        
        for data in favoriteArrBtn{
            if strFavoriteMenu.isEmpty {
                strFavoriteMenu = data.key
            }
            else if data.value.currentTitleColor == .red{
                strFavoriteMenu = strFavoriteMenu+"/"+data.key
            }
        }
        
        return strFavoriteMenu
    }
    
    
    /**/
    //광역시도 눌렀을 때
    @IBAction func gysBtnPressed() {
        //누를때마다 반전
        self.gysTableview.isHidden = !self.gysTableview.isHidden
        if !self.gysTableview.isHidden {
            self.sigTableView.isHidden = true
        }
        
    }
    @IBAction func sigBtnPressed() {
        self.sigTableView.reloadData()
        self.sigTableView.isHidden = !self.sigTableView.isHidden
        if !self.sigTableView.isHidden {
            self.gysTableview.isHidden = true
        }
    }
    
    @IBAction func nextBtnPressed() {
        createProfile()
    }
    
    
    @IBAction func changeImg() {
        
        let alert =  UIAlertController(title: "선택해주세요", message: "", preferredStyle: .actionSheet)
        
        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary()
        }
        
        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
            self.openCamera()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)

        
    }
    
    
    func gotoFeedPage() {
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "Feed")
        self.present(nextView, animated: true, completion: nil)
    }

}

//통신관련
extension SignUpViewController2{
    /*
     api 연결
     */
    func createProfile() {
        
        //이미지 처리 uiimage -> data
        let image:UIImage = profileImg.image!
        var imageData: Data?
        
        if let cgImage = image.cgImage, cgImage.renderingIntent == .defaultIntent {
            imageData = UIImageJPEGRepresentation(image, 0.8)
        }
        else {
            imageData = UIImagePNGRepresentation(image)
        }
        
        let location_category = (gysDropDownBtn.titleLabel?.text)!+" "+(sigDropDownBtn.titleLabel?.text)!
        
        let parameters:[String:Any] = [
            "food_category":"한식/양식",
            "location_category" : location_category
        ]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        print(appDelegate.basicURL+url)
        
        let Auth_header = ["Authorization":"Token "+appDelegate.token]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if let data = imageData{
                multipartFormData.append(data, withName: "image", fileName: "hh.png", mimeType: "image/png")
            }
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
        }
        , usingThreshold: UInt64.init(), to: appDelegate.basicURL+url, method: .post , headers: Auth_header) { (result) in
            debugPrint(result)
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    if let JSON = response.result.value as? [String : Any] {
                        var is_success:Bool = false
                        for data in JSON{
                            if data.key == "code"{
                                if (data.value as! Int) == 2010{
                                    is_success = true
                                }
                            }
                            //성공코드가 온다면
                            if is_success == true{
                                if data.key == "data"{
                                    //let data = info.value as! [String : Any]
                                    if let profiles:[String:Any] = data.value as? [String : Any] {
                                        for profile in profiles{
                                            print(profile.key)
                                            //프로필 pk값 넣기
                                            if profile.key == "pk"{
                                                appDelegate.profilePK = profile.value as! Int
                                                self.gotoFeedPage()
                                            }
                                        }
                                        
                                    }
                                }
                                
                            }
                        }
                    }
                    
                    print(response)
                    
                    print("Succesfully uploaded")
                    if response.error != nil{
                        //onError?(err)
                        print("err")
                        return
                    }
                    
                    let storyboard: UIStoryboard = self.storyboard!
                    let nextView = storyboard.instantiateViewController(withIdentifier: "Feed")
                    self.present(nextView, animated: true, completion: nil)
                    print("success")
                    
                    //onCompletion?(nil)
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                //onError?(error)
            }
        }
    }
}

extension SignUpViewController2:UITableViewDelegate, UITableViewDataSource{
    
    //셀의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == gysTableview{
            return arr.count
        }
        else{
            return (sigArr[(gysDropDownBtn.titleLabel?.text)!]?.count)!
        }
        
    }
    
    //셀에 표시 될 내용
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //광역시도
        if tableView == gysTableview{
            let cell = tableView.dequeueReusableCell(withIdentifier: "GYS Cell",for:indexPath)
            cell.textLabel?.text = arr[indexPath.row]
            return cell
        }
        //시군구
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SIG Cell",for:indexPath)
            cell.textLabel?.text = sigArr[(gysDropDownBtn.titleLabel?.text)!]?[indexPath.row]
            return cell
        }
    }
    
    //테이블뷰 안에있는 내용을 선택했을 시 테이블뷰를 숨김
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == gysTableview{
            let cell = gysTableview.cellForRow(at: indexPath)
            gysDropDownBtn.setTitle(cell?.textLabel?.text, for:.normal)
            self.gysTableview.isHidden = true
            
        }
        else{
            print("sig in!")
            let cell = sigTableView.cellForRow(at: indexPath)
            sigDropDownBtn.setTitle(cell?.textLabel?.text, for:.normal)
            self.sigTableView.isHidden = true
        }
    }
}

extension SignUpViewController2: UIImagePickerControllerDelegate,
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
            profileImg.image = image
            print(info)
        }
        dismiss(animated: true, completion: nil)
        print("imagePickerController out")
    }
    
    
    
}

extension SignUpViewController2:UITextFieldDelegate{
    //delegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//bottom에만 밑줄을 만들기 위헤 추가
extension UIView {
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
}
