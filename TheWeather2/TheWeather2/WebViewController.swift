//
//  WebViewController.swift
//  TheWeather2
//
//  Created by 鄭羽辰 on 2019/1/16.
//  Copyright © 2019 鄭羽辰. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController,WKNavigationDelegate {

    @IBOutlet weak var webActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var myWebView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        myWebView.navigationDelegate = self
            if let url = URL(string: "https://www.cwb.gov.tw/V8/"){
            let request = URLRequest(url: url)
            myWebView.load(request)
            
        }
        // Do any additional setup after loading the view.
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        webActivityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webActivityIndicator.stopAnimating()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
