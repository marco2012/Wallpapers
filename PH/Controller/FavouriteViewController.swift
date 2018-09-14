//
//  FavouriteViewController.swift
//  PH
//
//  Created by Marco on 30/08/2018.
//  Copyright © 2018 Vikings. All rights reserved.
//

import UIKit

//class FavouriteViewController: UIViewController,
//    UICollectionViewDataSource , UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIViewControllerPreviewingDelegate {
//
//    //variables
//    @IBOutlet weak var collectionView: UICollectionView!
//    @IBOutlet weak var layout: UICollectionViewFlowLayout!
//    @IBOutlet weak var albumCountLabel: UILabel!
//    @IBOutlet weak var typeSegment: UISegmentedControl!
//
//    //loading indicator bottom
//    var footerView:CustomFooterView?
//    var isLoading:Bool = false
//    let footerViewReuseIdentifier = "RefreshFooterView"
//
//    let theme = ThemeManager.currentTheme()
//
//    var albums : [Album]!
//    var pornpics_pictures : [Pic]!
//    var videos : [Video]!
//    var pics_source = UserDefaults.standard.string(forKey: "pics_source")
//
//    //viewDidLoad
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        initView()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        var favouriteVideos = [Video]()
//        if let data = UserDefaults.standard.data(forKey: "favouritesVideos"),
//            let decodedVideos = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Video] {
//            favouriteVideos = decodedVideos
//        }
//        videos = Array(Set(favouriteVideos)) //remove duplicates
//        collectionView.reloadData()
//
//
//        var favouriteAlbums = [Album]()
//        if let data = UserDefaults.standard.data(forKey: "favourites"),
//            let decodedAlbums = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Album] {
//            favouriteAlbums = decodedAlbums
//        }
//        albums = Array(Set(favouriteAlbums)) //remove duplicates
//        collectionView.reloadData()
//
//
//        var favouritePictures = [Pic]()
//        if let data = UserDefaults.standard.data(forKey: "favouritesPictures"),
//        let decodedPictures = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Pic] {
//        favouritePictures = decodedPictures
//        }
//        pornpics_pictures = Array(Set(favouritePictures)) //remove duplicates
//        collectionView.reloadData()
//
//    }
//
//    //MARK initialization
//    private func initView(){
//        self.view.backgroundColor = theme.backgroundColor
//        self.albumCountLabel.textColor = UIColor.white
//
//        albums = [Album]()
//        pornpics_pictures = [Pic]()
//        videos = [Video]()
//
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.alwaysBounceVertical = true
//
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 0
//
//        //3D touch
//        if(traitCollection.forceTouchCapability == .available){
//            registerForPreviewing(with: self, sourceView: view)
//        }
//    }
//
//    @IBAction func typeSegmentChanged(_ sender: UISegmentedControl) {
//        collectionView.reloadData()
//    }
//
//    //CollectionView
//    // Two columns
//    // https://stackoverflow.com/a/49574408/1440037
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let orientation = UIApplication.shared.statusBarOrientation
//        if(orientation == .landscapeLeft || orientation == .landscapeRight){
//            return CGSize(width: (collectionView.frame.size.width-10)/2, height: (collectionView.frame.size.height-10)/2)
//        } else{
//            return CGSize(width: (collectionView.frame.size.width-5)/2, height:  (collectionView.frame.size.height-10)/3)
//        }
//
//    }
//
//    //collectionView
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        switch typeSegment.selectedSegmentIndex {
//        case 0:
//            return videos.count
//        case 1:
//            return albums.count
//        case 2:
//            return pornpics_pictures.count
//        default:
//            return videos.count
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath as IndexPath as IndexPath) as! HomeCollectionViewCell
//
//        switch typeSegment.selectedSegmentIndex {
//        case 0:
//            let video = videos[indexPath.row]
//            cell.titleLabel.text = video.title
//            cell.countLabel.text = "\(video.duration) min"
//            cell.coverImageView.kf.setImage(with: URL(string: video.default_thumb))
//        case 1:
//            let album = albums[indexPath.row]
//            cell.titleLabel.text = album.title
//            cell.countLabel.text = "\(album.imgCount ?? 0) pics / \(album.viewCount ?? 0) views"
//            cell.coverImageView.kf.setImage(with: URL(string: album.urlThumbnail))
//        case 2:
//            let picture = pornpics_pictures[indexPath.row]
//            cell.titleLabel.text = picture.pic_description
//            cell.countLabel.text = ""
//            cell.coverImageView.kf.setImage(with: URL(string: picture.thumbnail_small))
//        default:
//            break
//        }
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if typeSegment.selectedSegmentIndex == 0 {
//            performSegue(withIdentifier: "favouritesVideoSegue", sender: self)
//        } else {
//            performSegue(withIdentifier: "favouritesSegue", sender: self)
//        }
//    }
//
//
//    // segue
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if segue.identifier == "favouritesVideoSegue" {
//            if let indexPath = self.collectionView.indexPathsForSelectedItems?.first {
//                let controller = segue.destination as! PlayerViewController
//                let thisVideo = self.videos![indexPath.row] as Video
//                controller.video = thisVideo
//            }
//        }
//
//        if  segue.identifier == "favouritesSegue" {
//            if typeSegment.selectedSegmentIndex==1 {
//                if let indexPath = self.collectionView.indexPathsForSelectedItems?.first {
//                    let controller = segue.destination as! DetailsViewController
//                    let thisAlbum = self.albums[indexPath.row] as Album
//                    controller.album = thisAlbum
//                    controller.pics_source = "pornhub" //TODO
//                }
//            } else if typeSegment.selectedSegmentIndex==2 {
//                if let indexPath = self.collectionView.indexPathsForSelectedItems?.first {
//                    let controller = segue.destination as! DetailsViewController
//                    let thisPicture = self.pornpics_pictures[indexPath.row] as Pic
//                    controller.picture = thisPicture
//                    controller.pics_source = "pornpics" //TODO
//                }
//            }
//
//        }
//
//    }
//
//    //3D touch
//    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
//        guard let indexPath = collectionView?.indexPathForItem(at: location) else { return nil }
//        guard let cell = collectionView?.cellForItem(at: indexPath) else { return nil }
//        guard let detailsVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailsViewController else { return nil }
//        let thisAlbum = self.albums![indexPath.row] as Album
//        detailsVC.album = thisAlbum
//        detailsVC.preferredContentSize = CGSize(width: 0.0, height: 300)
//        previewingContext.sourceRect = cell.frame
//        return detailsVC
//    }
//
//    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
//        show(viewControllerToCommit, sender: self)
//    }
//}
