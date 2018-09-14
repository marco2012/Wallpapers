//
//  API.swift
//  Secrets
//
//  Created by Marco on 31/08/2018.
//  Copyright © 2018 Vikings. All rights reserved.
//

import Foundation
import SwiftSoup

class API {
    
    // current document
    var document: Document = Document.init("")
    
    //Returns array of wallpaper
    func getWallpapers(page:Int) -> [Wallpaper] {
        var images: [Wallpaper] = []
        let link = "https://wallpapers.ispazio.net/?pg=\(page)"
        let url = URL(string: link)
        do {
            // content of url
            let html = try String.init(contentsOf: url!)
            // parse it into a Document
            document = try SwiftSoup.parse(html)
            
            print(link)
            // parse css query
            
            //            let details_links: Elements = try document.select(".adverts-list > a")
            //            let detailsLinksArray: [String?] = details_links.array().map { try? $0.attr("href").description } //link immagini alta risoluzione
            //
            //            let srcs: Elements = try document.select("img[src]")
            //            let srcsStringArray: [String?] = srcs.array().map { try? $0.attr("src").description } //link immagini bassa risoluzione
            
            let details_links: Elements = try document.select(".adverts-list > a")
            for link in details_links {
                
                let detail_link = try link.attr("href")
                
                let low_res_links: Elements = try link.select("img")
                let low_res_link = try low_res_links.attr("src")
                
                images.append(Wallpaper(low_res_link: low_res_link, detail_link: detail_link))
            }
            
        } catch let error {
            print("Error: \(error)")
        }
        
        return images
    }
    
    func getWallpaperLink(detail_link:String) -> String {
        var image_link = [String]()
        let url = URL(string: detail_link)
        do {
            // content of url
            let html = try String.init(contentsOf: url!)
            // parse it into a Document
            document = try SwiftSoup.parse(html)
            
            print(detail_link)
            
            let source: Elements = try document.select(".count")
            for link in source {
                let l = try link.attr("href")
                image_link.append(l)
            }
        } catch let error {
            print("Error: \(error)")
        }
        if UIScreen.main.nativeBounds.height == 2436 { //iPhone X
            return image_link[0] //iPhone X
        } else {
            return image_link[1] //iPhone 6-8
        }
    }
    
    
}
