//
//  BaseVC.swift

import UIKit

class BaseVC: UIViewController {

    // MARK: - Public vars

    weak var currentFirstResponder: UIResponder?
    var keyboardEndframe = CGRect.zero
    var zoomTransitionAnimator: ZoomNavigationAnimator?

    lazy var activityIndicatorView: OverlayView = {
        return OverlayView(type: OverlayViewType.activityIndicatorFullscreenGray)
    }()

    // Table Refresh control:
    private var refreshControlInstance: TVRefreshControl?

    open var refreshControl: TVRefreshControl {
        get {
            if let refreshControlInstance = refreshControlInstance {
                return refreshControlInstance
            }
            let refreshControl = TVRefreshControl()
            refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
            refreshControlInstance = refreshControl
            return refreshControl
        }
        set (value) {
            refreshControlInstance = value
        }
    }

    fileprivate weak var hideKeyboardTapGesture: UIGestureRecognizer?
    var keyboardLayoutChanges = [String: LayoutConstrainInfo]()
    var storedOriginalConstraints = [String: LayoutConstrainInfo]()
    var storedOriginalContentInset = [String: ContentInsetInfo]()

    // MARK: - Types

    struct LayoutConstrainInfo {
        weak var constraint: NSLayoutConstraint?
        var constant: CGFloat
    }

    struct ContentInsetInfo {
        weak var scrollView: UIScrollView?
        var insets: UIEdgeInsets
    }

    // MARK: - ViewController lifecycle

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let notificationCenter = NotificationCenter.default

        notificationCenter.addObserver(self, selector: #selector(contentSizeCategoryDidChange(_:)), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)

        #if !os(tvOS)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        #endif

        notificationCenter.addObserver(self, selector: #selector(appWillEnterForegroundNotification(_:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)

        if hidesKeyboardOnTap() {
            let tap = UITapGestureRecognizer(target:self, action: #selector(hideKeyboardIfPresent(_:)))
            tap.cancelsTouchesInView = false
            tap.delegate = self
            view.addGestureRecognizer(tap)
            hideKeyboardTapGesture = tap
        }
    }

    override func viewWillDisappear(_ animated: Bool) {

        hideKeyboard()

        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name:NSNotification.Name.UIContentSizeCategoryDidChange, object:nil)

        #if !os(tvOS)
            notificationCenter.removeObserver(self, name:NSNotification.Name.UIKeyboardWillChangeFrame, object:nil)
        #endif

        notificationCenter.removeObserver(self, name: NSNotification.Name.UIApplicationWillEnterForeground, object:nil)

        if let gest = hideKeyboardTapGesture {
            view.removeGestureRecognizer(gest)
            hideKeyboardTapGesture = nil
        }

        super.viewWillDisappear(animated)
    }

    // MARK: - Navigation bar appearance

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    /// Get the height of the navigationbar and the statusbar. Use this variable to define the contentInset.top of scrollviews
    // which appear under translucent top bars and where iOS doesn't set this value automatically for us
    // that happens for example, if the scrollview is not the first scrollview in the viewcontroller scene or if it
    // is not adjacent to the top bar
    var currentTopBarHeight: CGFloat {
        if let navigationBar = navigationController?.navigationBar {
            return navigationBar.frame.height + navigationBar.frame.origin.y
        }
        if UIApplication.shared.isStatusBarHidden {
            return 0.0
        }
        return UIApplication.shared.statusBarFrame.size.height
    }

// MARK: - Notifications callbacks

    /**
     Override this method to get an event, when the user changes the textSize in the System Preferences during this viewcontroller is on screen

     - parameter notification: the notification object from the OS
     */
    @objc
    func contentSizeCategoryDidChange(_ notification: Notification) {
    }

    /**
     Override this method to get an event, when the app comes to the foreground
     (e.g. to deselect the selected tablerow, which lead to the external browser)

     - parameter notification: the notification object from the OS
     */
    @objc
    func appWillEnterForegroundNotification(_ notification: Notification) {
    }

    // MARK: - keyboard handling notifications callbacks

    @objc
    func keyboardWillChangeFrame(_ notification: Notification) {
        #if !os(tvOS)
            if let info = (notification as NSNotification).userInfo,
                let duration = (info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.floatValue,
                let kbdEndframe = info[UIKeyboardFrameEndUserInfoKey] as? CGRect {
                keyboardEndframe = view.convert(kbdEndframe, from: UIScreen.main.coordinateSpace)

                prepareKeyboardChangeAnimation(notification)

                UIView.animate(withDuration: TimeInterval(duration), animations: { () -> Void in
                    self.keyboardChangeAnimation(notification)
                }, completion: { (_) -> Void in
                    self.keyboardChangeAnimationCompleted(notification)
                })
            }
        #endif
    }

    // callback from gesture recognizer
    @objc
    func hideKeyboardIfPresent(_ recognizer: UITapGestureRecognizer) {
        hideKeyboard()
    }

    final func dismissSelf() {
        if navigationController != nil {
            navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
        } else {
            presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: UIGestureRecognizerDelegate

extension BaseVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer == hideKeyboardTapGesture {
            if currentFirstResponder?.isFirstResponder == true {
                // only return true, if we didn't tap on a button
                // IMO cancelsTouchesInView = false should handle that, but for some strange reason it doesn't... :-(
                return !(touch.view is UIButton)
            } else {
                return false
            }
        }
        return true
    }
}

// MARK: - Table Refresh control

extension BaseVC {
    @objc
    open func handleRefresh(_ refreshControl: TVRefreshControl) {
        // override in subclass
    }

    final func stopRefreshing() {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
}

// MARK: - UITableView helpers

protocol TableViewController {
    var tableView: UITableView? { get }
}

extension TableViewController {
    func clearTableRowSelections() {
        tableView?.indexPathsForSelectedRows?.forEach { tableView?.deselectRow(at: $0, animated: true) }
    }
}

// MARK: - UICollectionView helpers

protocol CollectionViewController {
    var collectionView: UICollectionView? { get }
}

extension CollectionViewController {
    func clearCollectionCellSelections() {
        collectionView?.indexPathsForSelectedItems?.forEach { collectionView?.deselectItem(at: $0, animated: true) }
    }
}
