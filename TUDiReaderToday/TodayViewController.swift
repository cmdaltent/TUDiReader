//
//  TodayViewController.swift
//  TUDiReaderToday
//
//  Created by Martin Weissbach on 1/19/15.
//  Copyright (c) 2015 Martin Weissbach. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDataSource {
    
    let persistenceStack = PersistenceStack()
    var items: NSSet?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition({ (context) -> Void in
            self.tableView.frame = CGRectMake(0, 0, size.width, size.height)
        }, completion: nil)
    }
    
    func updateData() -> NSSet? {
        let optionalPreselectedFeedID = persistenceStack.preselecteFeedID
        if optionalPreselectedFeedID == nil {
            return nil
        }
        let optionalPreselectedFeed = persistenceStack.feedForFeedID(optionalPreselectedFeedID!)
        if optionalPreselectedFeedID == nil {
            return nil
        }
        return optionalPreselectedFeed?.items
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        let newData = self.updateData()
        if newData == nil {
            completionHandler(NCUpdateResult.NoData)
            return
        }
        
        self.items = newData
        tableView.reloadData()
        updatePreferredContentSize()
        completionHandler(NCUpdateResult.NewData)
    }
    
    func updatePreferredContentSize() {
        var rows = 0
        if items != nil { rows = items!.count < 10 ? items!.count : 10 }
        preferredContentSize = CGSizeMake(0, (CGFloat(rows) * 44.0) + tableView.sectionFooterHeight)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let i = items? {
            return i.count < 10 ? i.count : 10
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("FeedItemPreviewCell") as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "FeedItemPreviewCell")
        }
        
        cell?.textLabel?.text = (items?.allObjects[indexPath.row] as Item).title
        
        return cell!
    }
}
