//
//  DataService.swift
//  CustomSegmentedSections
//
//  Created by vamsi krishna reddy kamjula on 10/19/17.
//  Copyright © 2017 kvkr. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DataService {
    static let instance = DataService()
    
    var articles = [Article]()
    
    func getArticleData(urlString: String, completion: @escaping CompletioHandler) {
        let url = URL(string: urlString)
        Alamofire.request(url!).responseJSON { (response) in
            if response.error != nil {
                completion(false)
                return
            }
            print(response.result.value!)
            completion(true)
        }
    }
}
