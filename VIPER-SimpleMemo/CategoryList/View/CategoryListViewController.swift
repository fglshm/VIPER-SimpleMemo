//
//  CategoryListViewController.swift
//  VIPER-SimpleMemo
//
//  Created by Shohei Maeno on 2019/03/20.
//  Copyright © 2019 Shohei Maeno. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryListViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, CategoryListView {
    
    private lazy var presenter: CategoryListPresentation = CategoryListPresenter(view: self, router: CategoryListRouter(viewController: self))
    
    private var categories = [Category]()
    
    private let realm: Realm? = nil
    
    private let cellId = "cellId"
    
    private lazy var blurView: UIVisualEffectView = {
        let bv = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        bv.frame = self.view.frame
        return bv
    }()
    
    private let titleInputTextField: UITextField = {
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
    
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.width - 32, height: 70)
        layout.minimumLineSpacing = 20
        return layout
    }()
    
    private lazy var categoryCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: self.view.frame, collectionViewLayout: collectionViewLayout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.alwaysBounceVertical = true
        cv.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 100, right: 0)
        cv.register(CategoryListCell.self, forCellWithReuseIdentifier: cellId)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "カテゴリー"
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.isHidden = false
       
        view.addSubview(categoryCollectionView)
        view.addSubview(addButton)
        
        categoryCollectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        addButton.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 32), size: .init(width: 56, height: 56))
        
        presenter.fetchCategory()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategoryListCell
        cell.titleLabel.text = categories[indexPath.item].title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presenter.didItemSelected(of: self.categories[indexPath.item])
    }
    
    @objc func handleAddButtonTap() {
        view.addSubview(blurView)
        view.addSubview(titleInputTextField)
        view.addSubview(closeButton)
        view.addSubview(checkButton)
        titleInputTextField.alpha = 0
        titleInputTextField.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 150, left: 32, bottom: 0, right: 32), size: .init(width: 0, height: 56))
        blurView.alpha = 0
        closeButton.anchor(top: titleInputTextField.bottomAnchor, leading: titleInputTextField.leadingAnchor, bottom: nil, trailing: titleInputTextField.centerXAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 8), size: .init(width: 0, height: 56))
        checkButton.anchor(top: titleInputTextField.bottomAnchor, leading: titleInputTextField.centerXAnchor, bottom: nil, trailing: titleInputTextField.trailingAnchor, padding: .init(top: 16, left: 8, bottom: 0, right: 0), size: .init(width: 0, height: 56))
        
        UIView.animateKeyframes(withDuration: 0.7, delay: 0, options: .calculationModeCubic, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3/0.7, animations: {
                self.blurView.alpha = 1
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.3/0.7, relativeDuration: 0.3/0.7) {
                self.titleInputTextField.alpha = 1
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
        titleInputTextField.endEditing(true)
        UIView.animateKeyframes(withDuration: 0.7, delay: 0, options: .calculationModeCubic, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3/0.7, animations: {
                self.closeButton.alpha = 0
                self.checkButton.alpha = 0
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.1/0.7, relativeDuration: 0.3/0.7, animations: {
                self.titleInputTextField.alpha = 0
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.4/0.7, relativeDuration: 0.3/0.7, animations: {
                self.blurView.alpha = 0
            })
            
        }) { _ in
            self.titleInputTextField.removeFromSuperview()
            self.titleInputTextField.text = nil
            self.blurView.removeFromSuperview()
            self.closeButton.removeFromSuperview()
            self.checkButton.removeFromSuperview()
        }
    }
    
    @objc func handleCheckButtonTap() {
        titleInputTextField.endEditing(true)
        presenter.didCheckButtonTapped(titleWith: titleInputTextField.text)
    }
    
    func shakeTextField() {
        titleInputTextField.shake()
    }
    
    func closeBlurViewAndButtons() {
        self.closeShownUpViews()
    }
    
    func add(category: Category) {
        DispatchQueue.main.async {
            self.categories.insert(category, at: 0)
            self.categoryCollectionView.reloadData()
        }
    }
}
