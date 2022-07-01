//
//  ResultViewController.swift
//  CollectionViewSample2022-06-23
//
//  Created by 村中令 on 2022/06/30.
//

import UIKit

class ResultViewController: UIViewController {
    private var totalCoin: Int
    private var oneGameGetCoin: Int
    private var gameFinishType: GameFinishType

    override func viewDidLoad() {
        super.viewDidLoad()
        print(totalCoin)
        print(oneGameGetCoin)
        print(gameFinishType)

    }
    required init?(coder: NSCoder,gameFinishType: GameFinishType,oneGameGetCoin: Int) {
        self.totalCoin = CoinRepository.load() ?? 0
        self.oneGameGetCoin = oneGameGetCoin
        self.gameFinishType = gameFinishType
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
