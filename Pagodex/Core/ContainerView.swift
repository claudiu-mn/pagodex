//
//  ContainerView.swift
//  Pagodex
//
//  Created by Claudiu Miron on 25.10.2023.
//

import UIKit

// TODO: Think of a better name
class ContainerView<SuccessView: UIView>: UIView {
    
    enum State { case loading, success, failure (String, (() -> Void)?) }
    
    public var state: State = .loading {
        didSet {
            update(state: state)
        }
    }
    
    private weak var activityIndicator: UIActivityIndicatorView!
    private(set) weak var successView: SuccessView!
    private weak var retryButton: UIButton!
    
    @available(*, unavailable)
    init() {
        fatalError("init() is unavailable")
    }
    
    @available(*, unavailable)
    override init(frame: CGRect) {
        fatalError("init(frame:) is not supported")
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    init(successView: SuccessView) {
        super.init(frame: .zero)
        
        setUp(successView: successView)
    }
    
    private func setUp(successView: SuccessView) {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        activityIndicator.style = .large
        activityIndicator.color = Colors.button
        addSubview(activityIndicator)
        activityIndicator.center(in: self)
        self.activityIndicator = activityIndicator
        
        successView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(successView)
        successView.fill(self)
        self.successView = successView
        
        let retryButton = UIButton()
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(retryButton)
        retryButton.fill(self,
                         with: UIEdgeInsets(all: Dimensions.standardSpacing))
        retryButton.addTarget(self,
                              action: #selector(onButtonTapped),
                              for: .touchUpInside)
        retryButton.setTitleColor(Colors.button, for: .normal)
        retryButton.setTitleColor(Colors.button, for: .disabled)
        retryButton.titleLabel?.numberOfLines = 0
        retryButton.titleLabel?.textAlignment = .center
        self.retryButton = retryButton
        
        update(state: state)
    }
    
    private func update(state: State) {
        switch (state) {
        case .loading:
            retryButton.isHidden = true
            successView.isHidden = true
            activityIndicator.isHidden = false
            break
            
        case .success:
            retryButton.isHidden = true
            successView.isHidden = false
            activityIndicator.isHidden = true
            break
            
        case .failure(let message, let retryBlock):
            retryButton.isHidden = false
            successView.isHidden = true
            activityIndicator.isHidden = true
            
            retryButton.setTitle(message, for: .normal)
            retryButton.isEnabled = retryBlock != nil
            break
        }
    }
    
    @objc
    private func onButtonTapped() {
        switch (state) {
        case .failure(_, let retryBlock):
            retryBlock?()
            break
            
        default:
            debugPrint("Something went wrong")
            break
        }
    }
    
}
