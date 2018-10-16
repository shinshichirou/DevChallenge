//
//  DataManager.swift
//  DevChallenge
//
//  Created by Igor Tudoran on 10/16/18.
//  Copyright © 2018 Igor Tudoran. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias CommentsCompletion = (([Comment]) -> Void)
typealias CommentCompletion = ((Comment?, Error?) -> Void)

class DataManager {
    
    private var index = 0
    private var currentIndex = -1
    private var count = 0
    private var comments: [Comment]!
    
    func getCommentsFrom(_ index: Int, count: Int, completion: @escaping CommentsCompletion) {
        
        if currentIndex == -1 {
            self.index = index
            self.count = count
            currentIndex = index
            self.comments = [Comment]()
        } else {
            self.currentIndex += 1
        }
        
        if self.currentIndex == index + count {
            completion(self.comments)
            currentIndex = -1
            return
        }
        
        getComment(currentIndex) { (comment, error) in
            if let comm = comment {
                self.comments.append(comm)
            }
            self.getCommentsFrom(index, count: count, completion: completion)
        }
        
    }
    
    
    private func getComment(_ index: Int, completion: @escaping CommentCompletion) {
        
        API.shared.request(.getComment(index)) { (json, error) in
            if let err = error {
                completion(nil, err)
            } else {
                var comment = Comment()
                comment.name = json["name"].stringValue
                comment.body = json["body"].stringValue
                comment.email = json["email"].stringValue
                comment.commentID = json["id"].intValue
                completion(comment, nil)
            }
        }
    }
    
}
