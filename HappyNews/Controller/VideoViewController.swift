//
//  VideoViewController.swift
//  HappyNews
//
//  Created by lanou on 16/3/25.
//  Copyright © 2016年 corporal. All rights reserved.
//

import UIKit

import MediaPlayer

import Alamofire

import AVKit

class VideoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    var tableview:UITableView!
    var mediaArrayer:NSMutableArray! // 存放原始数据的数组
    
    var mediaArray:NSMutableArray!   // 存放model的数组

    var refreshControl:UIRefreshControl!
    var activiLoading:UIActivityIndicatorView!
    
    var mediaPlayer = AVPlayerViewController()
    var Player = AVPlayer()
//    var playerLayer = AVPlayerLayer()
    
    var currentRow:Int! // 记录点击的行数
    
    // 加载视频的背景
    var backmovieplayer = UIImageView()
    
    var notificationcenter = NSNotificationCenter()
    
    // 视频url转码
    var urlStr:NSString!
    var urlString:NSString!
    var url:NSURL!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false;
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.tableview = UITableView(frame: CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64), style: UITableViewStyle.Plain)
        
        self.tableview.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.tableview)
        tableview.registerClass(MediaCell.self, forCellReuseIdentifier: "video")
        
        
        self.tableview.tableFooterView = UIView()
        self.mediaArray = NSMutableArray()
        
        activiLoading = UIActivityIndicatorView()
        activiLoading.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "松开后自动刷新")
        
        
        refreshData()
        
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
        // 监听屏幕改变
        let device = UIDevice.currentDevice()
        device.beginGeneratingDeviceOrientationNotifications()
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: Selector("orientationChanged"), name: UIDeviceOrientationDidChangeNotification, object: device)
    
    }
    
    // 屏幕改变
    func orientationChanged(){
        
        let state = UIDevice.currentDevice().orientation
        switch (state) {
        case UIDeviceOrientation.Portrait:
            print("屏幕变正")
        up()
            
        case UIDeviceOrientation.PortraitUpsideDown:
            print("屏幕向下")
            
        case UIDeviceOrientation.LandscapeLeft:
            print("屏幕变左")
        UIApplication.sharedApplication().setStatusBarOrientation(UIInterfaceOrientation.LandscapeRight, animated: true)
        left()
            
        case UIDeviceOrientation.LandscapeRight:
            print("屏幕变右")
        UIApplication.sharedApplication().setStatusBarOrientation(UIInterfaceOrientation.LandscapeRight, animated: true)
        right()
            
            
        default:
            break
            
        }
        
    }
    
    func up(){
        if (self.mediaPlayer.player != nil){
            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
            
            UIView.animateKeyframesWithDuration(0.3, delay: 0, options: UIViewKeyframeAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                
                self.mediaPlayer.view.transform = CGAffineTransformIdentity
                self.mediaPlayer.view.frame = CGRectMake(10, CGFloat(self.currentRow) * 280 + 20, kScreenWidth - 20, 210)
                
                self.tableview.addSubview(self.mediaPlayer.view)
                
                }, completion: { (Bool) -> Void in
                    
                    
            })
            
            
        }
        
        
        
    }
    
    func right(){
        
        if (self.mediaPlayer.player != nil) {
            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
            
            UIView.animateKeyframesWithDuration(0.3, delay: 0, options: UIViewKeyframeAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                self.mediaPlayer.view.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
                
                self.mediaPlayer.view.frame = CGRectMake(0, 0, kscreenWidth, kscreenHeight)
                
                let window = UIApplication.sharedApplication().delegate?.window!!
                
                window?.addSubview(self.mediaPlayer.view)
                
                }, completion: { (Bool) -> Void in
                    
            })
            
        }
        
        
    }
    
    
    func left(){
        if (self.mediaPlayer.player != nil) {
            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
            
            UIView.animateKeyframesWithDuration(0.3, delay: 0, options: UIViewKeyframeAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                self.mediaPlayer.view.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
                
                self.mediaPlayer.view.frame = CGRectMake(0, 0, kscreenWidth, kscreenHeight)
                
                let window = UIApplication.sharedApplication().delegate?.window!!
                
                window?.addSubview(self.mediaPlayer.view)
                
                }, completion: { (Bool) -> Void in
                    
            })
            
        }
        
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    // 支持横竖屏显示
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        
        return UIInterfaceOrientationMask.All
    }
    
    func refreshData(){
        Alamofire.request(.GET, "http://c.3g.163.com/nc/video/list/V9LG4B3A0/y/0-5.html").responseJSON(){
            response in
            if response.result.isSuccess {
                
//                print("____\(response)")
                self.mediaArrayer = response.result.value?.objectForKey("V9LG4B3A0") as! NSMutableArray
//                print("____\(self.mediaArrayer)")
            
                for i in 0..<self.mediaArrayer.count{
                    
                    let mediaModel = MediaModel()
                    
                    mediaModel.setValueMoel(self.mediaArrayer[i] as! NSDictionary)
                    
                    self.mediaArray.addObject(mediaModel)
                    
                }
               self.tableview.reloadData()
//                print(self.mediaArray.count)
            }
            
            
            else
            {
                print("___\(response.result.error)")
            }
            
        }
        
        
    }
    
  
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 280
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCellWithIdentifier("video", forIndexPath: indexPath) as! MediaCell
        
        let model = self.mediaArray[indexPath.row] as! MediaModel
        cell.selectionStyle=UITableViewCellSelectionStyle.None
