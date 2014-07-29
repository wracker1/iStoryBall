//
//  ListViewController.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 23..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class ListViewController: SBViewController, UITableViewDataSource, UITableViewDelegate
{
    var headerImageView: UIImageView?
    var descView: UIView?
    var episodeTableView: UITableView?
    
    var episodeList = Array<TFHppleElement>()
    var contentSearchQuery = ".list_product li a"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let storyId = id {
            NetClient.instance.get(storyId) {
                (html: String) in
                
                self.doc = html.htmlDocument()
                self.layoutSubviews()
            }
        }
    }
    
    func layoutSubviews() {
        episodeList = doc!.itemsWithQuery(contentSearchQuery)
        
        createHeaderView()
        createStoryDescView()
        createEpisodeTableView()
    }
    
    func createHeaderView() {
        var thumbImageNode = doc!.itemWithQuery(".intro_img .thumb_img")
        var url = thumbImageNode?.imageUrlFromHppleElement()
        headerImageView = UIImageView(frame: CGRectMake(0, 0, self.view.bounds.width, 120))
        self.view.addSubview(headerImageView)
        
        headerImageView!.contentMode = UIViewContentMode.ScaleAspectFill
        headerImageView!.activateConstraintsTopInParentView()
        headerImageView!.setImageWithURL(NSURL(string: url))
        headerImageView!.clipsToBounds = true
    }
    
    func createStoryDescView() {
        var data = doc!.itemWithQuery(".intro_cont")
        var horizontalMargin: CGFloat = 5.0
        var maxWidth = self.view.bounds.size.width - (horizontalMargin * 2)
        descView = UIView()
        
        var title = data!.itemWithQuery(".tit_intro")
        var titleLabel = UILabel.boldFontLabel(title!.text().trim(), fontSize: 15)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .Left
        titleLabel.frame = CGRectMake(0, 0, maxWidth, 0)
        titleLabel.sizeToFit()
        descView!.addSubview(titleLabel)
        titleLabel.layoutTopInParentView(.Left, offset: CGPointMake(horizontalMargin, 5))
        
        var writer = data!.itemWithQuery(".intro_writer")
        var writerLabel = UILabel.systemFontLabel(writer!.text().trim(), fontSize: 10)
        writerLabel.textAlignment = .Left
        descView!.addSubview(writerLabel)
        writerLabel.layoutBottomFromSibling(titleLabel, horizontalAlign: .Left, offset: CGPointMake(0, 5))
        
        var intro = data!.itemWithQuery(".txt_intro")
        var introLabel = UILabel.systemFontLabel(intro!.text().trim(), fontSize: 10)
        introLabel.numberOfLines = 0
        introLabel.textAlignment = .Left
        introLabel.textColor = UIColor.rgb(192, g: 192, b: 192)
        introLabel.frame = CGRectMake(0, 0, maxWidth, 0)
        introLabel.sizeToFit()
        descView!.addSubview(introLabel)
        introLabel.layoutBottomFromSibling(writerLabel, horizontalAlign: .Left, offset: CGPointMake(0, 5))
        
        var subscriptionDay = data!.itemWithQuery(".intro_day")
        var subscriptionDayLabel = UILabel.systemFontLabel(subscriptionDay!.text().trim(), fontSize: 10)
        subscriptionDayLabel.textColor = UIColor.rgb(76, g: 134, b: 237)
        subscriptionDayLabel.sizeToFit()
        descView!.addSubview(subscriptionDayLabel)
        subscriptionDayLabel.layoutBottomFromSibling(introLabel, horizontalAlign: .Left, offset: CGPointMake(0, 5))
        
        var writerButton:UIButton = UIButton() as UIButton
        writerButton.setTitle("저자 소개", forState: .Normal)
        writerButton.titleLabel.font = UIFont.systemFontOfSize(10)
        writerButton.frame = CGRectMake(0, 0, 50, 15)
        writerButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        writerButton.layer.masksToBounds = true
        writerButton.layer.cornerRadius = 7
        writerButton.layer.borderWidth = 0.5
        writerButton.layer.borderColor = UIColor.grayColor().CGColor
        descView!.addSubview(writerButton)
        writerButton.layoutRightFromSibling(subscriptionDayLabel, verticalAlign:.Center, offset:CGPointMake(10, 0))
        writerButton.addTarget(self, action: "showWriterInfo:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(descView)
        descView!.frame = CGRectMake(0, 0, self.view.bounds.size.width, 10.0)
        
        descView!.sizeToFit()
        descView!.layoutBottomFromSibling(headerImageView!, horizontalAlign: .Left)
    }
    
    func showWriterInfo(sender:UIButton!) {
        println("view writer info")
        var writerViewController = WriterViewController(title:"저자 소개")
        writerViewController.id = self.id
        var navigator = SBNavigationController.instanceWithViewController(writerViewController)
        self.presentViewController(navigator, animated: true, completion: nil)
    }
    
    func createEpisodeTableView() {
        var size = self.view.bounds.size
        var topMargin: CGFloat = 10.0
        var height = size.height - (headerImageView!.bounds.size.height + descView!.bounds.size.height + topMargin)
        episodeTableView = UITableView(frame: CGRectMake(0, 0, size.width, height), style: .Plain)
        episodeTableView!.dataSource = self
        episodeTableView!.delegate = self
        self.view.addSubview(episodeTableView)
        episodeTableView!.layoutBottomFromSibling(descView!, horizontalAlign: .Left, offset: CGPointMake(0, topMargin))
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return episodeList.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cellId = EpisodeListCell.reuseIdentifier()
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? EpisodeListCell
        
        if cell == nil {
            cell = EpisodeListCell()
        }
        
        var data = episodeList[indexPath.row]
        cell!.update(data)
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        var data = episodeList[indexPath.row]
        var href = data.attributes["href"] as? NSString
        
        if let link = href {
            var title = data.itemWithQuery(".tit_product")
            var episodeViewController = EpisodeViewController(title: title!.text().trim())
            episodeViewController.id = link
            self.navigationController.pushViewController(episodeViewController, animated: true)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
}
