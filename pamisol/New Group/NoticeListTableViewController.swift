//
//  NoticeListTableViewController.swift
//  pamisol
//
//  Created by 이예린 on 2018. 2. 19..
//  Copyright © 2018년 Yerin. All rights reserved.
//

import UIKit
import TimelineTableViewCell
import Alamofire
import AlamofireImage
import Foundation

class NoticeListTableViewController: UITableViewController {
    
    var storePK:Int!
    
    var results:[[String:Any]] = []
    
    var data:[Int: [(TimelinePoint, UIColor, String, String, String?, String?, String?)]] = [0:[]]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let bundle = Bundle(for: TimelineTableViewCell.self)
        let nibUrl = bundle.url(forResource: "TimelineTableViewCell", withExtension: "bundle")
        let timelineTableViewCellNib = UINib(nibName: "TimelineTableViewCell",bundle: Bundle(url: nibUrl!)!)
        tableView.register(timelineTableViewCellNib, forCellReuseIdentifier: "TimelineTableViewCell")
        
        getSearchData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return data.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let sectionData = data[section] else {
            return 0
        }
        return sectionData.count
    }

    /*
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(describing: section + 1) + "월"
    }
 */
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell", for: indexPath) as! TimelineTableViewCell
        
        // Configure the cell...
        guard let sectionData = data[indexPath.section] else {
            return cell
        }
        
        let (timelinePoint, timelineBackColor, title, description, lineInfo, thumbnail, illustration) = sectionData[indexPath.row]
        var timelineFrontColor = UIColor.clear
        if (indexPath.row > 0) {
            timelineFrontColor = sectionData[indexPath.row - 1].1
        }
        cell.timelinePoint = timelinePoint
        cell.timeline.frontColor = timelineFrontColor
        cell.timeline.backColor = timelineBackColor
        cell.titleLabel.text = title
        cell.descriptionLabel.text = description
        cell.lineInfoLabel.text = lineInfo
        
        if let thumbnail = thumbnail {
            cell.thumbnailImageView.image = UIImage(named: thumbnail)
        }
        else {
            cell.thumbnailImageView.image = nil
        }
        if let illustration = illustration {
            cell.illustrationImageView.image = UIImage(named: illustration)
        }
        else {
            cell.illustrationImageView.image = nil
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sectionData = data[indexPath.section] else {
            return
        }
        
        print(sectionData[indexPath.row])
    }
    


}

extension NoticeListTableViewController{
    
    func inputData(){
        if !results.isEmpty{
             for result in results{
                let title:String = result["title"] as! String
                let text:String = result["text"] as! String
                let date:String = result["created_at"] as! String
                self.data[0]?.append((TimelinePoint(diameter: 10.0,color: UIColor.black,filled: true), UIColor.black, title ,date+"\n\n"+text, nil, nil, "Sun"))
                self.tableView.reloadData()
             }
        }
 
    }
    
    
    func getSearchData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let Auth_header = ["Authorization":"Token "+appDelegate.token]
        
        let fullUrl:String = appDelegate.basicURL + ":8003/store/" + String(2) + "/notice/"
            //appDelegate.basicURL + ":8003/store/" + String(storePK) + "/notice/"

        //데이터 가져오는 부분
        Alamofire.request(fullUrl, method: .get, encoding: JSONEncoding.default, headers: Auth_header)
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                //print("!!validate!!")
                //debugPrint(response)
                return .success
            }
            .responseJSON { response in
                debugPrint(response)
                switch response.result {
                //성공일 때
                case .success( _):
                    if let JSON = response.result.value as? [String : Any] {
                        
                        self.results = (JSON["results"] as? [[String:Any]])!
                        self.inputData()
                        
                        
                    }
                case .failure(_):
                    print("fail")
                }
        }
    }
    
}
