//
//  SettingTableViewController.swift
//  pamisol
//
//  Created by 이예린 on 2018. 1. 19..
//  Copyright © 2018년 Yerin. All rights reserved.
//
//환경설정 페이지

import UIKit
import Alamofire

class SettingTableViewController: UITableViewController {
    
    var manager:[String] = ["프로필편집","식당관리","로그아웃","회원탈퇴"]
    var user:[String] = ["프로필편집","로그아웃","회원탈퇴"]
    
    //0 - user
    //1 - manager
    var is_manager:Int = 1;

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(is_manager == 1){
            return manager.count
        }
        return  user.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settings Cell", for: indexPath)

        if(is_manager == 1){
            cell.textLabel?.text = manager[indexPath.row]
        }else{
            cell.textLabel?.text = user[indexPath.row]
        }
        
        cell.detailTextLabel?.text = ">"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var select:String = ""
        
        if is_manager == 0{
            select = user[indexPath.row]
        }
        else {
            select = manager[indexPath.row]
        }
        
        switch select{
            
        case "프로필편집":
            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "Edit Profile")
            self.present(nextView, animated: true, completion: nil)
            
        case "로그아웃":
            userLogout()
            
            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "Login Page")
            self.present(nextView, animated: true, completion: nil)
            
        case "회원탈퇴":
            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "Delete User")
            self.present(nextView, animated: true, completion: nil)
            
        case "식당관리":
            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "MainStoreListPageView")
            self.present(nextView, animated: true, completion: nil)
            
        default:
            print("err")
        }
    }
    
    func userLogout(){
        
        //토큰 저장
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let Auth_header = ["Authorization":"Token "+appDelegate.token]
        
        //데이터 가져오는 부분
        Alamofire.request("http://192.168.0.10:8001/local_auth/logout/", method: .post, encoding: JSONEncoding.default, headers: Auth_header)
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                return .success
            }
            .responseJSON { response in
                debugPrint(response)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

}
