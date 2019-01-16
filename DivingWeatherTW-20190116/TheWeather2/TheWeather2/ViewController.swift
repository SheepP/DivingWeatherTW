//
//  ViewController.swift
//  TheWeather2
//
//  Created by 鄭羽辰 on 2018/11/20.
//  Copyright © 2018 鄭羽辰. All rights reserved.
//

import UIKit
protocol LocationIntSend{
    func GetData(location:String)
    func GetUVI(location:String)
}
let secondVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondPage") as! SecondPageVC


class ViewController: UIViewController {
var locationSendDelegate:LocationIntSend?

    //龍洞按鈕
    @IBAction func longDongButton(_ sender: UIButton) {
        present(secondVC, animated: true, completion: nil)
        self.locationSendDelegate = secondVC as LocationIntSend
        self.locationSendDelegate?.GetData(location: "46694A")
        self.locationSendDelegate?.GetUVI(location: "466940")
        secondVC.locationStringFromViewOne = "46694A"
        secondVC.UVILocationStringFromViewOne = "466940"
        ClearDataFieldText()
    }
    //蝙蝠洞按鈕
    @IBAction func bienFuDongButton(_ sender: UIButton) {
        present(secondVC, animated: true, completion: nil)
        self.locationSendDelegate = secondVC as LocationIntSend
        self.locationSendDelegate?.GetData(location: "COMC08")
        self.locationSendDelegate?.GetUVI(location: "466940")
        secondVC.locationStringFromViewOne = "COMC08"
        secondVC.UVILocationStringFromViewOne = "466940"
        ClearDataFieldText()
    }
    //蘇澳按鈕
    @IBAction func suAaoButton(_ sender: UIButton) {
        present(secondVC, animated: true, completion: nil)
        self.locationSendDelegate = secondVC as LocationIntSend
        self.locationSendDelegate?.GetData(location: "46706A")
        self.locationSendDelegate?.GetUVI(location: "467060")
        secondVC.locationStringFromViewOne = "46706A"
        secondVC.UVILocationStringFromViewOne = "467060"
        ClearDataFieldText()
    }
    //花蓮按鈕
    @IBAction func huaLianButton(_ sender: UIButton) {
        present(secondVC, animated: true, completion: nil)
        self.locationSendDelegate = secondVC as LocationIntSend
        self.locationSendDelegate?.GetData(location: "46699A")
        self.locationSendDelegate?.GetUVI(location: "466990")
        secondVC.locationStringFromViewOne = "46699A"
        secondVC.UVILocationStringFromViewOne = "466990"
        ClearDataFieldText()
    }
    //台東按鈕
    @IBAction func taiDongButton(_ sender: UIButton) {
        present(secondVC, animated: true, completion: nil)
        self.locationSendDelegate = secondVC as LocationIntSend
        self.locationSendDelegate?.GetData(location: "46761F")
        self.locationSendDelegate?.GetUVI(location: "467610")
        secondVC.locationStringFromViewOne = "46761F"
        secondVC.UVILocationStringFromViewOne = "467610"
        ClearDataFieldText()
    }
    //綠島按鈕
    @IBAction func lvDaoButton(_ sender: UIButton) {
        ButtonSet(location: "WRA007", UVILocation: "467660")
    }
    //墾丁按鈕
    @IBAction func kenTingButton(_ sender: UIButton) {
        ButtonSet(location: "46759A", UVILocation: "467590")
    }
    //小琉球按鈕
    @IBAction func liuQioButton(_ sender: UIButton) {
       ButtonSet(location: "46714D", UVILocation: "467440")
    }
    //澎湖按鈕
    @IBAction func pongHuButton(_ sender: UIButton) {
        ButtonSet(location: "46735A", UVILocation: "467350")
    }
    
    func ButtonSet(location:String,UVILocation:String){
        present(secondVC, animated: true, completion: nil)
        locationSendDelegate = secondVC as LocationIntSend
        locationSendDelegate?.GetData(location:location)
        locationSendDelegate?.GetUVI(location: UVILocation)
        secondVC.locationStringFromViewOne = location
        secondVC.UVILocationStringFromViewOne = UVILocation
        ClearDataFieldText()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
        // Dispose of any resources that can be recreated.
    }


}
func ClearDataFieldText(){
    secondVC.tempLabel.text = ""
    secondVC.seaTempLabel.text = ""
    secondVC.waveHeightLabel.text = ""
    secondVC.UVILabel.text = ""
    secondVC.UVIMeansLabel.text = ""
}


/*
 測站代碼,測站名稱,測站名稱(英文),測站經緯度,所屬單位
 46699A,[6],花蓮資料浮標, Hualien Buoy, 24°01'57"N,121°37'49"E, 中央氣象局,
 46694A,[4],龍洞資料浮標, Longdong Buoy, 25°05'48"N, 121°55'19"E,中央氣象局
 46714D,[11],小琉球資料浮標, Xiao Liuqiu Buoy22°18'58"N, , 120°21'41"E,中央氣象局
 46761F,[2],成功浮球,Cheng-Kung Wave Station, 23°7'57"N,121°25'12"E,中央氣象局
 46706A,[16],蘇澳資料浮標, Su-ao Buoy,24°37'29"N, 121°52'33"E,水利署
 46735A,[12],澎湖資料浮標, Penghu Buoy,23°43'37"N, 119°33'7"E,水利署
 46759A,[15],鵝鑾鼻資料浮標, Eluanbi Buoy, 21°54'08"N,120°49'22"E,水利署
 WRA007,[13],台東資料浮標, Taitung Buoy, 22°43'20"N, 121°08'24"E,水利署
 COMC08,[1], 彌陀資料浮標, Keelung Buoy,25°09'15"N, 121°47'06”E,水利署
 */

/*
 龍洞-龍洞資料浮標(46694A)-基隆(466940)
 蝙蝠洞公園-彌陀(COMC08)-基隆(466940)
 蘇澳-蘇澳(46706A)-蘇澳(467060)
 花蓮-花蓮(46699A)-花蓮(466990)
 台東成功-成功浮球(46761F)-成功(467610)
 綠島-台東(WRA007)-台東(467660)
 墾丁-鵝鑾鼻(46759A)-恆春(467590)
 小琉球-小琉球(46714D)-高雄(467440)
 澎湖群島-澎湖(46735A)-澎湖(467350)
*/

