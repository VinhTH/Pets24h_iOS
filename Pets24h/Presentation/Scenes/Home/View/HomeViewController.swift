//
//  HomeViewController.swift
//  Pets24h
//
//  Created by Vinh Huynh on 11/20/19.
//  Copyright © 2019 Vinh Huynh. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let horizontalPadding: CGFloat = 36
    
    lazy var categories: [HomeCategory] = HomeViewController.testData
    
    private(set) var viewModel: HomeViewModel!
    
    // MARK: Static
    final class func create(with viewModel: HomeViewModel) -> HomeViewController {
        let view = HomeViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
        
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
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categories[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withType: CategoryTableViewCell.self, for: indexPath) as? CategoryTableViewCell else {
            fatalError("Unable to dequeue reusable cell \(CategoryTableViewCell.self)")
        }
        cell.reloadCell(withCategory: category)
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let tempVC = TempViewController.create()
        navigationController?.pushViewController(tempVC, animated: true)
    }
}

extension HomeViewController {
    static var testData: [HomeCategory] = [
        HomeCategory(
            id: "i1",
            title: "Watch to Watch",
            subtitle: "",
            isViewableAll: true,
            colors: [0xFAFAFA, 0xF2F2F2],
            items: [
                CategoryItem(id: "i1", title: "Dora", thumb: ""),
                CategoryItem(id: "i2", title: "Dora", thumb: ""),
                CategoryItem(id: "i3", title: "Dora", thumb: ""),
                CategoryItem(id: "i4", title: "Dora", thumb: ""),
                CategoryItem(id: "i5", title: "Dora", thumb: ""),
                CategoryItem(id: "i6", title: "Dora", thumb: ""),
                CategoryItem(id: "i1", title: "Dora", thumb: ""),
                CategoryItem(id: "i2", title: "Dora", thumb: ""),
                CategoryItem(id: "i3", title: "Dora", thumb: ""),
                CategoryItem(id: "i4", title: "Dora", thumb: ""),
                CategoryItem(id: "i5", title: "Dora", thumb: ""),
                CategoryItem(id: "i6", title: "Dora", thumb: ""),
                CategoryItem(id: "i1", title: "Dora", thumb: ""),
                CategoryItem(id: "i2", title: "Dora", thumb: ""),
                CategoryItem(id: "i3", title: "Dora", thumb: ""),
                CategoryItem(id: "i4", title: "Dora", thumb: ""),
                CategoryItem(id: "i5", title: "Dora", thumb: ""),
                CategoryItem(id: "i6", title: "Dora", thumb: ""),
            ]
        ),
        HomeCategory(
            id: "i2",
            title: "Learn About the Apple TV App",
            subtitle: "",
            isViewableAll: false,
            colors: [0xFFFFFF, 0xFAFAFA],
            items: [
                CategoryItem(id: "i1", title: "Dora", thumb: ""),
                CategoryItem(id: "i2", title: "Dora", thumb: ""),
                CategoryItem(id: "i3", title: "Dora", thumb: ""),
                CategoryItem(id: "i4", title: "Dora", thumb: ""),
                CategoryItem(id: "i5", title: "Dora", thumb: ""),
                CategoryItem(id: "i6", title: "Dora", thumb: ""),
            ]
        ),
        HomeCategory(
            id: "i3",
            title: "Sports Dramas: Knockout Prices",
            subtitle: "Score a winning deal with offers on these athletic flicks.",
            isViewableAll: true,
            colors: [0xFAFAFA, 0xF2F2F2],
            items: [
                CategoryItem(id: "i1", title: "Dora", thumb: ""),
                CategoryItem(id: "i2", title: "Dora", thumb: ""),
                CategoryItem(id: "i3", title: "Dora", thumb: ""),
                CategoryItem(id: "i4", title: "Dora", thumb: ""),
                CategoryItem(id: "i5", title: "Dora", thumb: ""),
                CategoryItem(id: "i6", title: "Dora", thumb: ""),
            ]
        ),
        HomeCategory(
            id: "i4",
            title: "Watch the Apple Original",
            subtitle: "",
            isViewableAll: false,
            colors: [0xFFFFFF, 0xFAFAFA],
            items: [
                CategoryItem(id: "i1", title: "Dora", thumb: ""),
                CategoryItem(id: "i2", title: "Dora", thumb: ""),
                CategoryItem(id: "i3", title: "Dora", thumb: ""),
                CategoryItem(id: "i4", title: "Dora", thumb: ""),
                CategoryItem(id: "i5", title: "Dora", thumb: ""),
                CategoryItem(id: "i6", title: "Dora", thumb: ""),
            ]
        ),
        HomeCategory(
            id: "i5",
            title: "Iconic Moments: Limited-Time Prices",
            subtitle: "Relive some of film's most-loved scenes with these classics",
            isViewableAll: true,
            colors: [0xFAFAFA, 0xF2F2F2],
            items: [
                CategoryItem(id: "i1", title: "Dora", thumb: ""),
                CategoryItem(id: "i2", title: "Dora", thumb: ""),
                CategoryItem(id: "i3", title: "Dora", thumb: ""),
                CategoryItem(id: "i4", title: "Dora", thumb: ""),
                CategoryItem(id: "i5", title: "Dora", thumb: ""),
                CategoryItem(id: "i6", title: "Dora", thumb: ""),
            ]
        ),
        HomeCategory(
            id: "6",
            title: "Movies That Inspired TV: Hot Offers",
            subtitle: "Movies so good they demanded a small-screen spin-off.",
            isViewableAll: true,
            colors: [0xFFFFFF, 0xF2F2F2],
            items: [
                CategoryItem(id: "i1", title: "Dora", thumb: ""),
                CategoryItem(id: "i2", title: "Dora", thumb: ""),
                CategoryItem(id: "i3", title: "Dora", thumb: ""),
                CategoryItem(id: "i4", title: "Dora", thumb: ""),
                CategoryItem(id: "i5", title: "Dora", thumb: ""),
                CategoryItem(id: "i6", title: "Dora", thumb: ""),
            ]
        ),
        HomeCategory(
            id: "i7",
            title: "Exclusive Ofers",
            subtitle: "",
            isViewableAll: false,
            colors: [0xFFFFFF, 0xF2F2F2],
            items: [
                CategoryItem(id: "i1", title: "Dora", thumb: ""),
                CategoryItem(id: "i2", title: "Dora", thumb: ""),
                CategoryItem(id: "i3", title: "Dora", thumb: ""),
                CategoryItem(id: "i4", title: "Dora", thumb: ""),
                CategoryItem(id: "i5", title: "Dora", thumb: ""),
                CategoryItem(id: "i6", title: "Dora", thumb: ""),
            ]
        ),
        HomeCategory(
            id: "i8",
            title: "Editor's Choice",
            subtitle: "",
            isViewableAll: false,
            colors: [0xFFFFFF, 0xF2F2F2],
            items: [
                CategoryItem(id: "i1", title: "Dora", thumb: ""),
                CategoryItem(id: "i2", title: "Dora", thumb: ""),
                CategoryItem(id: "i3", title: "Dora", thumb: ""),
                CategoryItem(id: "i4", title: "Dora", thumb: ""),
                CategoryItem(id: "i5", title: "Dora", thumb: ""),
                CategoryItem(id: "i6", title: "Dora", thumb: ""),
            ]
        ),
    ]
}
