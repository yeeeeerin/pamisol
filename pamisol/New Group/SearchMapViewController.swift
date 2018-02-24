//
//  SearchMapViewController.swift
//  pamisol
//
//  Created by 이예린 on 2018. 2. 17..
//  Copyright © 2018년 Yerin. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import AlamofireImage
import Alamofire

class SearchMapViewController: UIViewController,CLLocationManagerDelegate {
    
    let locationManager: CLLocationManager = CLLocationManager()
    
    @IBOutlet var mapView: MKMapView!
    var coordinate: CLLocationCoordinate2D!
    
    var lat:Double = 0.0
    var long:Double = 0.0
    
    var datas:[[String:Any]] = []
    
    var pin:[SearchMapPin] = []
    
    @IBOutlet var collectionview: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        //위치관련
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .restricted {
                let alert = UIAlertController(title: "오류 발생",
                                              message: "위치서비스 기능이 꺼져있음", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
            }
            else {
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
            }
        }
        else {
            let alert = UIAlertController(title: "오류 발생", message: "위치서비스 제공 불가",
                                          preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
        }
        
        self.locationManager.startUpdatingLocation()
        self.locationManager.stopUpdatingLocation()
        
        getSearchData()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 가장 최근의 위치 값
        let location: CLLocation = locations[locations.count-1]
        
        print(String(format: "%.6f", location.coordinate.latitude))
        
        self.lat = location.coordinate.latitude
        self.long = location.coordinate.longitude
        
        
        //지도에 뿌려줄 위치값
        self.coordinate = CLLocationCoordinate2D()
        self.coordinate.longitude = 127.1113874
        self.coordinate.latitude = 37.3969995
        
        mapView.setRegion(MKCoordinateRegionMake((self.coordinate),MKCoordinateSpanMake(0.007, 0.007)), animated: true)
        
        
        //latitude.text = String(format: "%.6f", location.coordinate.latitude)
        //latitudeAccuracy.text = String(format: "%.6f", location.horizontalAccuracy)
        //longitude.text = String(format: "%.6f", location.coordinate.longitude)
        //longitudeAccuracy.text = String(format: "%.6f", location.verticalAccuracy)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addAnocation() {
        
        for data in self.datas{
            var co: CLLocationCoordinate2D = CLLocationCoordinate2D()
            co.longitude = data["longitude"] as! Double
            co.latitude = data["latitude"] as! Double
            self.pin.append(SearchMapPin(coordinate: co, title: data["name"] as! String))
        }
        self.mapView.addAnnotations(self.pin)
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        
        let cell = sender as! MSVStoreCell
    
        let detailVC = segue.destination as! StorePageViewController
        let pk:Int = cell.pk
        
        detailVC.storePK = pk
    }

}

//통신관련
extension SearchMapViewController{
    func getSearchData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let Auth_header = ["Authorization":"Token "+appDelegate.token]

        let fullUrl:String = appDelegate.basicURL + ":8003/map/" + String(format:"%f", 37.394798) + "/" + String(format:"%f", 127.111349) + "/"
            //appDelegate.basicURL + ":8003/map/" + String(describing: lat) + "/" + String(describing: long) + "/"
        
        print("위도 경도")
        print(String(format:"%f", lat))
        
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
                        if let result = JSON["results"] as? [[String:Any]]{
                            self.datas = result
                        }
                    }
                    self.collectionview.reloadData()
                    
                    self.addAnocation()
                    
                    
                case .failure(_):
                    print("fail")
                    
                }
        }

    }
    
}



//콜랙션 뷰 관련
extension SearchMapViewController:UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !datas.isEmpty {
            return datas.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Store Cell",for:indexPath) as! MSVStoreCell
        
        if !datas.isEmpty{
            
            
            cell.layer.borderColor = UIColor.gray.cgColor
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 7
            cell.layer.masksToBounds = true
            
            let data = datas[indexPath.row]
            cell.title.text = data["name"] as? String
            cell.info.text = data["description"] as? String
            cell.category.text = data["phone"] as? String
            
            cell.pk = data["pk"] as! Int
            
            //image
            let imgUrl:String = data["image"] as! String
            print(imgUrl)
            var img:UIImage!
            
            Alamofire.request(imgUrl, method: .get).responseImage { response in
                switch response.result {
                case .success(let image):
                    img = image
                    cell.image.image = img
                    //self.collectionview.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, selectedItemIndex: NSIndexPath) {
        let cell = collectionview.cellForItem(at: selectedItemIndex as IndexPath)
        self.performSegue(withIdentifier: "Search To Store", sender: cell)
    }
    
    
}


