//
//  ViewController.swift
//  PH
//
//  Created by Marco on 18/08/2018.
//  Copyright © 2018 Vikings. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController,
    UICollectionViewDataSource , UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIViewControllerPreviewingDelegate,
    UISearchBarDelegate,
    UIActionSheetDelegate {
    
    //variables
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    //ricerca
    var resultSearchController: UISearchController?

    //loading indicator bottom
    var footerView:CustomFooterView?
    var isLoading:Bool = false
    let footerViewReuseIdentifier = "RefreshFooterView"
    var category = "Babe" //babe
    
    let theme = ThemeManager.currentTheme()
    
    var wallpapers : [Wallpaper]!
    var nav_title = "Wallpapers"
    var page = 1 //aumenta di 1
    var LOADER_HEIGHT:CGFloat = 60
    var PULLHEIGHT:CGFloat = 0.0
    let progressHUD = ProgressHUD(text: "Loading")
    let api = API()
    
     //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        refresh(clearArray: true)
    }

    // invia richiesta al server e aggiorna collectionView
    func refresh(clearArray:Bool = false){
        progressHUD.show()
//        if (resultSearchController?.isActive)! {
//            //let scopes = resultSearchController!.searchBar.scopeButtonTitles
//            //let currentScope = scopes![resultSearchController!.searchBar.selectedScopeButtonIndex] as String
//            self.filtraContenuti(testoCercato: (resultSearchController?.searchBar.text!)!, clearArray:false)
//        } else
        if clearArray {
            wallpapers = api.getWallpapers(page: page)
        } else {
            page += 1
            wallpapers += api.getWallpapers(page: page)
        }
        progressHUD.hide()
        collectionView.reloadData()
    }
    
    
    //MARK initialization
    private func initView(){
        
        self.view.backgroundColor = theme.backgroundColor
        
        wallpapers = [Wallpaper]()
        collectionView.delegate = self
        collectionView.dataSource = self
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        self.view.addSubview(progressHUD)
        progressHUD.backgroundColor = theme.backgroundColor
        progressHUD.tintColor = theme.tintColor
        progressHUD.hide()
        
        //3D touch
        if(traitCollection.forceTouchCapability == .available){
            registerForPreviewing(with: self, sourceView: view)
        }
        
        self.collectionView.register(UINib(nibName: "CustomFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerViewReuseIdentifier)

        //Mark: search https://www.xcoding.it/creare-una-table-view-con-ricerca-in-swift/
//        self.resultSearchController = ({
//
//            let searchController = UISearchController(searchResultsController: nil)
//            navigationItem.searchController = searchController
//            navigationItem.hidesSearchBarWhenScrolling = true
//
//            // rimuove la tableView di sottofondo in modo da poter successivamente visualizzare gli elementi cercati
//            searchController.dimsBackgroundDuringPresentation = false
//
//            // aggiungo gli scope button alla Search Bar
//            //searchController.searchBar.scopeButtonTitles = ["Weekly", "Monthly", "All Time"]
//
//            //mantengo navigation bar (importante)
//            searchController.hidesNavigationBarDuringPresentation = true
//
//            self.definesPresentationContext = true
//
//            searchController.searchBar.tintColor = theme.tintColor
//
//            searchController.searchBar.delegate = self
//
//            // restituisco il controller creato
//            return searchController
//        })()
    }
    
    //MARK search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.filtraContenuti(testoCercato: searchBar.text!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if !(searchBar.text?.isEmpty)!{
            refresh(clearArray: true)
        }
    }
    
    private func filtraContenuti(testoCercato: String, clearArray:Bool = true) {
        print("cerco")
        
        
        progressHUD.show()
        if clearArray {
            
            } else {
            
            }
        

    }
    
    //CollectionView
    // Two columns
    // https://stackoverflow.com/a/49574408/1440037
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let orientation = UIApplication.shared.statusBarOrientation
        if(orientation == .landscapeLeft || orientation == .landscapeRight){
            return CGSize(width: (collectionView.frame.size.width-10)/3, height: (collectionView.frame.size.height-10)/2)
        } else{
            return CGSize(width: (collectionView.frame.size.width-5)/2, height:  (collectionView.frame.size.height-10)/2.5)
        }
    }
    
    //collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wallpapers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath as IndexPath) as! DetailsCollectionViewCell
                
        let w = wallpapers[indexPath.row]
        cell.detailsCollectionImageView.kf.setImage(with: URL(string: w.low_res_link))
        
        return cell
    }
    
    //MARK Pagination
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if isLoading {
            return CGSize.zero
        }
        return CGSize(width: collectionView.bounds.size.width, height: LOADER_HEIGHT)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath) as! CustomFooterView
            self.footerView = aFooterView
            self.footerView?.backgroundColor = UIColor.clear
            return aFooterView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath)
            return headerView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.footerView?.prepareInitialAnimation()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.footerView?.stopAnimate()
        }
    }
    
    //compute the scroll value and play witht the threshold to get desired effect
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold   = 100.0 ;
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        var triggerThreshold  = Float((diffHeight - frameHeight))/Float(threshold);
        triggerThreshold   =  min(triggerThreshold, 0.0)
        let pullRatio  = min(fabs(triggerThreshold),1.0);
        self.footerView?.setTransform(inTransform: CGAffineTransform.identity, scaleFactor: CGFloat(pullRatio))
        if pullRatio >= 1 {
            self.footerView?.animateFinal()
        }
        //print("pullRatio:\(pullRatio)")
    }
    
    //compute the offset and call the load method
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        let pullHeight  = fabs(diffHeight - frameHeight);
        print("pullHeight:\(pullHeight)");
        if pullHeight == PULLHEIGHT {
            if (self.footerView?.isAnimatingFinal)! {
                print("load more trigger")
                self.isLoading = true
                self.footerView?.startAnimate()
                
                self.refresh()
            }
        }
    }
    
    // segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWallpaper" {
            let galleryVC = segue.destination as! GalleryViewController
            let cell = sender as! DetailsCollectionViewCell
            let indexPath = self.collectionView?.indexPath(for: cell)
            galleryVC.wallpaper = wallpapers[(indexPath?.row)!]
        }
    }
    
    //3D touch
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let galleryVC = storyboard?.instantiateViewController(withIdentifier: "GalleryViewController") as? GalleryViewController else { return nil }
        guard let indexPath = collectionView?.indexPathForItem(at: location) else { return nil }
        guard let cell = collectionView?.cellForItem(at: indexPath) else { return nil }
        
        let thisWallpaper = self.wallpapers[indexPath.row] as Wallpaper
        galleryVC.wallpaper = thisWallpaper

        galleryVC.preferredContentSize = CGSize(width: 0.0, height: 300)
        previewingContext.sourceRect = cell.frame
        return galleryVC
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
    
}

