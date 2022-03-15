//
//  HomeController.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 15/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit

class HomeController: CoreViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var collectView: CoreCollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnViewListing: CoreButton!
    @IBOutlet weak var searchBar: CoreSearchBar!
    
    //MARK:- Properties
    private var sliderArray = [Slider]()
    var x = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        let scale = Constants.isIphone() ? 1.5 : 1.8
        pageControl.transform = CGAffineTransform(scaleX: CGFloat(scale), y: CGFloat(scale))
        collectView.register(HomeCollectCell.nib, forCellWithReuseIdentifier: HomeCollectCell.identifier)
        handleClicks()
        sliderApiCall(isLoader: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationbarUnderLineisShow = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationbarUnderLineisShow = true
    }
    
    //MARK:- HandleClicks
    private func handleClicks(){
        searchBar.shouldBeginEditingBlock = {
            let vc = FilterController.instantiateFromStoryboard()
            vc.isTap = true
            self.navigationController?.show(vc, sender: nil)
            return false
        }
        btnViewListing.handleTap = {
            let vc = HealthCareListController.instantiateFromStoryboard()
            self.navigationController?.show(vc, sender: nil)
        }
    }
    
    override func menuClicked() {
        let menuVC = SideMenuVC.instantiateFromStoryboard()
        let transition = CATransition().dynamicControllerPush(type: .moveIn, subType: .fromLeft, name: .linear, duration: 0.5)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.navigationController?.show(menuVC, sender: nil)
    }
}

extension HomeController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = sliderArray.count
        return sliderArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectCell.identifier, for: indexPath) as! HomeCollectCell
        cell.imgViewWidth.constant = collectView.frame.width
        cell.imgViewHeight.constant = collectView.frame.height
        cell.imgView.sd_setImage(with: URL(string: sliderArray[indexPath.item].image ?? ""))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectView.frame.width, height: collectView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        x = pageControl.currentPage
    }
        
    @objc func autoScroll() {
        if self.x < sliderArray.count {
            x = x == 0 ? 1 : x
            let indexPath = IndexPath(item: x, section: 0)
            self.pageControl.currentPage = x
            self.collectView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.x = self.x + 1
        } else {
            self.x = 0
            self.pageControl.currentPage = 0
            self.collectView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
}

//MARK:- API CALL
extension HomeController {
    
    private func sliderApiCall(isLoader: Bool) {
        APIClient.slider(type: "Home", doShowLoading: isLoader) { (result) in
            switch result {
            case .success(var response):
                self.sliderArray = response.getSlider() ?? []
                self.collectView.reloadData()
                let _ = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.autoScroll), userInfo: nil,
                repeats: true)
                break
            case .failure(let error):
                self.showMyAlert(desc: error.message ?? "", cancelTitle: "OK", cancelHandler: {
                    self.dismiss(animated: true, completion: nil)
                }, vc: self)
                break
            }
        }
    }
}
