//
//  ViewController.swift
//  FirebaseRealTimeDatabase
//
//  Created by mac on 22/05/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var tblView: UITableView!
    var arrData = NSMutableArray()
    @IBOutlet weak var btnNewFeeds: UIButton!
    @IBOutlet weak var adView: UIView!
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())

        adView.addSubview(bannerView)
        tblView.tableFooterView = UIView()
        
        ref.observe(.value) { (snapshot) in
            if !snapshot.exists() { return }
            print(snapshot)
            
            let count = self.arrData.count
            
            self.arrData = NSMutableArray()
            
            for i in (0..<snapshot.childrenCount).reversed() {
                
                if let text = snapshot.childSnapshot(forPath: "\(i)").value as? String {
                    self.arrData.add(text)
                }
            }
            
            self.tblView.reloadData()
            self.tblView.layoutIfNeeded()
            
            if count != self.arrData.count && (self.tblView.contentSize.height > self.tblView.frame.size.height) && count != 0 && self.tblView.contentOffset.y > 0 {
                self.btnNewFeeds.isHidden = false
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }        
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            btnNewFeeds.isHidden = true
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = arrData[indexPath.row] as? String
        cell.textLabel?.numberOfLines = 0
        
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = UIColor.white
        }
        else {
            cell.contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tblView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    @IBAction func actionNewFeeds(_ sender: Any) {
        tblView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: true)
        btnNewFeeds.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

