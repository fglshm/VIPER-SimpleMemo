//
//  DetailListViewController.swift
//  VIPER-SimpleMemo
//
//  Created by Shohei Maeno on 2019/03/23.
//  Copyright © 2019 Shohei Maeno. All rights reserved.
//

import UIKit

class DetailListViewController: UIViewController, DetailListView, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
   
    private let cellId = "cellId"
    
    private var details = [Detail]()
    
    private lazy var presenter: DetailListPresentation? = DetailListPresenter(view: self, router: DetailListRouter(viewController: self))
    
    var category: Category? {
        didSet {
            self.navigationItem.title = category?.title
        }
    }
    
    private lazy var blurView: UIVisualEffectView = {
        let bv = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        bv.frame = self.view.frame
        return bv
    }()
    
    private let contentsInputTextField: UITextField = {
        let tf = CustomeTextField()
        tf.placeholder = "category title"
        return tf
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9821627736, green: 0.500117898, blue: 0.5001407266, alpha: 1)
        button.alpha = 0
        button.addTarget(self, action: #selector(handleCloseButtonTap), for: .touchUpInside)
        setShadow(to: button)
        return button
    }()
    
    private lazy var checkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create", for: .normal)
        button.layer.cornerRadius = 8
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.clipsToBounds = true
        button.backgroundColor = #colorLiteral(red: 0.4511811733, green: 0.8465113044, blue: 0.6483140588, alpha: 1)
        button.alpha = 0
        button.addTarget(self, action: #selector(handleCheckButtonTap), for: .touchUpInside)
        setShadow(to: button)
        return button
    }()
    
    private func setShadow(to button: UIButton) {
        button.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.5
        button.layer.masksToBounds = false
    }
    
    
    private lazy var detailCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.width - 32, height: 70)
        layout.minimumLineSpacing = 20
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(DetailListCell.self, forCellWithReuseIdentifier: cellId)
        cv.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 100, right: 0)
        cv.backgroundColor = .white
        cv.alwaysBounceVertical = true
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "add").withRenderingMode(.alwaysOriginal), for: .normal)
        button.layer.cornerRadius = 28
        button.clipsToBounds = true
        button.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.5
        button.layer.masksToBounds = false
        button.backgroundColor = #colorLiteral(red: 0.3303897381, green: 0.4975342155, blue: 0.9682772756, alpha: 1).withAlphaComponent(0.8)
        button.addTarget(self, action: #selector(handleAddButtonTap), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavigationBar()
        view.addSubview(detailCollectionView)
        view.addSubview(addButton)
        detailCollectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        addButton.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 32, right: 32), size: .init(width: 56, height: 56))
        if let categoryId = category?.categoryId {
            presenter?.viewDidLoad(categoryOf: categoryId)
        }
    }
    
    func setNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return details.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DetailListCell
        cell.detail = details[indexPath.item]
        return cell
    }
    
    @objc func handleAddButtonTap() {
        view.addSubview(blurView)
        view.addSubview(contentsInputTextField)
        view.addSubview(closeButton)
        view.addSubview(checkButton)
        contentsInputTextField.alpha = 0
        contentsInputTextField.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 150, left: 32, bottom: 0, right: 32), size: .init(width: 0, height: 56))
        blurView.alpha = 0
        closeButton.anchor(top: contentsInputTextField.bottomAnchor, leading: contentsInputTextField.leadingAnchor, bottom: nil, trailing: contentsInputTextField.centerXAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 8), size: .init(width: 0, height: 56))
        checkButton.anchor(top: contentsInputTextField.bottomAnchor, leading: contentsInputTextField.centerXAnchor, bottom: nil, trailing: contentsInputTextField.trailingAnchor, padding: .init(top: 16, left: 8, bottom: 0, right: 0), size: .init(width: 0, height: 56))
        
        UIView.animateKeyframes(withDuration: 0.7, delay: 0, options: .calculationModeCubic, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3/0.7, animations: {
                self.blurView.alpha = 1
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.3/0.7, relativeDuration: 0.3/0.7) {
                self.contentsInputTextField.alpha = 1
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.4/0.7, relativeDuration: 0.3/0.7) {
                self.closeButton.alpha = 1
                self.checkButton.alpha = 1
            }
        })
    }
    
    @objc func handleCloseButtonTap() {
        closeShownUpViews()
    }
    
    func closeShownUpViews() {
        contentsInputTextField.endEditing(true)
        UIView.animateKeyframes(withDuration: 0.7, delay: 0, options: .calculationModeCubic, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3/0.7, animations: {
                self.closeButton.alpha = 0
                self.checkButton.alpha = 0
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.1/0.7, relativeDuration: 0.3/0.7, animations: {
                self.contentsInputTextField.alpha = 0
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.4/0.7, relativeDuration: 0.3/0.7, animations: {
                self.blurView.alpha = 0
            })
            
        }) { _ in
            self.contentsInputTextField.removeFromSuperview()
            self.contentsInputTextField.text = nil
            self.blurView.removeFromSuperview()
            self.closeButton.removeFromSuperview()
            self.checkButton.removeFromSuperview()
        }
    }
    
    @objc func handleCheckButtonTap() {
        contentsInputTextField.endEditing(true)
        if let contents = contentsInputTextField.text {
            if let currentCategory = category {
                presenter?.didAddButtonClicked(contents: contents, category: currentCategory)
            }
        }
        
    }
    
    func shakeTextField() {
        contentsInputTextField.shake()
    }
    
    func closeBlurViewAndButtons() {
        self.closeShownUpViews()
    }
    
    func add(item: Detail) {
        DispatchQueue.main.async {
            self.details.insert(item, at: 0)
            self.detailCollectionView.reloadData()
        }
    }
    
    
}

