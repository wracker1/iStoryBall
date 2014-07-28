//
//  ThemeViewController.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 8..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class ThemeViewController : SBViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    var themeTitleQuery = ".tit_txt img"
    var themeEpisodeListQuery = "#storyList .link_story"
    
    var themeScroller: UIScrollView?
    var themeItemList = Array<TFHppleElement>()
    var selectedButton: UIButton?
    
    var themeEpisodeData = Dictionary<String, (NSString, [TFHppleElement])>()
    var themeEpisodeView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeTitleView("테마")
        
        NetClient.instance.get("/story/list") {
            (html: String) in

            self.doc = html.htmlDocument()
            self.layoutSubviews()
        }
    }
    
    func layoutSubviews() {
        themeItemList = doc!.itemsWithQuery(".list_genre li")
        
        var wrapper = doc!.itemWithQuery("#category")
        var title = wrapper!.itemWithQuery(themeTitleQuery)!.attributes!["alt"]! as NSString
        var list = wrapper!.itemWithQuery("#storyList")!.itemsWithQuery(".link_story") as [TFHppleElement]
        var id = themeIdAtIndex(0)
        
        themeEpisodeData[id] = (title, list)
        
        createThemeScroller()
        createThemeEpisodeCollectionview()
    }
    
    func createThemeScroller() {
        var size = self.view.bounds.size
        var height: CGFloat = 60.0
        
        themeScroller = UIScrollView(frame: CGRectMake(0, 0, size.width, height))
        themeScroller!.showsHorizontalScrollIndicator = false
        self.view.addSubview(themeScroller)
        themeScroller!.layoutTopInParentView()
        
        var sibling: UIButton?
        
        for var i = 0; i < themeItemList.count; i++ {
            var item = themeItemList[i]
            var imageNode = item.itemWithQuery(".thumb_img")
            var imageUrl = imageNode!.attributes["src"] as NSString
            var title = item.itemWithQuery(".tit_genre")?.text()?.trim()
            
            var button = UIButton.buttonWithType(.Custom) as UIButton
            button.frame = CGRectMake(0, 0, 55, 50)
            button.setImageForState(.Normal, withURL: NSURL(string: imageUrl))
            button.setTitle(title!, forState: .Normal)
            button.setTitleColor(UIColor.grayColor(), forState: .Normal)
            button.titleLabel.font = UIFont.systemFontOfSize(8)
            button.tag = i + 100
            button.verticalAlignContent(CGSizeMake(34, 30))
            button.addTarget(self, action: Selector("themeButtonTouched:"), forControlEvents: UIControlEvents.TouchUpInside)
            themeScroller!.addSubview(button)
            
            if let s = sibling {
                button.layoutRightFromSibling(s, verticalAlign: .Center, offset: CGPointMake(10, 0))
            } else {
                button.layoutLeftInParentView(.Top, offset: CGPointMake(0, 0))
                themeButtonTouched(button)
            }
            
            sibling = button
        }
        
        var sFrame = sibling!.frame
        themeScroller!.contentSize = CGSizeMake(sFrame.origin.x + sFrame.size.width, height)
    }
    
    func presentThemeId() -> NSString {
        var index = 0
        
        if let s = selectedButton {
            index = s.tag - 100
        }
        
        return themeIdAtIndex(index)
    }
    
    func themeIdAtIndex(index: Int) -> NSString {
        return themeItemList[index].attributes["id"] as NSString
    }
    
    func themeButtonTouched(button: UIButton) {
        var index = button.tag - 100
        var id = themeIdAtIndex(index)
        
        selectThemeButton(button)
        themeEpisodeDataById(id) {
            (title: String, list: [TFHppleElement]) in
            
            
        }
    }
    
    func selectThemeButton(button: UIButton) {
        if let b = selectedButton {
            b.setTitleColor(UIColor.grayColor(), forState: .Normal)
            b.titleLabel.font = UIFont.systemFontOfSize(8)
        }
        
        button.setTitleColor(UIColor.pointColor(1.0), forState: .Normal)
        button.titleLabel.font = UIFont.boldSystemFontOfSize(8)
        selectedButton = button
    }
    
    func themeEpisodeDataById(id: String, callback: ((title: String, list: [TFHppleElement]) -> Void)) {
        var data = themeEpisodeData[id]
        
        if let (title, list) = data {
            callback(title: title, list: list)
        } else {
            var url = "/story/list/\(id)"
            
            NetClient.instance.get(url) {
                (html: String) in
                var themeDoc = html.htmlDocument()
                var title = themeDoc.itemWithQuery(self.themeTitleQuery)!.attributes["alt"]! as NSString
                var list = themeDoc.itemsWithQuery(self.themeEpisodeListQuery) as [TFHppleElement]

                self.themeEpisodeData[id] = (title, list)
                callback(title: title, list: list)
            }
        }
    }
    
    func createThemeEpisodeCollectionview() {
        var size = self.view.bounds.size
        var frame = CGRectMake(0, 0, size.width, size.height - themeScroller!.bounds.size.height)
        var layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5.0
        layout.minimumLineSpacing = 10.0
        themeEpisodeView = UICollectionView(frame: frame, collectionViewLayout: layout)
        themeEpisodeView!.backgroundColor = UIColor.rgb(227, g: 229, b: 234)
        themeEpisodeView!.dataSource = self
        themeEpisodeView!.delegate = self
        
        themeEpisodeView!.registerClass(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "Cell")
        self.view.addSubview(themeEpisodeView)
        
        themeEpisodeView!.layoutBottomInParentView()
    }
    
    func updateCollectionViewCell(cell: UICollectionViewCell, indexPath: NSIndexPath) {
        let id = presentThemeId()
        let (title, list) = themeEpisodeData[id]!
        let data = list[indexPath.row]
        let imageNode = data.itemWithQuery(".thumb_img")
        let imageUrl = imageNode!.imageUrlFromHppleElement()
        
        println(imageUrl)
    }
    
//    UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        let id = presentThemeId()
        let (title, list) = themeEpisodeData[id]!
        return list.count
    }
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as? UICollectionViewCell
        
        cell!.backgroundColor = UIColor.whiteColor()
        
        updateCollectionViewCell(cell!, indexPath: indexPath)
        
        return cell
    }
    
//    UICollectionViewDelegateLayout
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        var width = self.view.bounds.size.width / 2.0
        width -= 15.0
        return CGSizeMake(width, 210.0)
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 0, 10)
    }
}
