//
//  SecondPageVC.swift
//  TheWeather2
//
//  Created by 鄭羽辰 on 2018/11/20.
//  Copyright © 2018 鄭羽辰. All rights reserved.
//

import UIKit
//以下為海溫氣溫浪高資料
struct ShowData{
    var temp:String?
    var seaTemp:String?
    var waveHeight:String?
}

struct AllData:Decodable{
    var records:secondData?
}
struct secondData:Decodable{
    var location:[thirdData]?
}
struct thirdData:Decodable{
    var stationId:String?
    var time:[forthData]?
}
struct forthData:Decodable{
    var obsTime:String?
    var weatherElement:[usefulData]?
}
struct usefulData:Decodable{
    var elementName:String?
    var elementValue:String?
}

//以下為紫外線資料結構
struct ShowUVIData{
    var H_UVI:String?
}

struct UVIAllData:Decodable{
    var records:UVISecondData?
}

struct UVISecondData:Decodable{
    var location:[UVIThirdData]?
}

struct UVIThirdData:Decodable{
    var lat:String?
    var lon:String?
    var locationName:String?
    var stationId:String?
    var time:UVIForthData?
    var weatherElement:[UVIForthData]?
    var parameter:[UVIForthData]?
}

struct UVIForthData:Decodable{
    var obsTime:String?
    var parameterName:String?
    var parameterValue:String?
    var elementName:String?
    var elementValue:String?
}

var refreshControl:UIRefreshControl!

class SecondPageVC: UIViewController,LocationIntSend {

    var session:URLSession?
    var UVIsession:URLSession?
    var isDownloading = false
    var locationStringFromViewOne:String?
    var UVILocationStringFromViewOne:String?
    
