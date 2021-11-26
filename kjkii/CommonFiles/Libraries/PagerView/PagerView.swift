//
//  PagerView.swift
//  QaisApp
//
//  Created by Zuhair Hussain on 14/05/2019.
//  Copyright © 2019 Target. All rights reserved.
//

import UIKit
import Kingfisher

@objc protocol PagerViewDelegate {
    func pagerView(_ countDidZero:Bool)
    func pagerViewDidStartedDownloading(_ isDownloading:Bool)
    func pagerViewDidCompletedDownloading(_ isDownloaded:Bool)
}

//@IBDesignable
class PagerView: UIView{
    //MARK:- XIB Setup
    var view: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        customization()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        customization()
    }
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        addSubview(view)
        backgroundColor = .clear
        view.layoutIfNeeded()
    }
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
    //MARK:- APP CODE
    
    fileprivate func customization() {
        let nib = UINib(nibName: String(describing: PageCell.self), bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "PageCell")
        pageControl.pageIndicatorTintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        pageControl.currentPageIndicatorTintColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
    }
    
    struct PageModel {
        var url: URL?
        var image: UIImage?
        var placeholder: UIImage?
        var isAvailable:Bool?
        init(url: URL?, image: UIImage?, placeholder: UIImage?){
            self.url = url
            self.image = image
            self.placeholder = placeholder
        }
    }
    
    var kfOptions:KingfisherOptionsInfo?
    @objc var delegate:PagerViewDelegate?
    private var checked:Int = 0
    private var isDownloadingImage:Bool = false
    
    var timer1:Timer?
    var timer2:Timer?
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var pageControlCenterConstraint: NSLayoutConstraint!
    var pages:[PageModel] = [] {
        didSet {
            checked = -10 * pages.count
            startCheckingPageAvailable ()
        }
    }
    
    var placeholderImage: UIImage? {
        didSet {
            for (index, _) in pages.enumerated() {
                pages[index].placeholder = self.placeholderImage
            }
            collectionView.reloadData()
        }
    }
    
    var currentPage: Int {
        return Int(round(collectionView.contentOffset.x / collectionView.frame.width))
    }
    var pageInterval: Int = 4
    
    // private methods
    fileprivate func startCheckingPageAvailable () {
        //print("\n\nTimer2 will Start: \(DispatchTime.now())\n")
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
            //print("Timer2 is starting: \(DispatchTime.now())\n")
            self?.timer2?.invalidate()
            if let self = self{
                self.timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.checkNext), userInfo: nil, repeats: true)
            }
        }
    }
    
    @objc fileprivate func checkNext (){
        //print("Timer 2 is Fired: \(DispatchTime.now())\n")
        if pages.count>0 {
            let prevPage = (self.currentPage == 0) ? (self.pages.count-1):(self.currentPage-1)
            
            if let available = self.pages[prevPage].isAvailable {
                if available == false {
                    self.pages.remove(at: prevPage)
                    collectionView.reloadData()
                    //pageControl.numberOfPages = pages.count
                    if self.pages.count == 0 {
                        delegate?.pagerView(true)
                        self.stopPaging()
                        //timer2?.invalidate()
                    }
                } else if(available == true) {
                    if checked == pages.count {
                        pageControl.numberOfPages = pages.count
                        timer2?.invalidate()
                        print("\nTimer2 Stoped\n")
                    }
                    checked = checked + 1
                }
            }
        }
        else {
            timer2?.invalidate()
            print("\nTimer2 Stoped due Pages Count is Zero\n")
        }
    }
}


// MARK: - Utility Methods
extension PagerView {
    func set(images: [UIImage]) {
        pages = []
        pages = images.map({ PageModel(url: nil, image: $0, placeholder: nil) })
        collectionView.reloadData()
        pageControl.numberOfPages = pages.count
    }
    func set(urlStrings: [String]) {
        pages = []
        pages = urlStrings.map({ PageModel(url: URL(string: $0), image: nil, placeholder: self.placeholderImage) })
        collectionView.reloadData()
        pageControl.numberOfPages = pages.count
    }
    func set(url: [URL]) {
        pages = []
        pages = url.map({ PageModel(url: $0, image: nil, placeholder: self.placeholderImage) })
        collectionView.reloadData()
        pageControl.numberOfPages = pages.count
    }
    
