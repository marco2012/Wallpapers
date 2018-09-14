//
//  PornpicsAPI.swift
//  PH
//
//  Created by Marco on 18/08/2018.
//  Copyright © 2018 Vikings. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftSoup

class PornpicsAPI {
    
    func getPics(offset:Int, category:String="Babe", popular:Bool=false, search:Bool=false, query:String="", completionHandler: @escaping (([Pic]) -> Void)) {
        
        let id = categories[category]!

        var url = "https://www.pornpics.com/getchank2.php?rid=1&cat=\(id)&limit=20&offset=\(offset)"
        if category=="Ladyboy" {
            url = "https://www.pornpics.com/getchank2.php?rid=3&cat=2&limit=20&offset=\(offset)" //cambia rid
        } else if search {
            let query = query.replacingOccurrences(of: " ", with: "+")
            url = "https://www.pornpics.com/search/srch.php?q=\(query)&limit=20&offset=\(offset)"
        } else if category=="Popular" || popular {
            url = "https://www.pornpics.com/getnext.php?type=popular&limit=20&offset=\(offset)"
        }
        
        // Fetch Request
        Alamofire.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    print(url)
                    
                    let album_array = JSON(response.result.value!)
                    var pics = [Pic]()
                    for (_, elem) in album_array {

                        let pic = Pic(
                            pic_description: elem["desc"].stringValue,
                            url: elem["g_url"].stringValue,
                            thumbnail: elem["t_url_460"].stringValue,
                            thumbnail_small: elem["t_url"].stringValue
                            )
                        
                        pics.append(pic)
                    }
                    
                    completionHandler(pics) //returns newly created albums array with all the pictures
                    
                }
                else {
                    debugPrint("HTTP Request failed: \(String(describing: response.result.error))")
                    ErrorReporting.showMessage(msg: response.result.error as! String)
                }
        }
    }
    
    // current document
    var document: Document = Document.init("")
    //Download HTML
    func getPicDetails(url:String, completionHandler: @escaping (([String]) -> Void)) {
        
        let url = URL(string: url)
        
        do {
            // content of url
            let html = try String.init(contentsOf: url!)
            // parse it into a Document
            document = try SwiftSoup.parse(html)
            // parse css query
            let links_list: Elements = try document.select("#tiles > li > a")
            //transform it into a local object (Item)
            var links: [String] = []
            for l in links_list {
                
                let link = try l.attr("href")
                
                links.append(link)
            }
            completionHandler(links) //returns newly created albums array with all the pictures
            
        } catch let error {
            // an error occurred
            print("Error: \(error)")
        }
        
    }
    
    let categories: [String:Int] = [
        "Popular"            : 0,
        "Amateur"            : 2,
        "Anal"               : 3,
        "Anal Gape"          : 4,
        "Asian"              : 5,
        "Ass"                : 6,
        "Ass Fucking"        : 7,
        "Ass Licking"        : 8,
        "Babe"               : 9,
        "Ball Licking"       : 10,
        "Bath"               : 11,
        "BBW"                : 46,
        "Beach"              : 13,
        "Big Cock"           : 14,
        "Big Tits"           : 15,
        "Bikini"             : 16,
        "Blindfold"          : 17,
        "Blonde"             : 18,
        "Blowbang"           : 19,
        "Blowjob"            : 20,
        "Bondage"            : 12,
        "Boots"              : 21,
        "Brunette"           : 22,
        "Bukkake"            : 23,
        "Centerfold"         : 24,
        "CFNM"               : 25,
        "Cheerleader"        : 26,
        "Christmas"          : 27,
        "Close Up"           : 28,
        "Clothed"            : 29,
        "College"            : 30,
        "Cosplay"            : 31,
        "Cougar"             : 32,
        "Cowgirl"            : 33,
        "Creampie"           : 34,
        "Cum In Mouth"       : 35,
        "Cum In Pussy"       : 36,
        "Cumshot"            : 38,
        "Cum Swapping"       : 39,
        "Deepthroat"         : 40,
        "Dildo"              : 134,
        "Double Penetration" : 41,
        "Ebony"              : 42,
        "European"           : 43,
        "Face"               : 45,
        "Facesitting"        : 45,
        "Facial"             : 37,
        "Femdom"             : 47,
        "Fetish"             : 48,
        "Fingering"          : 49,
        "Fisting"            : 50,
        "Flexible"           : 51,
        "Foot Fetish"        : 52,
        "Footjob"            : 53,
        "Gangbang"           : 54,
        "Girlfriend"         : 55,
        "Glamour"            : 147,
        "Glasses"            : 56,
        "Gloryhole"          : 57,
        "Granny"             : 59,
        "Groupsex"           : 60,
        "Gyno"               : 61,
        "Hairy"              : 62,
        "Handjob"            : 63,
        "Hardcore"           : 64,
        "High Heels"         : 65,
        "Homemade"           : 66,
        "Housewife"          : 67,
        "Humping"            : 68,
        "Indian"             : 69,
        "Interracial"        : 70,
        "Japanese"           : 71,
        "Jeans"              : 72,
        "Kissing"            : 73,
        "Ladyboy"            : 2,
        "Latex"              : 74,
        "Latina"             : 75,
        "Legs"               : 76,
        "Lesbian"            : 77,
        "Lingerie"           : 78,
        "Maid"               : 79,
        "Massage"            : 80,
        "Masturbation"       : 81,
        "Mature"             : 82,
        "MILF"               : 83,
        "Mom"                : 84,
        "Nipples"            : 85,
        "Non Nude"           : 86,
        "Nurse"              : 87,
        "Office"             : 88,
        "Oiled"              : 89,
        "Orgy"               : 90,
        "Outdoor"            : 91,
        "Panties"            : 92,
        "Pantyhose"          : 93,
        "Party"              : 94,
        "Pegging"            : 95,
        "Petite"             : 96,
        "Piercing"           : 97,
        "Pissing"            : 98,
        "Police"             : 99,
        "Pool"               : 100,
        "Pornstar"           : 101,
        "POV"                : 58,
        "Public"             : 102,
        "Pussy"              : 103,
        "Pussy Licking"      : 104,
        "Reality"            : 105,
        "Redhead"            : 106,
        "Saggy Tits"         : 107,
        "Schoolgirl"         : 109,
        "Secretary"          : 110,
        "Seduction"          : 111,
        "Self Shot"          : 112,
        "Shaved"             : 113,
        "Shemale"            : 114,
        "Shorts"             : 115,
        "Shower"             : 116,
        "Skinny"             : 115,
        "Skirt"              : 116,
        "Smoking"            : 117,
        "Socks"              : 118,
        "Spanking"           : 119,
        "Sports"             : 120,
        "Spreading"          : 121,
        "Squirting"          : 122,
        "SSBBW"              : 123,
        "Stockings"          : 124,
        "Strapon"            : 125,
        "Stripper"           : 126,
        "Tall"               : 146,
        "Tattoo"             : 127,
        "Teacher"            : 128,
        "Teen"               : 129,
        "Thai"               : 130,
        "Threesome"          : 131,
        "Tiny Tits"          : 132,
        "Titjob"             : 133,
        "Tribbing"           : 135,
        "Undressing"         : 136,
        "Uniform"            : 137,
        "Upskirt"            : 138,
        "Voyeur"             : 139,
        "Wedding"            : 140,
        "Wet"                : 141,
        "Wife"               : 142,
        "Yoga Pants"         : 143
    ]
    
    
    
}
