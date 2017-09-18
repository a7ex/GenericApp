//
//  RefreshControlWrapper.swift

import UIKit

/// This is an AppleTV (TVOS) compatible wrapper for the UIRefreshControl class

#if os(tvOS)
    public class TVRefreshControl: UIView {
        public var refreshing = false
        public final func addTarget(target: AnyObject?, action: Selector, forControlEvents controlEvent: UIControlEvents) {

        }
        public func addToTableView(targetTable: UITableView?) {

        }
        public final func endRefreshing() {

        }
    }
#else
    open class TVRefreshControl: UIRefreshControl {
        open func addToTableView(_ targetTable: UITableView) {
            targetTable.addSubview(self)
        }
    }
#endif
