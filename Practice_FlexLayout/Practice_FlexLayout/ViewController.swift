//
//  ViewController.swift
//  Practice_FlexLayout
//
//  Created by Jinwoo Kim on 3/6/22.
//

import UIKit
import Combine
import FlexLayout

class ViewController: UIViewController {
    private var primaryTitleLabel: UILabel!
    private var secondaryTitleLabel: UILabel!
    private var creditCardItemViews: [CreditCardItemView.CreditType: CreditCardItemView] = [:]
    private var highlightedCreditCardItemViews: [CreditCardItemView] = []
    
    private var cancellableBag: Set<AnyCancellable> = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        setAttributes()
        configurePrimaryTitleLabel()
        configureSecondaryTitleLabel()
        configureCreditCardItemViews()
        configureLayoutContainer()
        bind()
    }
    
    private func setAttributes() {
        view.backgroundColor = .white
    }
    
    private func configurePrimaryTitleLabel() {
        let primaryTitleLabel: UILabel = .init()
        primaryTitleLabel.backgroundColor = .clear
        primaryTitleLabel.textColor = .black
        primaryTitleLabel.text = "카드사 선택하기"
        view.addSubview(primaryTitleLabel)
        self.primaryTitleLabel = primaryTitleLabel
    }
    
    private func configureSecondaryTitleLabel() {
        let secondaryTitleLabel: UILabel = .init()
        secondaryTitleLabel.backgroundColor = .clear
        secondaryTitleLabel.textColor = .gray
        secondaryTitleLabel.text = "추가 환급액 확인을 위해 연동할 카드사를 선택해 주세요."
        view.addSubview(secondaryTitleLabel)
        self.secondaryTitleLabel = secondaryTitleLabel
    }
    
    private func configureCreditCardItemViews() {
        CreditCardItemView.CreditType.allCases.forEach { creditType in
            let item: CreditCardItemView = .init(with: creditType, delegate: self)
            item.layer.shadowColor = UIColor.black.cgColor
            item.layer.cornerRadius = 10.0
            item.layer.shadowOpacity = 0.2
            self.view.addSubview(item)
            self.creditCardItemViews[creditType] = item
        }
    }
    
    private func bind() {
        view.publisher(for: \.frame, options: [.initial, .new])
            .removeDuplicates()
            .receive(on: OperationQueue.main)
            .sink { [weak self] _ in
                self?.relayout()
            }
            .store(in: &cancellableBag)
    }
    
    private func configureLayoutContainer() {
        view.flex.direction(.column).alignItems(.start).define { flex in
            flex.addItem(self.primaryTitleLabel)
            flex.addItem(self.secondaryTitleLabel)
            
            let count: Int = CreditCardItemView.CreditType.allCases.count
            
            let rows: Int = {
                if count % 3 == 0 {
                    return count / 3
                } else {
                    return (count / 3) + 1
                }
            }()
            
            for a in 0..<rows {
                let last: Int = {
                    if a == rows - 1 {
                        let tmp: Int = count % (a + 1)
                        if tmp == 0 { return 3 }
                        return tmp
                    } else {
                        return 3
                    }
                }()
                
                flex.addItem().direction(.row).width(100%).define { flex in
                    for b in 0..<last {
                        let item: CreditCardItemView = self.creditCardItemViews[.init(rawValue: a * 3 + b)!]!
                        flex.addItem(item)
                    }
                }
            }
        }
    }
    
    private func relayout() {
        view.flex.padding(view.safeAreaInsets).layout(mode: .fitContainer)
        highlightedCreditCardItemViews = []
    }
    
    private func toggleHighlightingtemView(_ itemView: CreditCardItemView) {
        let isHighlighted: Bool = highlightedCreditCardItemViews.contains(itemView)
        
        if isHighlighted {
            // TODO : 선택된 아이템만 업데이트하도록
            relayout()
        } else {
            UIView.animate(withDuration: 0.3) {
//                itemView.pin.center()
            }
            highlightedCreditCardItemViews.append(itemView)
        }
    }
}

extension ViewController: CreditCardItemViewDelegate {
    func creditCardItemView(_ view: CreditCardItemView, didTapWithTapGesture: UITapGestureRecognizer) {
        toggleHighlightingtemView(view)
    }
}
