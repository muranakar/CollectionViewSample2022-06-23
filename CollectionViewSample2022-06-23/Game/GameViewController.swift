//
//  ViewController.swift
//  CollectionViewSample2022-06-23
//
//  Created by 村中令 on 2022/06/23.
//
// 参考URL: https://qiita.com/sgr-ksmt/items/56b11a61a545147c3aa3

import UIKit

class GameViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var correctValueLabel: UILabel!

    private var columnsNum = 3
    private var randomValues: [String] = []
    private var correctRandomValue: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        configureRandomValueAndCorrectRandomValueAndCollectionViewReload()
    }
//        マイナス　　1×1　2×2 3×3 ....
//        columnsNum -= 1
//        configureRandomValueAndCorrectRandomValueAndCollectionViewReload()
//        プラス　　1×1　2×2 3×3 ....
//        columnsNum += 1
//        configureRandomValueAndCorrectRandomValueAndCollectionViewReload()

    private func configureRandomValueAndCorrectRandomValueAndCollectionViewReload() {
        let columnsNumPow = Int(pow(Double(columnsNum), 2))
        randomValues = Array(CsvConversion.convertFacilityInformationFromCsv(characterType: .kanzi).shuffled()[0...columnsNumPow - 1])
        correctRandomValue = randomValues.randomElement()!
        correctValueLabel.text = correctRandomValue
        collectionView.reloadData()
    }
}
extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        randomValues.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =
        collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                           for: indexPath) as! CollectionViewCell
        cell.configure(text: randomValues[indexPath.row])
        cell.layer.backgroundColor = UIColor.white.cgColor
        return cell
    }

}


extension GameViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let isCorrectValue = randomValues[indexPath.row] == correctRandomValue
        print(isCorrectValue)
        if isCorrectValue {
            configureRandomValueAndCorrectRandomValueAndCollectionViewReload()
        }
    }

}

extension GameViewController: UICollectionViewDelegateFlowLayout {
    // UICollectionViewの外周余白
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    // Cellのサイズ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize : CGFloat = self.collectionView.bounds.width / CGFloat(columnsNum) - 2
        return CGSize(width: cellSize, height: cellSize)
    }
    // 行の最小余白
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    // 列の最小余白
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}