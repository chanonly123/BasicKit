//
//  PagedCollectionView.swift
//
//  Created by chandan on 27/03/24.
//

import UIKit
import SwiftUI

fileprivate struct PagedCollectionViewPreview: View {
    struct Item: Identifiable {
        var id: String { title }
        let title: String
    }
    
    @State var items: [Item] = (0...19).map { Item(title: "\($0)") }
    @State var val: Item? = Item(title: "5")
    @State var axis = Axis.Set.vertical
    
    var body: some View {
        VStack(spacing: 12) {
            PagedCollectionView(items: items, selected: $val, { val in
                Text("\(val.title)")
                    .font(.system(size: 30))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .border(.blue)
            })
            .itemSize(width: 200, height: 200)
            .insets(50)
            .scroll(axis)
            .frame(width: 300, height: 300)
            .border(.red)
            
            Text("\(val?.title ?? "nil")")
                .font(.system(size: 30))
            
            Button("Random page") {
                val = Item(title: "\((0...19).randomElement()!)")
            }
            
            Button("\(axis == .vertical ? "Vertical" : "Horizontal")") {
                axis = axis == .vertical ? .horizontal : .vertical
            }
        }
    }
}

public struct PagedCollectionView<Content: View, Item: Identifiable>: UIViewRepresentable {
    
    fileprivate let items: [Item]
    fileprivate let selected: Binding<Item?>
    fileprivate let content: (Item)->Content
    
    fileprivate var itemSize = CGSize.zero
    fileprivate var insets = CGFloat.zero
    fileprivate var axis: Axis.Set = .vertical
    
    public init(items: [Item], selected: Binding<Item?>, _ content: @escaping (Item)->Content) {
        self.items = items
        self.selected = selected
        self.content = content
    }
    
    public func makeUIView(context: Context) -> UIView {
        return HCollectionInner(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    public func updateUIView(_ uiView: UIView, context: Context) {
        let uiView = uiView as! HCollectionInner
        let coordinator = context.coordinator as! PagedCollectionViewCoordinator<Content, Item>
        coordinator.view = self
        uiView.delegate = coordinator
        uiView.dataSource = coordinator
        uiView.axis = axis
        uiView.reloadData()
    }
    
    public func makeCoordinator() -> NSObject {
        return PagedCollectionViewCoordinator(self)
    }
    
    public func itemSize(width: CGFloat, height: CGFloat) -> PagedCollectionView {
        var view = self
        view.itemSize = CGSize(width: width, height: height)
        return view
    }
    
    public func insets(_ val: CGFloat) -> PagedCollectionView {
        var view = self
        view.insets = val
        return view
    }
    
    public func scroll(_ axis: Axis.Set) -> PagedCollectionView {
        var view = self
        view.axis = axis
        return view
    }
}

fileprivate class PagedCollectionViewCoordinator<Content: View, Item: Identifiable>: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var view: PagedCollectionView<Content, Item>
    var currentPage: Int = -1
    
    lazy var firstScroll: ((UICollectionView, Int) -> Void)? = { [unowned self] collView, item in
        if currentPage != item {
            currentPage = item
            
            if view.axis == .horizontal {
                collView.contentOffset.x = CGFloat(item) * view.itemSize.width
            } else {
                collView.contentOffset.y = CGFloat(item) * view.itemSize.height
            }
        }
    }
    
    init(_ view: PagedCollectionView<Content, Item>) {
        self.view = view
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return view.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HCollectionInnerCell", for: indexPath) as! HCollectionInnerCell
        let child = UIHostingController(rootView: view.content(view.items[indexPath.item]))
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.contentView.addSubview(child.view)
        cell.view = child.view
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return view.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if view.axis == .horizontal {
            return UIEdgeInsets(top: 0, left: view.insets, bottom: 0, right: view.insets)
        } else {
            return UIEdgeInsets(top: view.insets, left: 0, bottom: view.insets, right: 0)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        var page: Int
        
        if view.axis == .horizontal {
            page = Int(round(targetContentOffset.pointee.x / view.itemSize.width))
            targetContentOffset.pointee.x = (CGFloat(page) * view.itemSize.width)
        } else {
            page = Int(round(targetContentOffset.pointee.y / view.itemSize.height))
            targetContentOffset.pointee.y = (CGFloat(page) * view.itemSize.height)
        }
        currentPage = page
        view.selected.wrappedValue = page > -1 && page < view.items.count ? view.items[page] : nil
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let id = view.selected.wrappedValue?.id, let index = view.items.firstIndex(where: { $0.id == id }) {
            firstScroll?(collectionView, index)
        }
    }
}

fileprivate class HCollectionInner: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        register(HCollectionInnerCell.self, forCellWithReuseIdentifier: "HCollectionInnerCell")
        self.decelerationRate = .fast
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var axis: Axis.Set {
        set {
            (collectionViewLayout as! UICollectionViewFlowLayout).scrollDirection = newValue == .horizontal ? .horizontal : .vertical
        } get {
            return (collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection == .horizontal ? .horizontal : .vertical
        }
    }
}

fileprivate class HCollectionInnerCell: UICollectionViewCell {
    var view: UIView?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        view?.frame = bounds
    }
}

#Preview {
    PagedCollectionViewPreview()
}
