//
//  EventViewController.swift
//  Employee
//
//  Created by Gohar on 6/16/17.
//  Copyright © 2017 secretOrganization. All rights reserved.
//

import UIKit

class EventViewController: ViewController, UITableViewDataSource, UITableViewDelegate, EventCellDelegate {
    
    @IBOutlet weak var segmentControlView:JMSegmentedControlView? {
        didSet {
            segmentControlView?.backgroundColor = UIColor.jmBlueColor
            segmentControlView?.segmentDelegate = self
        }
    }
    
    @IBOutlet weak var emptyView: UIView?
    @IBOutlet weak var eventTableView: UITableView? {
        didSet {
            eventTableView?.delegate = self;
            eventTableView?.dataSource = self
            
            eventTableView?.rowHeight = UITableViewAutomaticDimension
            eventTableView?.estimatedRowHeight = 50
            
            eventTableView?.register(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "eventCell")
            eventTableView?.register(UINib(nibName: "CanceledEventTableViewCell", bundle: nil), forCellReuseIdentifier: "eventCanceledCell")
        }
    }
    
    var eventLists = [EventModel]()
    var currentUser:UserModel? {
        return UserRequestsService().currentUser
    }
    
    var index = 0
    var refresher : UIRefreshControl?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "add"), style: .done, target: self, action: #selector(addBarButtonClicked))
        refresher = UIRefreshControl()
        refresher?.addTarget(self, action: #selector(updateFeed), for: UIControlEvents.valueChanged)
        eventTableView?.addSubview(refresher!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addBarButtonClicked(_ sender: UIBarButtonItem) {
        let createEventVC = getViewControllerWithStoryBoard(sbName: "EventsAndPrivate", vcIndentifier: "CreateEventsViewController")
        self.navigationController?.pushViewController(createEventVC!, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventLists.count
    }
    
    
    func updateFeed(){
        
        reloadDatas {
            self.refresher?.endRefreshing()
        }
        
    }
    
    
    func reloadDatas(complete: @escaping ()->())  {
        // complete()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let event = eventLists[indexPath.row]
        let ident = event.canceled ? "eventCanceledCell" : "eventCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: ident, for: indexPath) as? EventTableViewCell
        cell?.updateEventData(event: eventLists[indexPath.row])
        cell?.delegate = self
        return cell!
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let eventView = self.getViewControllerWithStoryBoard(sbName: "EventsAndPrivate", vcIndentifier: "EventViewController") as? EventViewController {
            eventView.currentEvent = eventLists[indexPath.row]
            self.navigationController?.pushViewController(eventView, animated: true)
        }
    }
    
    
    
    //MARK: EventcellDelegate
    
    func didTapCellActionButton(actionType: EventActionType, cell: EventTableViewCell) {
        let selectedIndex = eventTableView?.indexPath(for: cell)
        let ev = eventLists[(selectedIndex?.row)!]
        
        if actionType == .like {
            EventsRequestsService().likeEvent(event_id: ev.id, success: { (likeSuccess: Any) in
                if let likeCount = likeSuccess as? Int {
                    self.eventLists[(selectedIndex?.row)!].likes = "\(likeCount)"
                    self.eventTableView?.reloadRows(at: [selectedIndex!], with: .automatic)
                }
            }, failer: { (error:String) in
                self.showAlertView(error, message: nil, completion: nil)
            })
        }
        else if actionType == .participants {
            if let vc = self.getViewControllerWithStoryBoard(sbName: "EventsAndPrivate", vcIndentifier: "EventParticipersViewController") as? EventParticipersViewController {
                vc.title = ev.title
                vc.event_id = ev.id
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if actionType == .comments{
            if let vc = self.getViewControllerWithStoryBoard(sbName: "EventsAndPrivate", vcIndentifier: "EventViewController") as? EventViewController {
                vc.currentEvent = ev
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    }
    
    func didSelectSegmentAt(index: Int) {
        print(index)
    }
    
}
