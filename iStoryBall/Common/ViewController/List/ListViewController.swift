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
        headerImageView = UIImageView(frame: CGRectMake(0, 0, self.view.bounds.width, 80))
        self.view.addSubview(headerImageView)
        
        if let h = headerImageView {
            if let imageUrl = url {
                h.contentMode = UIViewContentMode.ScaleAspectFill
                h.layoutTopInParentView()
                h.setImageWithURL(NSURL(string: imageUrl))
                h.clipsToBounds = true
            }
        }
    }
    
    func createStoryDescView() {
        var data = doc!.itemWithQuery(".intro_cont")
        var horizontalMargin: CGFloat = 5.0
        var maxWidth = self.view.bounds.size.width - (horizontalMargin * 2)
        descView = UIView()
        
        var title = data!.itemWithQuery(".tit_intro")
        var titleLabel = UILabel.boldFontLabel(title!.text().trim(), fontSize: SBFontSize.font3.valueOf())
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .Left
        titleLabel.frame = CGRectMake(0, 0, maxWidth, 0)
        titleLabel.sizeToFit()
        descView!.addSubview(titleLabel)
        titleLabel.layoutTopInParentView(.Left, offset: CGPointMake(horizontalMargin, 5))
        
        var writer = data!.itemWithQuery(".intro_writer")!.text()
        var regex = DHRegEx.regexWithPattern("\\s", error: nil)
        writer = regex.stringByReplacingMatchesInString(writer, options: NSMatchingOptions(0), range: writer.range(), withTemplate: "")
        var writerLabel = UILabel.systemFontLabel(writer, fontSize: SBFontSize.font1.valueOf())
        writerLabel.textAlignment = .Left
        descView!.addSubview(writerLabel)
        writerLabel.layoutBottomFromSibling(titleLabel, horizontalAlign: .Left, offset: CGPointMake(0, 5))
        
        var intro = data!.itemWithQuery(".txt_intro")
        var introLabel = UILabel.systemFontLabel(intro!.text().trim(), fontSize: SBFontSize.font1.valueOf())
        introLabel.numberOfLines = 0
        introLabel.textAlignment = .Left
        introLabel.textColor = UIColor.rgb(192, g: 192, b: 192)
        introLabel.frame = CGRectMake(0, 0, maxWidth, 0)
        introLabel.sizeToFit()
        descView!.addSubview(introLabel)
        introLabel.layoutBottomFromSibling(writerLabel, horizontalAlign: .Left, offset: CGPointMake(0, 5))
        
        var subscriptionDay = data!.itemWithQuery(".intro_day")
        var subscriptionDayLabel = UILabel.systemFontLabel(subscriptionDay!.text().trim(), fontSize: SBFontSize.font2.valueOf())
        subscriptionDayLabel.textColor = UIColor.rgb(76, g: 134, b: 237)
        subscriptionDayLabel.sizeToFit()
        descView!.addSubview(subscriptionDayLabel)
        subscriptionDayLabel.layoutBottomFromSibling(introLabel, horizontalAlign: .Left, offset: CGPointMake(0, 5))
        
        var writerButton:UIButton = makeInfoButton("저자소개")
        descView!.addSubview(writerButton)
        writerButton.layoutRightFromSibling(subscriptionDayLabel, verticalAlign:.Center, offset:CGPointMake(10, 0))
        writerButton.addTarget(self, action: Selector("showWriterInfo"), forControlEvents: UIControlEvents.TouchUpInside)
        
        var shareButton:UIButton = makeInfoButton("공유하기")
        descView!.addSubview(shareButton)
        shareButton.layoutRightFromSibling(writerButton, verticalAlign:.Center, offset:CGPointMake(10, 0))
        shareButton.addTarget(self, action: Selector("sharePage"), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(descView)
        descView!.frame = CGRectMake(0, 0, self.view.bounds.size.width, 10.0)
        
        descView!.sizeToFit()
        descView!.layoutBottomFromSibling(headerImageView!, horizontalAlign: .Left)
    }
    
    func makeInfoButton(title:String) -> UIButton {
        var button:UIButton = UIButton() as UIButton
        button.setTitle(title, forState: .Normal)
        button.frame = CGRectMake(0, 0, 52, 16)
        button.titleLabel.font = UIFont.boldSystemFontOfSize(SBFontSize.font1.valueOf())
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 7
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.blackColor().CGColor
        return button
    }
    
    func sharePage() {
        var name = self.title
        var link = "http://m.storyball.daum.net\(self.id!)"
        var title = "<스토리볼: \(name)> - \(link)"
        var items = [title, headerImageView!.image]
        var controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func showWriterInfo() {
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
