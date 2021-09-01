//
//  LYWHomeViewController.swift
//  SwiftWeiBo
//
//  Created by LYW on 2021/3/23.
//

import UIKit
import Kingfisher
import SDWebImage
import MJRefresh

private let cellID = "LYWHomeTableViewCell"

class LYWHomeViewController: LYWBaseViewController {

    private lazy var titleBtn : LYWTitleBtn = LYWTitleBtn()
    
    private lazy var statusViewModels : [LYWStatusViewModel] = [LYWStatusViewModel]()
    
    private lazy var tipLabel : UILabel = UILabel()
    
    private lazy var popoVerAnimator : LYWPopoverAnimator = LYWPopoverAnimator { [weak self] (presented) in
        self?.titleBtn.isSelected = presented
    }
    
    private lazy var photoBrowserAnimator : LYWPhotoBrowserAnimator = LYWPhotoBrowserAnimator()
    
    var isPresented : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        setupRefresh()
        
        setupTipLabel()
        
        setupNotification()
    }
}

extension LYWHomeViewController {
    private func setupUI() {
        
        guard let tableView = tableView else { return }
        
        tableView.separatorStyle = .none
        
        tableView.register(UINib.init(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        
        visiterView.addRotationAnimation()
        
        titleBtn.setTitle("凡尘一笑1", for: .normal)
        navigationItem.titleView = titleBtn
        titleBtn.addTarget(self, action: #selector(LYWHomeViewController.titleBtnClick), for: .touchUpInside)
    }
    
    private func setupRefresh() {
        let head = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction:#selector(LYWHomeViewController.loadNewStatuses))
        head.setTitle("下拉刷新", for: .idle)
        head.setTitle("松手刷新", for: .pulling)
        head.setTitle("小蓝正在为您刷新", for: .refreshing)
        
        guard let tableView = tableView else { return }
        
        tableView.mj_header = head
        tableView.mj_header?.beginRefreshing()
        
        let foot = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(LYWHomeViewController.loadMoreStatuses))
        tableView.mj_footer = foot
    }
    
    private func setupTipLabel() {
        navigationController?.navigationBar.insertSubview(tipLabel, at: 0)
        tipLabel.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.size.width, height: 32)
        tipLabel.backgroundColor = UIColor.orange
        tipLabel.textAlignment = .center
        tipLabel.textColor = UIColor.white
        tipLabel.isHidden = true
    }
    
    private func setupNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(LYWHomeViewController.showPhotoBrowser(note:)), name: NSNotification.Name(rawValue: ShowPhotoBrowserNotification), object: nil)
    }
}

extension LYWHomeViewController {
    @objc private func titleBtnClick(titleBtn:LYWTitleBtn) {
        
        titleBtn.isSelected = !titleBtn.isSelected
        
        let popVC = LYWPopViewController()
        
        popVC.transitioningDelegate = popoVerAnimator
        
        popoVerAnimator.presentedViewFrame = CGRect(x: 100, y: 85, width: 180, height: 250)
        
        popVC.modalPresentationStyle = .custom
        
        present(popVC, animated: true, completion: nil)
    }
    
    @objc private func showPhotoBrowser(note:NSNotification){
        
        let indexPath = note.userInfo![ShowPhotoBrowserIndexPathKey] as! NSIndexPath
        
        let picUrls = note.userInfo![ShowPhotoBrowserUrlsKey] as! [URL]
        
        let object = note.object
        
        let photoBrowser =
            LYWShowPhotoBrowserVC(indexPath: indexPath, urls: picUrls)
        
        photoBrowser.modalPresentationStyle = .custom
        
        photoBrowser.transitioningDelegate = photoBrowserAnimator
        
        photoBrowserAnimator.indexPath = indexPath
        photoBrowserAnimator.presentedDelegate = (object as! LYWPhotoBrowserAnimatorPresentedDelegate)
        photoBrowserAnimator.dissmissDelegate = photoBrowser
            
        present(photoBrowser, animated: true, completion: nil)
        
    }
}

extension LYWHomeViewController {
    
    @objc private func loadNewStatuses(){
        setupNetwork(isNewData: true)
    }
    
    @objc private func loadMoreStatuses(){
        setupNetwork(isNewData: false)
    }
    
    
    private func setupNetwork(isNewData:Bool) {
        var since_id = 0
        var max_id = 0
        
        if isNewData {
            since_id = statusViewModels.first?.status?.mid ?? 0
        }else{
            max_id = statusViewModels.last?.status?.mid ?? 0
            max_id = max_id == 0 ? 0 : (max_id - 1) //如果不等于0 则会存在重复的一条微博所以要减1
        }
        
        
        LYWNetworkingManager.shareInstance.requestList(since_id: since_id,max_id: max_id) { [self] (result:[[String : AnyObject]]?, error:Error?) in
            if error != nil {
                print(error as Any)
                return
            }
            
            guard let statusArray = result else { return }
            
            var tempStatus = [LYWStatusViewModel]()
            
            for statusDict in statusArray {
                let status = LYWStatus(dict: statusDict)
                let statusViewModel = LYWStatusViewModel(status: status)
                tempStatus.append(statusViewModel)
            }
            
            if isNewData{
                self.statusViewModels = tempStatus + self.statusViewModels
            }else{
                self.statusViewModels += tempStatus
            }
            
            
            //缓存图片  为了计算单张图片时候 图片宽高
            cacheImages(statusViewModels: tempStatus)
        }
    }
    
    private func cacheImages(statusViewModels:[LYWStatusViewModel]) {
        
        let group = DispatchGroup()
        
        for viemModel in statusViewModels {
            
            for pictUrl in viemModel.picUrls {
                
                group.enter()
            
                SDWebImageManager.shared.loadImage(with: pictUrl, options: [], progress: nil) { (_, _, _, _, _, _) in
                    group.leave()
                }                
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.tableView.reloadData()
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.endRefreshing()
            self.showTipLabCount(count: statusViewModels.count)
        }
    }
    
    private func showTipLabCount(count:Int) {
        tipLabel.isHidden = false
        tipLabel.text = count == 0 ? "没有最新微博":"\(count)条微博"
        UIView.animate(withDuration: 1.0) {
            self.tipLabel.frame.origin.y = 44
            UIView.animate(withDuration: 1.0, delay: 1.5, options: []) {
                self.tipLabel.frame.origin.y = 10
            } completion: { (_) in
                self.tipLabel.isHidden = true
            }
        }
    }
}

extension LYWHomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! LYWHomeTableViewCell
        cell.statusViewModel = statusViewModels[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return statusViewModels[indexPath.row].cellHeight
    }
}
