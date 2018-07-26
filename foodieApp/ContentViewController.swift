//
//  ContentViewController.swift
//  InstagramStories
//
//  Created by mac05 on 05/10/17.
//

import UIKit

var ContentViewControllerVC = ContentViewController()

class ContentViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var pageViewController : UIPageViewController?
   // var pages = [[String: Any]]()
    var currentIndex : Int = 0
    
  var pages  = [
    ["name" : "Keila Maney", "pro-image" : "pro-img-3",
    "items": [["content" : "image", "item" : "img-3"], ["content" : "video", "item" : "output"], ["content" : "video", "item" : "output2"]]],
    ["name" : "Gilberto", "pro-image" : "pro-img-1",
    "items": [["content" : "video", "item" : "output3"], ["content" : "image", "item" : "img-4"], ["content" : "image", "item" : "img-5"], ["content" : "video", "item" : "output"]]],
    ["name" : "Jonathan", "pro-image" : "pro-img-2",
    "items": [["content" : "image", "item" : "img-1"], ["content" : "video", "item" : "output2"]]],
    ["name" : "Delmer", "pro-image" : "pro-img-4",
    "items": [["content" : "image", "item" : "img-2"], ["content" : "video", "item" : "output"], ["content" : "image", "item" : "img-3"]]],
    ["name" : "Carolyne", "pro-image" : "pro-img-3",
    "items": [["content" : "video", "item" : "output"], ["content" : "image", "item" : "img-4"], ["content" : "video", "item" : "output3"], ["content" : "image", "item" : "img-3"]]],
    ["name" : "Sabine", "pro-image" : "pro-img-5",
    "items": [["content" : "video", "item" : "output2"], ["content" : "image", "item" : "img-5"], ["content" : "video", "item" : "output3"]]],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.tabBarController?.tabBar.isHidden = true
        
        // Do any additional setup after loading the view.
        ContentViewControllerVC = self
        pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as? UIPageViewController
        pageViewController!.dataSource = self
        pageViewController!.delegate = self
        
        let startingViewController: PreViewController = viewControllerAtIndex(index: currentIndex)!
        let viewControllers = [startingViewController]
        pageViewController!.setViewControllers(viewControllers , direction: .forward, animated: false, completion: nil)
        pageViewController!.view.frame = view.bounds
        
        addChildViewController(pageViewController!)
        view.addSubview(pageViewController!.view)
        view.sendSubview(toBack: pageViewController!.view)
        pageViewController!.didMove(toParentViewController: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
         self.tabBarController?.tabBar.isHidden = false
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - UIPageViewControllerDataSource
    //1
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! PreViewController).pageIndex
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        index -= 1
        return viewControllerAtIndex(index: index)
    }
    
    //2
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PreViewController).pageIndex
        if index == NSNotFound {
            return nil
        }
        index += 1
        if (index == self.pages.count) {
            return nil
        }
        return viewControllerAtIndex(index: index)
    }
    
    //3
    func viewControllerAtIndex(index: Int) -> PreViewController? {
        if self.pages.count == 0 || index >= self.pages.count {
            return nil
        }
        
        // Create a new view controller and pass suitable data.
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PreView") as! PreViewController
        vc.pageIndex = index
        vc.items = self.pages
        currentIndex = index
        
        vc.view.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        return vc
    }
    
    // Navigate to next page
    func goNextPage(fowardTo position: Int) {
        let startingViewController: PreViewController = viewControllerAtIndex(index: position)!
        let viewControllers = [startingViewController]
        pageViewController!.setViewControllers(viewControllers , direction: .forward, animated: true, completion: nil)
    }
    
    // MARK: - Button Actions
    @IBAction func closeAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
