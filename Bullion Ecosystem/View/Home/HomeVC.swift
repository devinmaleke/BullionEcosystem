//
//  HomeVC.swift
//  Bullion Ecosystem
//
//  Created by Cyberindo Sinergi Sistem on 21/06/24.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var botView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var addUserButton: UIButton!
    
    private lazy var viewModel = HomeVM()
    private lazy var userList = [UserModel]()
    var imageBannerData = ["BannerHome","BannerHome","BannerHome"]
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setCollectionView()
        setTableView()
        getUserList()
    }
    
    
    @IBAction func didTapButton(_ sender: UIButton) {
        if sender == logoutButton{
            logout()
        }else if sender == addUserButton{
            let vc = RegistrationVC()
            vc.completion = { [weak self] in
                self?.getUserList()
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        botView.roundCorners(corners: [.topLeft, .topRight], radius: 24)
    }
    
    private func setupUI(){
        topView.setGradientBackground(colorOne: UIColor.init(hex: "F05A2A"), colorTwo: UIColor.init(hex: "F89576"))
        
        addUserButton.layer.cornerRadius = 20
        addUserButton.layer.masksToBounds = true
        
    }
    
    private func setCollectionView(){
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let nibCell = UINib(nibName: "CarouselCVC", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: "CarouselCVC")
    }
    
    private func setTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.addSubview(refreshControl)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        
        tableView.register(UINib(nibName: "UserTVC", bundle: nil), forCellReuseIdentifier: "UserTVC")
    }
    
    private func getUserList(){
        showLoading(true)
        viewModel.resetData()
        viewModel.getUserListPaging()
        { [weak self] message, success, data in
            guard let self = self else {return}
            showLoading(false)
            refreshControl.endRefreshing()
            if success {
                userList = data ?? []
                tableView.reloadData()
            }else{
                showToast(message: message ?? "unkown error")
            }
           
        }
    }
    
    private func getMoreList(){
        showLoading(true)
        viewModel.getUserListPaging()
        { [weak self] message, success, data in
            guard let self = self else {return}
            showLoading(false)
            refreshControl.endRefreshing()
            if success {
                userList = data ?? []
                tableView.reloadData()
            }else{
                showToast(message: message ?? "unkown error")
            }
           
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        getUserList()
    }
    
    private func logout(){
        UserDefaultService.shared.deleteToken()
        navigationController?.popToRootViewController(animated: true)
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageBannerData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCVC", for: indexPath) as! CarouselCVC
        cell.setup(data: imageBannerData[indexPath.row])
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = collectionView.indexPathForItem(at: visiblePoint) {
            pageControl.currentPage = visibleIndexPath.row
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let width = screenWidth - 50
        return CGSize(width: width, height: 160)
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTVC") as! UserTVC
        cell.selectionStyle = .none
        cell.setup(data: userList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UserDetailVC(userID: userList[indexPath.row]._id)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.completion = { [weak self] in
            self?.getUserList()
        }
        present(vc, animated: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView.contentOffset.y >= 0 else { return }
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maximumOffset - currentOffset < 125{
            getMoreList()
        }
    }
}


