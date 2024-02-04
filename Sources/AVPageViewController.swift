//
//  AVPageViewController.swift
//

import UIKit

class AVPageViewController: UIPageViewController {
    
    var subviewControllers: Array<UIViewController> = [] {
        didSet {
            show(0)
        }
    }
    
    typealias Completion = (Int) -> Void
    
    var completion: Completion?
    
    convenience init() {
        self.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        view.backgroundColor = .clear
    }
    
}

extension AVPageViewController {
    
    func show(_ index: Int) {
        guard let viewControllers = viewControllers else { return }
        if viewControllers.count == 0 {
            setViewControllers([subviewControllers[index]], direction: .forward, animated: true, completion: nil)
        }
        else {
            guard let page = subviewControllers.firstIndex(of: viewControllers[0]) else { return }
            if page < index {
                setViewControllers([subviewControllers[index]], direction: .forward, animated: true, completion: nil)
            }
            else if page > index {
                setViewControllers([subviewControllers[index]], direction: .reverse, animated: true, completion: nil)
            }
        }
    }
    
}

extension AVPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = subviewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        guard subviewControllers.count > previousIndex else {
            return nil
        }
        return subviewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = subviewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = subviewControllers.count
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        return subviewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewControllers = viewControllers,
              let page = subviewControllers.firstIndex(of: viewControllers[0]) else { return }
        completion?(page)
    }
    
}
