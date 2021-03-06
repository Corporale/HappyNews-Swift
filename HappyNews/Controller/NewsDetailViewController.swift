//
//  NewsDetailViewController.swift
//  HappyNews
//
//  Created by lanou on 16/3/29.
//  Copyright © 2016年 corporal. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {

    var model: NewsModel!
    var webview: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    self.view.backgroundColor = UIColor.yellowColor()
        
    webview = UIWebView(frame: self.view.bounds)
    
    let request = NSURLRequest(URL: NSURL(string: self.model.weburl)!)
        
    self.view.addSubview(webview)
    
    webview.loadRequest(request)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