    @IBAction func secondPageBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion:nil)
    }

   
    @IBOutlet weak var UVIRecentTimeLabel: UILabel!
    @IBOutlet weak var recentTimeLabel: UILabel!
    @IBOutlet weak var secondPageActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var seaTempLabel: UILabel!
    @IBOutlet weak var waveHeightLabel: UILabel!
    @IBOutlet weak var UVILabel: UILabel!
    @IBOutlet weak var UVIMeansLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UVIMeansLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        UVIMeansLabel.numberOfLines = 0
        /*
        refreshControl = UIRefreshControl()
        self.view.addSubview(refreshControl)
 */
 // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//拿到海溫氣溫與浪高資料函式
    func GetData(location:String){
        secondPageActivityIndicator.startAnimating()
        session = URLSession(configuration: .default)
        let apiAddress = "https://opendata.cwb.gov.tw/api/v1/rest/datastore/O-A0018-001?Authorization=CWB-956FEFAA-E994-407E-89C1-572414FDCA15&elementName=%E6%B0%A3%E6%BA%AB,%E6%B5%B7%E6%BA%AB,%E6%B5%AA%E9%AB%98&sort=obsTime"
        if let apiURL = URL(string: apiAddress){
            print("url works")
            let task = session?.dataTask(with: apiURL, completionHandler: { (data, response, error) in
                if error != nil{
                    //Unfinsh:Can change popalert
                    let errorCode = (error! as NSError).code
                    if errorCode == -1009{
                        DispatchQueue.main.async{
                            self.PopAlert(withTitle:"No Internet Connection")
                          print("No Internet Connection!")
                        }
                    }else{
                        DispatchQueue.main.async{
                            self.PopAlert(withTitle:"Sorry")
                        }
                        print(error!.localizedDescription)
                    }
                    self.isDownloading = false
                    return
                }
                if let loadedData = data{
                    do{
                        print("Have Data")
                        let OkData = try JSONDecoder().decode(AllData.self, from: loadedData)
                        
                        //抓出位置代號在陣列的所在位置
                        var index:Int = 0
                        //抓下全部的stationId存入locations陣列中
                        var locations = [String]()
                        while index < OkData.records?.location?.count ?? 1{
                            locations.append((OkData.records?.location![index].stationId)!)
                            index += 1
                            //Notice that warning : index out of range
                        }
                        print(locations)
                            //找出時間陣列裡，最後一個元素（已升冪排序）
                            if let locationIndex:Int = locations.index(of: location){
                                if let timeCount:Int = (OkData.records?.location![locationIndex].time?.count){
                                    
                                    let timeIndex = timeCount-1
                                    let recentObsTime = OkData.records?.location![locationIndex].time![timeIndex].obsTime
                                    DispatchQueue.main.async{
                                        self.recentTimeLabel.text = recentObsTime
                                        self.secondPageActivityIndicator.stopAnimating()
                                    }
                                    print("Recent Time: \(recentObsTime ?? "No Time Data")" )
                                    
                                    if let temp = OkData.records?.location?[locationIndex].time?[timeIndex].weatherElement?[0].elementValue{
                                        let realTemp = Double(temp)!/10
                                        DispatchQueue.main.async{
                                            self.tempLabel.text = String(realTemp) + " ℃"
                                            self.secondPageActivityIndicator.stopAnimating()
                                        }
                                        print("Temp : \(Double(temp)!/10)")
                                    }else{
                                        print("No Temp Data")
                                        self.isDownloading = false
                                        DispatchQueue.main.async{
                                            self.tempLabel.text = "No Data"
                                            self.secondPageActivityIndicator.stopAnimating()
                                        }
                                    }
                                    
                                    
                                    if let seaTemp = OkData.records?.location?[locationIndex].time?[timeIndex].weatherElement?[1].elementValue{
                                        let realSeaTemp = Double(seaTemp)!/10
                                        DispatchQueue.main.async{
                                            self.seaTempLabel.text = String(realSeaTemp) + " ℃"
                                            self.secondPageActivityIndicator.stopAnimating()
                                        }
                                        print("Sea Temp： \(Double(seaTemp)!/10)")
                                    }else{
                                        print("No Sea Temp Data")
                                        self.isDownloading = false
                                        DispatchQueue.main.async{
                                            self.seaTempLabel.text = "No Data"
                                            self.secondPageActivityIndicator.stopAnimating()
                                        }
                                    }
                                    
                                    
                                    if let waveHeight = OkData.records?.location?[locationIndex].time?[timeIndex].weatherElement?[2].elementValue{
                                        let realWaveHeight = Double(waveHeight)!/10
                                        DispatchQueue.main.async{
                                            self.waveHeightLabel.text = String(realWaveHeight) + " cm"
                                            self.secondPageActivityIndicator.stopAnimating()
                                        }
                                        print("Wave Height： \(Double(waveHeight)!/10)")
                                    }else{
                                        print("No WaveHeight Data")
                                        self.isDownloading = false
                                        DispatchQueue.main.async{
                                            self.waveHeightLabel.text = "No Data"
                                            self.secondPageActivityIndicator.stopAnimating()
                                        }
                                    }
                                }
                            }
                        self.isDownloading = false
                    }catch{
                        DispatchQueue.main.async{
                            self.PopAlert(withTitle:"Sorry")
                        }
                        print(error.localizedDescription)
                        self.isDownloading = false
                    }
                    
                }else{
                    self.isDownloading = false
                }
                //Unfinsh:如果沒有錯誤要做的事情
            })
            task?.resume()
            isDownloading = true
        }
    }
