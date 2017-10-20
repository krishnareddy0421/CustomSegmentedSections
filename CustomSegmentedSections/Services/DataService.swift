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
        self.articles.removeAll()
        Alamofire.request(url!).responseJSON { (response) in
            if response.error != nil {
                completion(false)
                return
            }
            let json = JSON(response.data!)
            guard let items = json["Items"].array else {
                completion(false)
                return
            }
            for item in items {
                let articleTitle = item["Title"].stringValue
                let articleId = item["Id"].stringValue
                let articleDescription = item["Description"].stringValue
                let articleThumnailUrl = item["ThumbnailUrl"].stringValue
                let url = URL(string: articleThumnailUrl)
                let imageData = NSData(contentsOf: url!)
                let thumnailImage = UIImage(data: imageData! as Data)
                
                let article = Article(id: articleId, title: articleTitle, description: articleDescription, thumbnailImg: thumnailImage)
                self.articles.append(article)
            }
            completion(true)
        }
    }
}
