//
//  HomeViewController.swift
//  Pets24h
//
//  Created by Vinh Huynh on 11/20/19.
//  Copyright © 2019 Vinh Huynh. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, StoryboardInstantiable, Alertable {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let horizontalPadding: CGFloat = 36
    
    private var viewModel: HomeViewModel!
    private var viewControllerFactory: HomeViewControllerFactory!
    
    // MARK: Static
    final class func create(with viewModel: HomeViewModel,
                            viewControllerFactory: HomeViewControllerFactory) -> HomeViewController {
        
        let view = HomeViewController.instantiateViewController()
        view.viewModel = viewModel
        view.viewControllerFactory = viewControllerFactory
        return view
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
        
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    // MARK: Private funcs
    private func setupTableView() {
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(cell: CategoryTableViewCell.self)
        tableView.makeNavigationBarBottomLineHeaderView(horizontalPadding: horizontalPadding)
    }
    
    private func setupNavigationBar() {
        title = "Watch Now"
        
        let button = UIButton()
        button.setImage(UIImage(named: "ic_3_eggs" ), for: .normal)
        button.addAction(for: .touchUpInside) {
            print("KJSHKJHDJKSHDKJSH")
        }        
        navigationController?.navigationBar.makeLargeNavigationBar(button)
    }
    
    private func bind(to viewModel: HomeViewModel) {
        viewModel.items.observer(on: self) { [weak self] categories in
            self?.reloadTableView()
        }
        viewModel.error.observer(on: self) { [weak self] error in
            self?.showError(error)
        }
        viewModel.route.observer(on: self) { [weak self] route in
            self?.handle(route)
        }
    }
    
    private func reloadTableView() {
        tableView.reloadData()
    }
    
    private func showError(_ error: String) {
        showAlert(message: error)
    }
    
    private func handle(_ route: HomeViewModelRoute) {
        switch route {
        case .initial: break
        case .showMovieDetail(let title):
            let viewController = viewControllerFactory.makeMovieDetailViewController(title: title)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withType: CategoryTableViewCell.self, for: indexPath) as? CategoryTableViewCell else {
            fatalError("Unable to dequeue reusable cell \(CategoryTableViewCell.self)")
        }
        cell.fill(with: viewModel.items.value[indexPath.row])
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    
}

protocol HomeViewControllerFactory {
    func makeMovieDetailViewController(title: String) -> UIViewController
}
