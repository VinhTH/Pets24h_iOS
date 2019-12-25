//
//  CategoryTableViewCell.swift
//  Pets24h
//
//  Created by Vinh Huynh on 11/21/19.
//  Copyright © 2019 Vinh Huynh. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var viewAllButton: UIButton!
    
    private var viewModel: HomeCatagoryViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cell: CarouselCollectionViewCell.self)
    }
    
    func fill(with viewModel: HomeCatagoryViewModel) {
        self.viewModel = viewModel
        collectionView.reloadData()
        viewAllButton.isHidden = false
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        gradientView.colors = [0xFFFFFF, 0xF2F2F2].map({
            UIColor(hex: $0).cgColor
        })
    }
}

// MARK: UICollectionViewDatasource
extension CategoryTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withType: CarouselCollectionViewCell.self, for: indexPath) as? CarouselCollectionViewCell else {
            fatalError("Unable to dequeue reusable cell \(CarouselCollectionViewCell.self)")
        }
        cell.fill(with: viewModel.items[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension CategoryTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 115*16/9, height: 115)
    }
}

// MARK: UICollectionViewDelegate
extension CategoryTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelect(viewModel.items[indexPath.row])
    }
}

// MARK: UIScrollViewDelegate
extension CategoryTableViewCell: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let itemSize = CGSize(width: 115*16/9, height: 115)
        collectionView.beautifyContentOffsetOnScrollingHorizontal(withItemSize: itemSize,
                                                                  targetContentOffset: targetContentOffset)
    }
}

extension UICollectionView {
    func beautifyContentOffsetOnScrollingHorizontal(withItemSize itemSize: CGSize,
                                                    targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        guard let collectionFlowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            fatalError("\(#function) just support \(UICollectionViewFlowLayout.self)")
        }
        
        guard collectionFlowLayout.scrollDirection == .horizontal else {
            fatalError("\(#function) jus support horizontal direction")
        }
        
        print("=============")
        print("Origin target:", targetContentOffset.pointee.x)
        
        let itemWidth = itemSize.width
        let offsetSwitchToNextIndex = itemWidth/3
        let lineSpacing = collectionFlowLayout.minimumLineSpacing
        let sectionInsetLeft = collectionFlowLayout.sectionInset.left
        let beautyOffset = sectionInsetLeft
        let contenSize = collectionFlowLayout.collectionViewContentSize
        
        /// (A) Try to find index path at target content offset x (X) and center vertical
        /// bounds.height/2 to make point at center of vertical in the collection view
        var indexPathAtTargetContentOffset = indexPathForItem(at: CGPoint(x: targetContentOffset.pointee.x, y: bounds.height/2))
        if indexPathAtTargetContentOffset == nil {
            /// Unable to find index path at case (A)
            /// The reason of missed case (A) is (X) at line spacing or section inset
            /// Thus, (B) we will try to find index path at (X) plus line spacing or section inset left (choose which one larger)
            let point = CGPoint(x: targetContentOffset.pointee.x + max(sectionInsetLeft, lineSpacing), y: bounds.height/2)
            indexPathAtTargetContentOffset = indexPathForItem(at: point)
        }
        
        guard let indexPath = indexPathAtTargetContentOffset else {
            print("\(#function) Unable to find the index path at the target content offset")
            return
        }
        
        print("Index at target point:", indexPath.row)
        
        let isScrollableToLastestIndex = targetContentOffset.pointee.x + bounds.width >= contenSize.width
        if isScrollableToLastestIndex {
            print("Scroll to lastest index")
            let targetPointAtLastestIndex = CGPoint(x: contenSize.width - bounds.width, y: targetContentOffset.pointee.y)
            targetContentOffset.pointee = targetPointAtLastestIndex
        } else {
            let pointX_AtIndexPath = sectionInsetLeft + lineSpacing*CGFloat(indexPath.row) + itemWidth*CGFloat(indexPath.row)
            let isScrollableToNextIndex = targetContentOffset.pointee.x > pointX_AtIndexPath + offsetSwitchToNextIndex
            
            var beautyPointX = pointX_AtIndexPath
            if isScrollableToNextIndex {
                print("Beautify at next index:", indexPath.row + 1)
                beautyPointX = sectionInsetLeft + lineSpacing*CGFloat(indexPath.row + 1) + itemWidth*CGFloat(indexPath.row + 1)
            }
            targetContentOffset.pointee.x = beautyPointX - beautyOffset
        }
        
        print("Beaty target:", targetContentOffset.pointee.x)
    }
}