    func add(urlString: String, placeholder: UIImage?) {
        pages.append(PageModel(url: URL(string: urlString), image: nil, placeholder: placeholder))
        collectionView.reloadData()
        pageControl.numberOfPages = pages.count
    }
    func add(url: URL, placeholder: UIImage?) {
        pages.append(PageModel(url: url, image: nil, placeholder: placeholder))
        collectionView.reloadData()
        pageControl.numberOfPages = pages.count
    }
    func add(image: UIImage) {
        pages.append(PageModel(url: nil, image: image, placeholder: nil))
        collectionView.reloadData()
        pageControl.numberOfPages = pages.count
    }
    
    func startPaging () {
        timer1?.invalidate()
        print("Paging Requestet!!!!")
        if (self.pages.count > 1) {
            timer1 = Timer.scheduledTimer(timeInterval: TimeInterval(self.pageInterval), target: self, selector: #selector(moveNext), userInfo: nil, repeats: true)
        }
    }
    @objc fileprivate func moveNext(){
        if (self.isDownloadingImage == false) {
            self.setPage(self.currentPage + 1)
        }
    }
    fileprivate func pageTrasitionTime() {
        let animation = CATransition.init()
        //animation.delegate = self
        animation.duration = 0.7
        animation.startProgress = 0
        animation.endProgress = 0.8
        
        animation.type = CATransitionType.reveal
        //   .init(rawValue: "scroll")
        animation.subtype = CATransitionSubtype.fromRight
        
        animation.fillMode = CAMediaTimingFillMode.backwards
        collectionView.layer.add(animation, forKey: "animation")
    }
    
    func stopPaging(){
        timer1?.invalidate()
    }
    
    func setPage(_ page: Int) {
        let pg = page % pages.count
        print("Page Number: \(pg)")
        pageTrasitionTime()
        collectionView.setContentOffset(CGPoint(x: CGFloat(pg) * collectionView.frame.width, y: 0), animated: false)
        /*if page >= pages.count {
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
         self?.collectionView.setContentOffset(CGPoint.zero, animated: false)
         }
         }*/
    }
}

// MARK: CollectionView DataSource and Delegate
extension PagerView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //if pages.count > 1 {
        //   return pages.count + 1
        //}
        return pages.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PageCell", for: indexPath) as! PageCell
        cell.delegate = self
        print("\ncellForItemAt: \(indexPath.row)\n")
        if indexPath.row < pages.count {
            cell.setData(pages[indexPath.row], kfOptions: self.kfOptions)
        } else if let d = pages.first {
            cell.setData(d, kfOptions: self.kfOptions)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            let current = Int(round(collectionView.contentOffset.x / collectionView.frame.width))
            if current == pages.count {
                pageControl.currentPage = current - 1
            } else {
                pageControl.currentPage = current
            }
        }
    }
}

extension PagerView:PageCellDelegate {
    func pageCell(error: NSError?, didFinishDownloading: Bool) {
        if let error = error?.userInfo["statusCode"] {
            if let code = error as? Int, code == 404
            {
                self.pages[self.currentPage].isAvailable = false
            }
            self.delegate?.pagerViewDidCompletedDownloading(false);
        } else {
            self.pages[self.currentPage].isAvailable = true
        }
        isDownloadingImage = false
        self.delegate?.pagerViewDidCompletedDownloading(true);
        print("\ndidFinishDownloading: \(didFinishDownloading)\n")
    }
    
    func pageCell(didStartedDownoladingImage: Bool) {
        self.delegate?.pagerViewDidStartedDownloading(true);
        isDownloadingImage = true
        print("didStartedDownoladingImage: \(didStartedDownoladingImage)")
    }
}
