//
//  IntroVC.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 14/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit

class IntroVC: CoreViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var collectView: CoreCollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnNext: CoreButton!
    @IBOutlet weak var btnskip: CoreButton!
    
    private var count = 0
    private var sliderArray = [Slider]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        collectView.register(IntroCollectCell.nib, forCellWithReuseIdentifier: IntroCollectCell.identifier)
        let scale = Constants.isIphone() ? 1.5 : 1.8
        pageControl.transform = CGAffineTransform(scaleX: CGFloat(scale), y: CGFloat(scale))
        handleClicks()
        sliderApiCall(isLoader: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)        
    }
}

//MARK:- Handle Clicks
extension IntroVC {
    
    private func handleClicks() {
        btnskip.handleTap = {
            self.redirectToChooseUserScreen()
        }
        btnNext.handleTap = {
            if self.collectView.numberOfItems(inSection: 0) > (self.count + 1) {
                var nextIndexPath = IndexPath(item: self.count, section: 0)
                nextIndexPath.item = self.count + 1
                if nextIndexPath.item == self.sliderArray.count {
                    self.btnNext.setTitle("Enter".localized, for: .normal)
                }else {
                    self.btnNext.setTitle("Next".localized, for: .normal)
                }
                self.collectView.scrollToItem(at: nextIndexPath, at: .left, animated: true)
                UIView.animate(withDuration: 0.2) {
                    self.pageControl.currentPage = nextIndexPath.item
                }
            } else {
                self.redirectToChooseUserScreen()
            }
        }
    }
}

//MARK:- CollectionView Methods
extension IntroVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = sliderArray.count
        return sliderArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IntroCollectCell.identifier, for: indexPath) as! IntroCollectCell
        cell.imgViewHeight.constant = (collectView.frame.height / 1.5)
        cell.imgViewWidth.constant = collectView.frame.width
        cell.imgView.sd_setImage(with: URL(string: sliderArray[indexPath.item].image ?? ""))
        cell.lblDesc.text = sliderArray[indexPath.item].description
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(collectView.frame.width, collectView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        count = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        if self.pageControl.currentPage == 4 {
            self.btnNext.setTitle("Enter".localized, for: .normal)
        }else {
            self.btnNext.setTitle("Next".localized, for: .normal)
        }
    }
}

//MARK:- API CALL
extension IntroVC {
    
    private func sliderApiCall(isLoader: Bool) {
        APIClient.slider(type: "Introduction", doShowLoading: isLoader) { (result) in
            switch result {
            case .success(var response):
                self.sliderArray = response.getSlider() ?? []
                self.collectView.reloadData()
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
