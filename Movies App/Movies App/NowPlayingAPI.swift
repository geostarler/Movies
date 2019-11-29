//
//  NowPlayingAPI.swift
//  Movies App
//
//  Created by Nguyen Tan Dung on 11/29/19.
//  Copyright © 2019 Nguyen Tan Dung. All rights reserved.
//

import Foundation

struct dataType:Decodable {
    
    let results : [dataType2]

}

struct dataType2 : Identifiable, Decodable {
    var id : Int
    var original_title : String
    var vote_avanrage : Float
    var poster_path : String
    var overview : String
    
    
}
