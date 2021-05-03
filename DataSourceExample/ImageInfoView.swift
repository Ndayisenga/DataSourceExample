//
//  ImageInfoView.swift
//  DataSourceExample
//
//  Created by Ndayisenga Jean Claude on 03/05/2021.
//

import UIKit

protocol imageInfoViewDataSource: AnyObject {
    func imageInfoViewTitleForImage(_ infoView: ImageInfoView) -> String?
    func imageInfoViewURLForImage(_ infoView: ImageInfoView) -> URL?
}
class ImageInfoView: UIView {
    
    weak var datasource: imageInfoViewDataSource?

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .black
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "-"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(titleLabel)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configure() {
        guard let dataSource = datasource else {
            return
        }
        titleLabel.text = dataSource.imageInfoViewTitleForImage(self)
        guard let imageUrl = dataSource.imageInfoViewURLForImage(self) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: imageUrl) { [weak self] data, _, _ in
            guard let data = data else {
                return
            
            }
            DispatchQueue.main.async {
                self?.imageView.image = UIImage(data: data)
            }
            
        }
        task.resume()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(
            x: (frame.size.width-250)/2,
                                 y: 0,
                                 width: 250,
                                 height: 250
        )
        titleLabel.frame = CGRect(
        x: 0,
        y: 260,
        width: frame.size.width,
        height: 70
        )
        
    }
    
    public func reloadData() {
        configure()
        
    }
    
}
