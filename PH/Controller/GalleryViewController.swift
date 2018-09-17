//
//  GalleryViewController.swift
//  ParallaxCells
//
//  Created by Marco on 13/09/2018.
//  Copyright © 2018 Rocko Labs. All rights reserved.
//

import UIKit
import Kingfisher

class GalleryViewController: UIViewController {
    
    @IBOutlet var myView: UIView!
    @IBOutlet weak var myImageView: UIImageView!
    
    var wallpaper:Wallpaper?
    var link:String?
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0) // define a variable to store initial touch position
    var image : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalPresentationCapturesStatusBarAppearance = true //hide statusbar
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(gesture:)))
        myView.addGestureRecognizer(longPressRecognizer)
        
        let p = Bundle.main.path(forResource: "loader", ofType: "gif")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: p))
        myImageView.kf.indicatorType = .image(imageData: data)
        
        link = API().getWallpaperLink(detail_link: (wallpaper?.detail_link)!)
        myImageView.kf.setImage(with: URL(string: link!), options: [.transition(.fade(0.2))])

        let imageUrl = URL(string: self.link!)
        let imageData = try! Data(contentsOf: imageUrl!)
        image = UIImage(data: imageData)
        
    }
    
    // https://medium.com/@qbo/dismiss-viewcontrollers-presented-modally-using-swipe-down-923cfa9d22f4
    @IBAction func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view?.window)
        if sender.state == UIGestureRecognizer.State.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizer.State.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }
    
    @objc func dismissView(gesture: UISwipeGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func longPressed(gesture: UILongPressGestureRecognizer){
        //downloadWallpaper()
        shareImage()
    }
    
    @IBAction func buttonPress(_ sender: UIButton) {
        //downloadWallpaper()
        shareImage()
    }
    
    // https://stackoverflow.com/a/35931947/1440037
    func shareImage(){

        // set up activity view controller
        let imageToShare = [ image! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func downloadWallpaper(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let yes = UIAlertAction(title: "Download", style: .default , handler:{ (UIAlertAction) in
            let imageUrl = URL(string: self.link!)
            let imageData = try! Data(contentsOf: imageUrl!)
            let image = UIImage(data: imageData)
            UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil);
            self.alert(message: "Saved to Photos")
        })
        alert.addAction(yes)
        
        let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    //hide statusbar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
