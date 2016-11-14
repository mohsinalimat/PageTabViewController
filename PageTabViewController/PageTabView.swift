//
//  PageTabView.swift
//  PageTabViewController
//
//  Created by svpcadmin on 11/11/16.
//  Copyright © 2016 tamanyan. All rights reserved.
//

import UIKit

class PageTabView: UIView {
    fileprivate var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(PageTabCollectionCell.self, forCellWithReuseIdentifier: PageTabCollectionCell.cellIdentifier)
        collectionView.scrollsToTop = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    fileprivate let titles: [String]

    let options: MenuViewConfigurable

    var menuItemWidth: CGFloat {
        let mode: MenuItemWidthMode = { [unowned self] in
            switch self.options.displayMode {
            case .infinite(let widthMode):
                return widthMode
            case .standard(let widthMode, centerItem: _):
                return widthMode
            }
        }()
        switch mode {
        case .fixed(let width):
            return width
        case .flexible:
            return 0
        }
    }

    init(titles: [String], options: MenuViewConfigurable) {
        self.titles = titles
        self.options = options
        super.init(frame: CGRect.zero)

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = .white
        self.addSubview(self.collectionView)
        let top = NSLayoutConstraint(item: self.collectionView,
            attribute: .top,
            relatedBy: .equal,
            toItem: self,
            attribute: .top,
            multiplier: 1.0,
            constant: 0.0)

        let left = NSLayoutConstraint(item: self.collectionView,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self,
            attribute: .leading,
            multiplier: 1.0,
            constant: 0.0)

        let bottom = NSLayoutConstraint (item: self,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self.collectionView,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 0.0)

        let right = NSLayoutConstraint(item: self,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: self.collectionView,
            attribute: .trailing,
            multiplier: 1.0,
            constant: 0.0)

        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([top, left, bottom, right])
    }

    func getTitle(byIndex index: Int) -> String {
        let index = index % self.titles.count
        return self.titles[index]
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PageTabView: UICollectionViewDataSource {
    fileprivate var dummyCount: Int {
        return self.titles.count * 3
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dummyCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PageTabCollectionCell.cellIdentifier, for: indexPath) as! PageTabCollectionCell
        cell.titleLabel.text = self.getTitle(byIndex: indexPath.row)
        cell.titleLabel.frame = CGRect(origin: CGPoint.zero, size: cell.frame.size)
        return cell
    }
}

extension PageTabView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.menuItemWidth
        if width <= 0 {
            let title = self.getTitle(byIndex: indexPath.row) as NSString
            let size = title.size(attributes: [
                NSFontAttributeName: PageTabCollectionCell.cellFont
            ])
            return CGSize(width: size.width + 10, height: self.options.height)
        } else {
            return CGSize(width: width, height: self.options.height)
        }
    }
}

extension PageTabView: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageTabItemsWidth = floor(scrollView.contentSize.width / 3.0)

        if (scrollView.contentOffset.x <= 0.0) || (scrollView.contentOffset.x > pageTabItemsWidth * 2.0) {
            scrollView.contentOffset.x = pageTabItemsWidth
        }
    }
}
