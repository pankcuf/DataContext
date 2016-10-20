//
//  ViewController.swift
//  DataContext
//
//  Created by Владимир Пирогов on 10/17/2016.
//  Copyright (c) 2016 Владимир Пирогов. All rights reserved.
//

import UIKit
import DataContext

extension UITableView: UITableViewDelegate, UITableViewDataSource {}

class ViewController: UITableViewController {

    override func viewDidLoad() {
		
		super.viewDidLoad()

		self.tableView.requestContextUpdates(DiscogsJsonRequest(artistID: 1102, responseType: DiscogsJsonResponse.self))
	}

	override func loadView() {

		let t = UITableView(frame: .zero, style: .plain)
		t.delegate = t
		t.dataSource = t
		t.context = DiscogsTableContext(transport: JSONSessionTransport.shared)
	
		self.view = t
	}
}

