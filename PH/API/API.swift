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

        // https://stackoverflow.com/a/46192822/1440037
        switch UIScreen.main.nativeBounds.height {
        case 1136, 1334, 1920, 2208: // <= iPhone 8+
            return image_link.count == 1 ? image_link[0] : image_link[1]    //usually the first link on the website is for old iphones and the second one is for iPhone X but sometimes there is only 1 link
        default:                     // >= iPhone X
            return image_link[0]
        }
        
    }
    
    
}
