//
//  ViewController.swift
//  GithubSearchApp
//
//  Created by pandaman on 2020/05/18.
//  Copyright © 2020 pandaman. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxViewController
import SafariServices

class ViewController: UIViewController {
  
  private lazy var searchBar = UISearchBar().then {
    $0.barStyle = .default
  }
  private lazy var tableView = UITableView().then {
    $0.dataSource = self
    $0.delegate = self
    $0.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
  }
  let disposeBag = DisposeBag()
  
  var shownRepoAndURLs: [(String, String)] = [] {
    didSet {
      self.tableView.reloadData()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    // Do any additional setup after loading the view.
    DispatchQueue.main.async {
      self.setupUI()
      self.setupCosntraints()
      DispatchQueue.main.async {
        self.setupSearchBar()
      }
    }
  }
  
  private func setupUI() {
    view.addSubviews([searchBar, tableView])
    setupCosntraints()
  }
  
  private func setupCosntraints() {
    searchBar.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
      $0.height.equalTo(view).multipliedBy(0.1)
    }
    
    tableView.snp.makeConstraints {
      $0.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
      $0.top.equalTo(searchBar.snp.bottom)
    }
  }
  
  func setupSearchBar() {
      self.searchBar.rx.text
        .orEmpty
        .debounce(.microseconds(500), scheduler: MainScheduler.instance)
        .distinctUntilChanged()
        .filter { !$0.isEmpty }
        .subscribe(onNext: { [unowned self] query in
          self.SeachRepositoryWith(keyword: query)
        })
        .disposed(by: self.disposeBag)
    }
  
  func SeachRepositoryWith(keyword: String) {
    APIManager.shared.getRepository(keyword: keyword) { (result) in
      switch result {
      case .success(let data):
        DispatchQueue.main.async {
          self.shownRepoAndURLs =
            zip(data.items.map{$0.name}, data.items.map{ $0.htmlURL })
              .map{ ($0, $1) }
        }
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    shownRepoAndURLs.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.textLabel?.text = shownRepoAndURLs[indexPath.row].0
    print(shownRepoAndURLs[indexPath.row])
    return cell
  }
}

extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let url = URL(string: shownRepoAndURLs[indexPath.row].1) else { return }
    let safariViewController = SFSafariViewController(url: url)
    present(safariViewController, animated: true)
  }
}
