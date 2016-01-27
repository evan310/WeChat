//
//  ContactViewController.swift
//  WeChat
//
//  Created by Smile on 16/1/8.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//联系人页面
class ContactViewController: UITableViewController,UISearchBarDelegate{

    //@IBOutlet weak var tableView: UITableView!
    let footerHeight:CGFloat = 40
    let headerHeight:CGFloat = 40
    let searchHeight:CGFloat = 40
    let leftPadding:CGFloat = 20
    
    var tableViewIndex:TableViewIndex?
    
    var totalCount = 0
    //MARKS: 重写协议的属性
    var CELL_HEIGHT:CGFloat {
        get {
            return 54
        }
        
        set {
            self.CELL_HEIGHT = newValue
        }
    }
    
    var CELL_HEADER_HEIGHT:CGFloat {
        get {
            return 25
        }
        
        set {
            self.CELL_HEADER_HEIGHT = newValue
        }
    }
    
    var CELL_FOOTER_HEIGHT:CGFloat {
        get {
            return 0
        }
        
        set {
            self.CELL_FOOTER_HEIGHT = newValue
        }
    }
    
    
    var searchBar:UISearchBar?
    
    var sessions = [ContactSession]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARKS: Init Frame
        initFrame()
        //let refreshView = WeChatRefreshView(scrollView: tableView)
        //refreshView.delegate = self
        //self.tableView.addSubview(refreshView)
    }
    
    func refresh(refreshView: WeChatRefreshView) {
        delay(4) {
            refreshView.endRefresh()
        }
    }
    
    func delay(seconds: Double, completion:()->()) {
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
        
        dispatch_after(popTime, dispatch_get_main_queue()) {
            completion()
        }
    }
    
    //MARKS: Init Data
    func initContactData(){
        let contactModel = ContactModel()
        sessions = contactModel.contactSesion
        totalCount = contactModel.contacts.count
    }
    
    //MARKS: 禁止横屏
    /*override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }*/
    
    func initFrame(){
        tableView.delegate = self
        tableView.dataSource = self
        
        //MARKS: register table view cell
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "ContactTableCell")
        
        //self.automaticallyAdjustsScrollViewInsets = false
        //MARKS: remove blank at bottom
        //self.edgesForExtendedLayout = .Bottom
        
        //MARKS: 设置导航行背景及字体颜色
        WeChatNavigation().setNavigationBarProperties((self.navigationController?.navigationBar)!)
        
        initContactData()
        initSearchBar()
        initTableIndex()
        addFooter()
    }
    
    //MARKS: 当视图出现的时候显示tabbar
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.tabBarController!.tabBar.hidden = false
        if self.tableViewIndex != nil {
            self.tableViewIndex?.hidden = false
        }
    }
    
    //MARKS: 当神图消失的时候
    override func viewWillDisappear(animated: Bool) {
        if self.tableViewIndex != nil {
            self.tableViewIndex?.hidden = true
        }
    }
    
    //MARKS: Init SearchBar And Add Header View
    func initSearchBar(){
        //tableView.frame = UIScreen.mainScreen().bounds
        tableView.frame.size = self.view.frame.size
        //tableView.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        tableView.backgroundColor = UIColor.whiteColor()
        
        let headerView:UIView = UIView(frame: CGRectMake(0,0,tableView.frame.size.width,headerHeight))
        searchBar = UISearchBar(frame: CGRectMake(0,0,tableView.frame.size.width,searchHeight))
        
        //设置透明
        searchBar!.placeholder = "搜索"
        searchBar!.translucent = true
        searchBar!.barStyle = .Default
        searchBar!.showsCancelButton = false
        searchBar!.showsScopeBar = false
        searchBar!.barStyle = UIBarStyle.Default
        searchBar!.searchBarStyle = UISearchBarStyle.Default
        searchBar!.showsBookmarkButton = false
        searchBar!.showsSearchResultsButton = false
        searchBar!.delegate = self
        
        headerView.addSubview(searchBar!)
        tableView.tableHeaderView = headerView
    }
    
    //MARKS:当焦点在输入框的时候
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        let customView = ContactCustomSearchView()
        customView.index = 1
        customView.sessions = self.sessions
        self.presentViewController(customView, animated: false) { () -> Void in
            
        }
        return false
    }
    
    //MARKS: Init tableview index
    func initTableIndex(){
        let width:CGFloat = 20
        let height:CGFloat = 200
        
        self.tableViewIndex = TableViewIndex(frame: CGRectMake(tableView.frame.width - width,UIScreen.mainScreen().bounds.height / 2 - height,width,UIScreen.mainScreen().bounds.height),tableView: tableView!,datas: sessions)
        self.parentViewController?.parentViewController!.view.addSubview(tableViewIndex!)
    }
    
    //MARKS: Add Footer View
    func addFooter(){
        let footerView:UIView = UIView(frame: CGRectMake(0,0,tableView.frame.size.width,footerHeight))
        let footerlabel:UILabel = UILabel(frame: footerView.bounds)
        footerlabel.textColor = UIColor.grayColor()
        //footerlabel.backgroundColor = UIColor.clearColor()
        footerlabel.font = UIFont.systemFontOfSize(16)
        footerlabel.text = "共\(totalCount)位联系人"
        footerlabel.textAlignment = .Center
        
        //画底部线条
        let shape = WeChatDrawView().drawLine(beginPointX: 0, beginPointY: 0, endPointX: UIScreen.mainScreen().bounds.width, endPointY: 0,color:UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 0.8))
        footerView.layer.addSublayer(shape)
        
        footerView.addSubview(footerlabel)
        footerView.backgroundColor = UIColor.whiteColor()
        tableView.tableFooterView = footerView
    }
    
    /****************************** tableView ***********************************/
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return CELL_HEIGHT
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CELL_HEADER_HEIGHT
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CELL_FOOTER_HEIGHT
    }
    
    //MARKS: 返回分组override 数
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sessions.count
    }
    
    //MARKS: 返回每组行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let session = sessions[section] as ContactSession
        return session.contacts.count
    }
    
    let paddingLeft:CGFloat = 15
    let imageWidth:CGFloat = 44
    let imageHeight:CGFloat = 44
    let topOrBottomPadding:CGFloat = 5
    let bounds:CGFloat = 4
    let photoRightPadding:CGFloat = 8
    let labelHeight:CGFloat = 20
    
    //MARKS: 返回每行的单元格
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("ContactTableViewCell", forIndexPath: indexPath) as! ContactTableViewCell
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactTableCell",forIndexPath:indexPath) as UITableViewCell
        
        //MARKS: Get group sesssion
        let session = sessions[indexPath.section]
        let contact = session.contacts[indexPath.row]
        
        //清除旧数据
        if cell.subviews.count > 0 {
            for subView in cell.subviews {
                if subView.isKindOfClass(UILabel) || subView.isKindOfClass(UIImageView) {
                    subView.removeFromSuperview()
                }
                
            }
        }
        
        /*let section = tableView.numberOfRowsInSection(indexPath.section)
        let index = tableView.numberOfRowsInSection(section)
        
        if indexPath.row != (index - 1) {
            //画底部线条
            let shape = WeChatDrawView().drawLine(beginPointX: leftPadding, beginPointY: cell.frame.height, endPointX: UIScreen.mainScreen().bounds.width, endPointY: cell.frame.height,color:UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1))
            cell.layer.addSublayer(shape)
        }*/
       
        
        //MARKS:因为cell长度超出竖屏范围,故重新设置其长度
        //cell.resize((searchBar?.frame.width)!)
        
        //MARKS: Get group sesssion
        let photoImageView = createPhotoView(CGRectMake(paddingLeft, topOrBottomPadding, imageWidth, imageHeight), image: contact.photo!,bounds: bounds)
        cell.addSubview(photoImageView)
        
        let textLabel = createLabel(CGRectMake(photoImageView.frame.origin.x + photoRightPadding + photoImageView.frame.width, topOrBottomPadding + (imageHeight - labelHeight) / 2 + 5, UIScreen.mainScreen().bounds.width - photoImageView.frame.origin.x - photoRightPadding, self.labelHeight), string: contact.name, color: UIColor.darkTextColor(), fontName: "AlNile", fontSize: 17)
        cell.addSubview(textLabel)
        
        return cell
    }
    
    func createLabel(frame:CGRect,string:String,color:UIColor,fontName:String,fontSize:CGFloat) -> UILabel{
        let label = UILabel(frame: frame)
        label.textAlignment = .Left
        label.font = UIFont(name: fontName, size: fontSize)
        label.textColor = color
        label.numberOfLines = 1
        label.text = string
        return label
    }
    
    //创建Photo
    func createPhotoView(frame:CGRect,image:UIImage,bounds:CGFloat) -> UIImageView{
        let photoView = UIImageView(frame: frame)
        photoView.image = image
        if bounds > 0 {
            photoView.layer.masksToBounds = true
            photoView.layer.cornerRadius = bounds
        }
        return photoView
    }
    
    
    override func viewDidAppear(animated: Bool) {
    
    }
    
    //MARKS: 返回每组头标题名称
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sessions[section].key
    }
    
    //MARKS: 开启tableview编辑模式
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    //MARKS: 自定义向右滑动菜单
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let remarkAction = UITableViewRowAction(style: .Normal, title: "备注") { (action:UITableViewRowAction, index:NSIndexPath) -> Void in
            let session = self.sessions[index.section]
            let contact = session.contacts[indexPath.row]
            
            //根据storyboard获取controller
            let sb = UIStoryboard(name:"Contact-Detail", bundle: nil)
            let remarkTagController = sb.instantiateViewControllerWithIdentifier("RemarkTagController") as! RemarkTagViewController
            
            remarkTagController.remarkText = contact.name
            self.navigationController?.pushViewController(remarkTagController, animated: true)
            
            //让cell可以自动回到默认状态，所以需要退出编辑模式
            tableView.editing = false
        }
        
        return [remarkAction]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //根据storyboard获取controller
        let sb = UIStoryboard(name:"Contact-Detail", bundle: nil)
        let resourceDetailController = sb.instantiateViewControllerWithIdentifier("ResourceDetail") as! ResourceDetailViewController
        prepareForData(resourceDetailController,indexPath: indexPath)
        self.navigationController?.pushViewController(resourceDetailController, animated: true)
    }
    
    //MARKS :跳转到下一个页面传值
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowResourceDetail" {
             if let indexPath = self.tableView.indexPathForSelectedRow{
                let destinationController = segue.destinationViewController as! ResourceDetailViewController
                prepareForData(destinationController,indexPath: indexPath)
            }
            
        }
    }
    
    //MARKS :跳转到下一个页面传值(手动)
    func prepareForData(destinationController:ResourceDetailViewController,indexPath:NSIndexPath){
        let session = sessions[indexPath.section]
        let contact = session.contacts[indexPath.row]
        destinationController.indexPath = indexPath
        destinationController.parentController = self
        destinationController.photoImage = contact.photo
        destinationController.nameText = contact.name
        destinationController.weChatNumberText = "微信号:  test00\(indexPath.row + 1)"
        destinationController.photoNumberText = contact.phone
        //MARKS: 跳转视图后取消tableviewcell选中事件
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}
