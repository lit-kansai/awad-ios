//
//  StampListViewController.swift
//  awad
//
//  Created by tomoya tanaka on 2021/01/30.
//

import UIKit
import FirebaseFirestoreSwift
import FirebaseFirestore

class StampListViewController: UIViewController {
	
	struct Stamp: Codable {
		var name: String
		var description: String
		var image: String
	}
	
	let titleHeader: Header = Header(imageName: "stamp")
	let background: BackgroundUIImageView = BackgroundUIImageView(imageName: "stampBackground")
	let achievementRatioLabel: UILabel = UILabel()
	var stamp: UIImageView = UIImageView()
	let stampBackground: UIView = UIView()
	var stampTitleLabel: UILabel = UILabel()
	var stampDescriptionLabel: UILabel = UILabel()
	let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
	var stampCollectionView: UICollectionView!
	var stamps: [Stamp] = []
		
    override func viewDidLoad() {
        super.viewDidLoad()
		self.setupView()
		self.addConstraints()
		stampCollectionView.dataSource = self
		stampCollectionView.delegate = self
		stampCollectionView.register(CustomTableViewCell.self, forCellWithReuseIdentifier: "Cell")
		self.navigationController?.navigationBar.isHidden = false
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.removePreviousController()
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(false)
		titleHeader.animate()
		// アニメーション
		UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
			self.view.layoutIfNeeded()
		}, completion: nil)
		
		FirestoreManager.shared.team?.collection("stamps").getDocuments { (querySnapshot, err) in
			if let err: Error = err {
				print("Error getting documents: \(err)")
			} else {
				for document in querySnapshot!.documents {
					let stamp: Stamp? = try? Firestore.Decoder().decode(Stamp.self, from: document.data())
					self.stamps.append(stamp!)
				}
				self.stampCollectionView.reloadData()
				self.stampTitleLabel.text = self.stamps[0].name
				self.stampDescriptionLabel.text = self.stamps[0].description
				self.stamp.image = UIImage(named: self.stamps[0].image)
				self.stampCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
				let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "1/\(self.stamps.count)")
				attributedString.addAttribute(NSAttributedString.Key.kern, value: 3, range: NSRange(location: 0, length: attributedString.length))
				self.achievementRatioLabel.attributedText = attributedString
			}
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		titleHeader.resetForAnimation()
		stamps = []
		self.stampCollectionView.reloadData()
		self.navigationController?.navigationBar.isHidden = true
	}
}

extension StampListViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return stamps.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
		
		if !stamps.isEmpty {
			let imageView: UIImageView = UIImageView(image: UIImage(named: stamps[indexPath.row].image))
			cell.addSubview(imageView)
			cell.clipsToBounds = true
			imageView.contentMode = .scaleAspectFit
			imageView.translatesAutoresizingMaskIntoConstraints = false
			NSLayoutConstraint.activate([
				imageView.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
				imageView.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
				imageView.widthAnchor.constraint(equalTo: cell.widthAnchor, multiplier: 0.9),
				imageView.heightAnchor.constraint(equalTo: cell.heightAnchor, multiplier: 0.9)
			])
			cell.backgroundColor = .white
			cell.layer.cornerRadius = 9
		}

		let selectedBGView: UIView = UIView(frame: cell.frame)
		selectedBGView.layer.borderWidth = 3
		selectedBGView.layer.borderColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
		selectedBGView.backgroundColor = .white
		selectedBGView.layer.cornerRadius = 9
		cell.selectedBackgroundView = selectedBGView
		
		return cell
	}
	
}

extension StampListViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		stamp.image = UIImage(named: stamps[indexPath.row].image)
		stampTitleLabel.text = stamps[indexPath.row].name
		stampDescriptionLabel.text = stamps[indexPath.row].description
		let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "\(indexPath.row + 1)/\(self.stamps.count)")
		attributedString.addAttribute(NSAttributedString.Key.kern, value: 3, range: NSRange(location: 0, length: attributedString.length))
		self.achievementRatioLabel.attributedText = attributedString
	}
	
	func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
		return true  // 変更
	}

	func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
		return true  // 変更
	}
	
	func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
		return true
	}
}

extension StampListViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.frame.width * 0.2, height: collectionView.frame.width * 0.2)
		}
}

extension StampListViewController {
	func setupView() {
		stampCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
		stampCollectionView.allowsMultipleSelection = false
		background.activateConstraint(parent: view)
		titleHeader.activateConstraint(parent: view)
		
		stampBackground.addSubview(stamp)
		view.addSubview(achievementRatioLabel)
		view.addSubview(stampBackground)
		view.addSubview(stampTitleLabel)
		view.addSubview(stampDescriptionLabel)
		view.addSubview(stampCollectionView)
		
		flowLayout.minimumLineSpacing = 35
		stampBackground.backgroundColor = .white
		stampBackground.layer.cornerRadius = 18
		stamp.contentMode = .scaleAspectFit
		stampTitleLabel.font = UIFont(name: "Keifont", size: 20)
		stampDescriptionLabel.font = UIFont(name: "Keifont", size: 15)
		
		stampDescriptionLabel.textAlignment = .center
		stampDescriptionLabel.numberOfLines = 0
		
		achievementRatioLabel.textColor = #colorLiteral(red: 0.9503150582, green: 0.9693611264, blue: 0.9732105136, alpha: 1)
		stampCollectionView.backgroundColor = .clear
	}
	
	func addConstraints() {
		stampBackground.translatesAutoresizingMaskIntoConstraints = false
		stamp.translatesAutoresizingMaskIntoConstraints = false
		stampTitleLabel.translatesAutoresizingMaskIntoConstraints = false
		stampDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
		achievementRatioLabel.translatesAutoresizingMaskIntoConstraints = false
		stampCollectionView.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			stampBackground.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
			stampBackground.heightAnchor.constraint(equalTo: stampBackground.widthAnchor),
			stampBackground.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			stampBackground.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.18),
			
			stamp.centerXAnchor.constraint(equalTo: stampBackground.centerXAnchor),
			stamp.centerYAnchor.constraint(equalTo: stampBackground.centerYAnchor),
			stamp.widthAnchor.constraint(equalTo: stampBackground.widthAnchor, multiplier: 0.9),
			stamp.heightAnchor.constraint(equalTo: stampBackground.heightAnchor, multiplier: 0.9),
			
			stampTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			stampTitleLabel.topAnchor.constraint(equalTo: stampBackground.bottomAnchor, constant: 30),
			
			stampDescriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			stampDescriptionLabel.topAnchor.constraint(equalTo: stampTitleLabel.bottomAnchor, constant: 10),
			
			achievementRatioLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.6),
			achievementRatioLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
			
			stampCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
			stampCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
			stampCollectionView.topAnchor.constraint(equalTo: achievementRatioLabel.bottomAnchor, constant: 40),
			stampCollectionView.leadingAnchor.constraint(equalTo: achievementRatioLabel.leadingAnchor)
		])
	}
}

class CustomTableViewCell: UICollectionViewCell {

	override func prepareForReuse() {
		super.prepareForReuse()
		print("prepareForReuse")
		for subview in self.subviews {
			subview.removeFromSuperview()
		}
	}
}