//        cell.btnimage.kf_setImageWithURL(NSURL(string: model.imageName)!, placeholderImage: Image(named: "1"))
       
        
        cell.btnimage.sd_setImageWithURL(NSURL(string: model.cover)!, placeholderImage: UIImage(named: "night_sidebar_cellhighlighted_bg@2x"))
        
        cell.Labeltitle.text = model.title;
        cell.playcountLabel.text = String(model.playCount)
        var second = String()
        if model.length % 60 < 10 {
            second = "0" + String(model.length % 60)
        }
        else{
            second = String(model.length % 60)
        }
        cell.playtimeLabel.text="\(model.length / 60):\(second)";
        
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return self.mediaArray.count

    
    }
    
    
    // 当cell滑出可见区域时
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
    
        print("滑出可见区域~(≧▽≦)~啦啦啦")
        self.mediaPlayer.player?.pause()
        self.mediaPlayer.view.removeFromSuperview()
        self.mediaPlayer.player == nil
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.mediaPlayer.player != nil
        {
            self.mediaPlayer.view.removeFromSuperview()
        
        }
        
        let model = self.mediaArray[indexPath.row] as! MediaModel
        urlStr = model.mp4_url
        urlString = urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        url = NSURL(string: String(urlString))
        
        
        Player = AVPlayer(URL: url)
        mediaPlayer.player = Player
        
        self.currentRow = indexPath.row
        
        mediaPlayer.view.autoresizingMask = UIViewAutoresizing.None
        mediaPlayer.view.frame = CGRectMake(10, CGFloat(indexPath.row) * 280 + 20, view.frame.size.width - 20, 210)
        activiLoading.frame = CGRectMake(mediaPlayer.view.bounds.width / 2 - 18.5, mediaPlayer.view.bounds.height / 2 - 18.5, 37, 37)
        tableview.addSubview(mediaPlayer.view)
        backmovieplayer.frame = CGRectMake(0, 0, view.frame.size.width - 20, 210)
        backmovieplayer.image = UIImage(named: "night_sidebar_cellhighlighted_bg")
//        mediaPlayer.view.addSubview(backmovieplayer)
//        backmovieplayer.addSubview(activiLoading)
        addNotification()
//        activiLoading.startAnimating()
        self.mediaPlayer.player?.play()
    }
    
    func addNotification(){
        
//        self.notificationcenter = NSNotificationCenter.defaultCenter()
//        notificationcenter.addObserver(self, selector: Selector("mediaPlayerbackStateChange:"), name: MPMoviePlayerPlaybackStateDidChangeNotification, object: mediaPlayer)
//        notificationcenter.addObserver(self, selector: Selector("mediaPlayerPlayFinished:"), name: MPMoviePlayerPlaybackDidFinishNotification, object: mediaPlayer)
        
        
        
        
    }
    
    func mediaPlayerbackStateChange(notification: NSNotification){
        
        activiLoading.stopAnimating()
        backmovieplayer.removeFromSuperview()
        
        
            
            
        
        
        
    }
    
    
    func mediaPlayerPlayFinished(notification: NSNotification){
        
        
        
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
