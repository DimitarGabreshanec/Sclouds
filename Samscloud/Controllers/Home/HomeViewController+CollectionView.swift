//
//  HomeViewController+CollectionView.swift
//  Samscloud
//
//  Created by Irshad Ahmed on 05/09/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import UIKit
import CoreLocation


extension HomeViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    // MARK: - COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == responderStreamCollection {
            return conferrenceRoomData.count
        }
        return  responders?.emergency_contacts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == responderStreamCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResponderStreamCell", for: indexPath) as! ResponderStreamCell
            cell.stream = conferrenceRoomData[indexPath.item]
            let id = conferrenceRoomData[indexPath.item].stream_id ?? ""
            let name = conferrenceRoomData[indexPath.item].responder_name ?? ""
            cell.perform(#selector(cell.loadStream(id:)), with: id, afterDelay: 1.0)
            cell.nameLabel.text = name
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResponderCollectionViewCell.identifier, for: indexPath) as! ResponderCollectionViewCell
        
        if indexPath.item == selectedPinIndex {
            cell.responderImageView.layer.borderWidth = 3.0
        }else{
            cell.responderImageView.layer.borderWidth = 0
        }
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let object = responders?.emergency_contacts?[indexPath.item] else {return}
        if let lat = object.latitude, let long = object.longitude {
            let location = CLLocationCoordinate2D.init(latitude: lat, longitude: long)
            //marker.position = location
            polyline?.map = nil
            
            print(selectedPinIndex)
            
            selectedPinIndex = indexPath.item
            collectionView.reloadData()
            
            responderPinViews.forEach({
                $0.detailsView?.isHidden = true
            })
            
            self.fetchRoute(from: appDelegate.currentLocation.coordinate, to: location)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == responderStreamCollection {
            return .init(width: 60, height: 98)
        }
        return .init(width: 37, height: 37)
    }
    
    
    func handleCellStop(cell:ResponderStreamCell) {
        guard let indexPath = responderStreamCollection.indexPath(for: cell) else {return}
        self.conferrenceRoomData.remove(at: indexPath.item)
        
        //self.responderStreamCollection.deleteItems(at: [indexPath])
        /*if cell.client != nil {
           cell.client.stop()
        }*/
        
        cell.removeFromSuperview()
        cell.isLoaded = false
        self.responderStreamCollection.reloadData()
    }

    
}