//拿到紫外線指數函式
    func GetUVI(location:String){   //Catch UIV Data
        UVIsession = URLSession(configuration: .default)
        let apiAddress = "https://opendata.cwb.gov.tw/api/v1/rest/datastore/O-A0003-001?Authorization=CWB-956FEFAA-E994-407E-89C1-572414FDCA15"
        if let apiURL = URL(string: apiAddress){
            let UIVtask = session?.dataTask(with: apiURL, completionHandler: { (data, response, error) in
                if error != nil{
                    let errorCode = (error! as NSError).code
                    if errorCode == -1009{
                        DispatchQueue.main.async{
                            self.PopAlert(withTitle:"No Internet Connection")
                            print("No Internet Connection!")
                        }
                    }else{
                        print(error!.localizedDescription)
                        self.PopAlert(withTitle:"Sorry")
                    }
                    self.isDownloading = false
                    return
                }
                if let UVIloadedData = data{
                    do{
                        let OkUVIData = try JSONDecoder().decode(UVIAllData.self, from: UVIloadedData)
                        
                        //抓出位置代號在陣列的所在位置
                        var index:Int = 0
                        //下全部的stationId存入locations陣列中
                        var UIVlocations = [String]()
                        while index < 44{
                            UIVlocations.append((OkUVIData.records?.location![index].stationId)!)
                            index += 1
                            //Notice that warning : index out of range
                        }
                        //print("UVI Location Names: \(UIVlocations)")
                        
                        //下載的所有元素資料名稱
                        var eleIndex:Int = 0
                        var elementNames = [String]()
                        while eleIndex < 20{
                            elementNames.append((OkUVIData.records?.location![0].weatherElement![eleIndex].elementName)!)
                            eleIndex += 1
                            //Notice that warning : index out of range
                        }
                        //print("UVI Data Elements: \(elementNames)")
                        if let locationIndex:Int = UIVlocations.index(of: location){
                                //print(locationIndex)
                            if let H_UVIIndex:Int = elementNames.index(of: "H_UVI"){
                                print(H_UVIIndex)
                                if let UVIValue = OkUVIData.records?.location![locationIndex].weatherElement![H_UVIIndex].elementValue,let UVIValueCheck = Double(UVIValue){
                                    print("UVI Location: \(String(describing: OkUVIData.records?.location![locationIndex].locationName))")
                                    print("UVI： \(UVIValue)")
                                    
                                    if UVIValueCheck == 0 {
                                        DispatchQueue.main.async{
                                            self.UVILabel.text = String(UVIValue)
                                            self.UVIMeansLabel.text = ""
                                        }
                                    }else if UVIValueCheck > 0{
                                        DispatchQueue.main.async{
                                            self.UVILabel.text = String(UVIValue)
                                        }
                                        if UVIValueCheck<=2 && UVIValueCheck>0 {
                                        DispatchQueue.main.async{
                                            self.UVIMeansLabel.text = "低量級"
                                        }
                                        }else if UVIValueCheck>2 && UVIValueCheck<=5{
                                        DispatchQueue.main.async{
                                            self.UVIMeansLabel.text = "中量級\n佩戴太陽鏡及使用防曬霜，中午陽光強烈時尋找遮蔽處"
                                            self.UVIMeansLabel.textColor = UIColor.yellow
                                        }
                                        }else if UVIValueCheck>5 && UVIValueCheck<=7{
                                        DispatchQueue.main.async{
                                            self.UVIMeansLabel.text = "高量級\n佩戴太陽鏡使用SPF大於15的防曬霜，保護皮膚減少暴露"
                                            self.UVIMeansLabel.textColor = UIColor.red
                                        }
                                        }else if UVIValueCheck>7 && UVIValueCheck<=10{
                                        DispatchQueue.main.async{
                                            self.UVIMeansLabel.text = "過量級\n佩戴太陽鏡使用SPF大於15的防曬霜，暴露的皮膚會快速灼傷"
                                            self.UVIMeansLabel.textColor = UIColor.red
                                        }
                                        }else{
                                        DispatchQueue.main.async{
                                            self.UVIMeansLabel.text = "危險級\n躲避陽光"
                                            self.UVIMeansLabel.textColor = UIColor.purple
                                        }
                                        }
 
                                }else if UVIValueCheck < 0{
                                        DispatchQueue.main.async{
                                            self.UVILabel.text = "Wrong Data"
                                            self.UVIMeansLabel.text = "資料數值異常"
                                            self.UVIMeansLabel.textColor = UIColor.gray
                                        }
                                    }
                                }else{
                                    print("No UVI Data")
                                    self.isDownloading = false
                                    DispatchQueue.main.async{
                                        self.UVILabel.text = "No Data"
                                    }
                                }
                            
                        }
                        if let UVIObsTime = OkUVIData.records?.location![0].time?.obsTime{
                            DispatchQueue.main.async{
                                self.UVIRecentTimeLabel.text = String(UVIObsTime)
                            }
                        }
                        }
                        self.isDownloading = false
                    }catch{
                        DispatchQueue.main.async{
                            self.PopAlert(withTitle:"Sorry")
                        }
                        print(error.localizedDescription)
                        self.isDownloading = false
                    }
                    
                }//Unfinsh:如果沒有錯誤要做的事情
            })
            UIVtask?.resume()
            self.isDownloading = true
        }else{
            self.isDownloading = false
        }
        
        
    }
    func PopAlert(withTitle:String){
        let myAlert = UIAlertController(title: withTitle, message: "Please Check it!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        myAlert.addAction(okAction)
        present(myAlert, animated: true, completion: nil)
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
