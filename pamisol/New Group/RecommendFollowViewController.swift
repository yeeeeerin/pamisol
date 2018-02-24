//
//  RecommendFollowViewController.swift
//  pamisol
//
//  Created by 이예린 on 2018. 2. 9..
//  Copyright © 2018년 Yerin. All rights reserved.
//

import UIKit

class RecommendFollowViewController: UIViewController {
    
    @IBOutlet var tableview: UITableView!

    @IBOutlet var nextBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        recommendFollowUI()
        
    }
    
    func recommendFollowUI(){
        //nextbtn border + radius
        nextBtn.layer.borderWidth = 1
        nextBtn.layer.borderColor = UIColor(rgb: 0xDEDEDE).cgColor
        nextBtn.layer.cornerRadius = 5
        
        tableview.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension RecommendFollowViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Recommed Cell",for:indexPath) as! RecommendFollowCell
        //cell.storeBtn.isMultipleSelectionEnabled = true
        cell.id.text = "dddddd"
        return cell
    }
    
    
}
