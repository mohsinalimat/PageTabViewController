//
//  MenuViewConfigurable.swift
//  PageTabViewController
//
//  Created by svpcadmin on 11/11/16.
//  Copyright © 2016 tamanyan. All rights reserved.
//

import Foundation

public protocol MenuViewConfigurable {
    var backgroundColor: UIColor { get }
    var selectedBackgroundColor: UIColor { get }
    var height: CGFloat { get }
    var displayMode: MenuDisplayMode { get }
    var menuPosition: MenuPosition { get }
}

public enum MenuItemWidthMode {
    case flexible
    case fixed(width: CGFloat)
}

public enum MenuDisplayMode {
    case standard(widthMode: MenuItemWidthMode, centerItem: Bool)
    case infinite(widthMode: MenuItemWidthMode)
}

public enum MenuPosition {
    case top
    case bottom
}

extension MenuViewConfigurable {
    var backgroundColor: UIColor {
        return .white
    }

    var selectedBackgroundColor: UIColor {
        return .white
    }

    var height: CGFloat {
        return 66
    }

    var displayMode: MenuDisplayMode {
        return .standard(widthMode: .fixed(width: 30), centerItem: true)
    }

    var menuPosition: MenuPosition {
        return .top
    }
}