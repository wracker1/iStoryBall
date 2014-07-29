//
//  SBTableViewCell.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 25..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

protocol SBTableViewCellProtocol {
    class func reuseIdentifier() -> String
    func update(data: TFHppleElement)
}

class SBTableViewCell: UITableViewCell, SBTableViewCellProtocol {
    var data: TFHppleElement?
    var model: SBModel?
    var indexPath: NSIndexPath?
    
    class func reuseIdentifier() -> String {
        return "Cell"
    }
    
    class func heightForRowWithModel(model: SBModel) -> CGFloat {
        return 50.0
    }
    
    func update(data: TFHppleElement) {
        self.data = data
    }
    
    func update(model: SBModel) {
        self.model = model
    }
    
    func thumbnailUrl() -> NSString? {
        return data?.itemWithQuery(".thumb_view")?.attributes["src"] as? NSString
    }
    
    func titleString() -> NSString? {
        return data?.itemWithQuery(".tit_product")?.text().trim()
    }
    
    func subTitleString() -> String? {
        return data?.attributes["title"] as? NSString
    }
}
