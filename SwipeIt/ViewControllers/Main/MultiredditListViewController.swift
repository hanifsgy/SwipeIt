//
//  MultiredditListViewController.swift
//  Reddit
//
//  Created by Ivan Bruel on 06/05/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import RxSwift
import NSObject_Rx
import RxDataSources

// MARK: Properties
class MultiredditListViewController: UIViewController, InsettableScrollViewViewController {

  // MARK: Static Properties
  fileprivate static let estimatedTableViewCellHeight: CGFloat = 60

  // MARK: IBOutlets
  @IBOutlet fileprivate weak var tableView: UITableView! {
    didSet {
      tableView.estimatedRowHeight = MultiredditListViewController.estimatedTableViewCellHeight
      tableView.rowHeight = UITableViewAutomaticDimension
    }
  }

  // MARK: Public Properties
  var viewModel: MultiredditListViewModel!

  // MARK: InsettableScrollViewViewController Property
  var topScrollInset: CGFloat = 0
}

// MARK: Lifecycle
extension MultiredditListViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    tableView.deselectRows(true)
  }
}

// MARK: Setup
extension MultiredditListViewController {

  fileprivate func setup() {
    bindTableView()
    setupInsettableScrollView(tableView)
    viewModel.requestMultireddits()
  }

  fileprivate func bindTableView() {
    let dataSource =
      RxTableViewSectionedReloadDataSource<SectionViewModel<MultiredditListItemViewModel>>()

    dataSource.configureCell = { (_, tableView, indexPath, viewModel) in
      let cell = tableView.dequeueReusableCell(MultiredditListItemTableViewCell.self,
                                               indexPath: indexPath)
      cell.viewModel = viewModel
      return cell
    }

    dataSource.titleForHeaderInSection = { (dataSource, index) in
      return dataSource[index].title
    }

    dataSource.sectionIndexTitles = { dataSource in
      return dataSource.sectionModels.map { $0.title }
    }

    dataSource.sectionForSectionIndexTitle = { (_, _, index) in
      return index
    }

    viewModel
      .viewModels
      .bindTo(tableView.rx.items(dataSource: dataSource))
      .addDisposableTo(rx_disposeBag)
  }

}

// MARK: Segues
extension MultiredditListViewController {

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let segueEnum = StoryboardSegue.Main(optionalRawValue: segue.identifier) else { return }

    if let linkSwipeViewController = segue.navigationRootViewController as? LinkSwipeViewController,
      let cell = sender as? MultiredditListItemTableViewCell, segueEnum == .linkList {
      linkSwipeViewController.viewModel = cell.viewModel.linkSwipeViewModel
    }
  }
}
