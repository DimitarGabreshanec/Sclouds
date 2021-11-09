//
//  DispatchHomeChirpViewController.swift
//  Samscloud
//
//  Created by An Phan on 2/20/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class DispatchHomeChirpViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var chirpSwitch: UISwitch!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var numberBigView: UIView!
    @IBOutlet weak var numberSmallView: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var leaveButton: UIButton!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var myGroupsButton: UIButton!
    @IBOutlet weak var chirpButton: UIButton!
    @IBOutlet weak var muteContainerView: UIView!
    @IBOutlet weak var avtContainerView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var containerViewCenterYConstraint: NSLayoutConstraint!
    
    // MARK: - Private var/let
    private let defaultCenterY: CGFloat = -76
    private var maxSecond = 5
    private var timer: Timer!
    
    // MARK: - Variables
    var myGroupsButtonAction: (() -> Void)?
    var addButtonAction: (() -> Void)?
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberLabel.text = "\(maxSecond)"
        containerViewCenterYConstraint.constant = -(view.frame.height / 2 + containerView.frame.height / 2)
        
        prepareUI()
        prepareCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        containerViewCenterYConstraint.constant = defaultCenterY
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
    // MARK: - Methods
    
    @objc func updateTime() {
        maxSecond -= 1
        
        if maxSecond == 0 {
            timer?.invalidate()
        }
        
        numberLabel.text = "\(maxSecond)"
    }
    
    // MARK: - Private methods
    
    private func runTime() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    private func prepareUI() {
        containerView.layer.cornerRadius = 10
        numberBigView.roundRadius()
        numberSmallView.roundRadius()
        leaveButton.roundRadius()
        avtContainerView.roundRadius()
        muteContainerView.roundRadius()
        userImageView.roundRadius()
    }
    
    private func prepareCollectionView() {
        let nib = UINib(nibName: OnlyImageCollectionViewCell.identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: OnlyImageCollectionViewCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
    }
    
    private func dismissPage(dismissCompletion: (() -> Void)?) {
        containerViewCenterYConstraint.constant = (view.frame.height / 2 + containerView.frame.height / 2 )
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }) { (finished) in
            self.dismiss(animated: false, completion: dismissCompletion)
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        dismissPage(dismissCompletion: nil)
    }
    
    @IBAction func leaveButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func muteButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func addButtonAction(_ sender: UIButton) {
        dismissPage(dismissCompletion: {
            self.addButtonAction?()
        })
    }
    
    @IBAction func chirpButtonAction(_ sender: UIButton) {
        runTime()
    }
    
    @IBAction func myGroupsButtonAction(_ sender: UIButton) {
        dismissPage(dismissCompletion: {
            self.myGroupsButtonAction?()
        })
    }
    
    @IBAction func userButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
    }
    
    @IBAction func mainViewTapped(_ sender: Any) {
        dismissPage(dismissCompletion: nil)
    }
}

// MARK: - UITableViewDataSource

extension DispatchHomeChirpViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnlyImageCollectionViewCell.identifier, for: indexPath) as! OnlyImageCollectionViewCell
        cell.onlyImageView.layer.cornerRadius = 20
        if indexPath.item < 3 {
        cell.onlyImageView.bordered(withColor: UIColor(hexString: "7ed321"), width: 2)
        }
        else {
            cell.onlyImageView.bordered(withColor: UIColor(hexString: "fce92c"), width: 2)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DispatchHomeChirpViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
}

// MARK: - UIGestureRecognizerDelegate

extension DispatchHomeChirpViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view, view.isDescendant(of: containerView) {
            return false
        }
        
        return true
    }
}
