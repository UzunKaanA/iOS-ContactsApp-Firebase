//
//  KisilerRepository.swift
//  KisilerUygulamasi
//
//  Created by Kasım on 14.05.2024.
//

import Foundation
import RxSwift
import FirebaseFirestore

class KisilerRepository {
    var kisilerListesi = BehaviorSubject<[Kisiler]>(value: [Kisiler]())
    var collectionKisiler = Firestore.firestore().collection("Kisiler")
    
    func kaydet(kisi_ad:String,kisi_tel:String){
        let yeniKisi:[String:Any] = ["kisi_id":"","kisi_ad":kisi_ad,"kisi_tel":kisi_tel]
        collectionKisiler.document().setData(yeniKisi)
    }
    
    func guncelle(kisi_id:String,kisi_ad:String,kisi_tel:String){
        let guncellenenKisi:[String:Any] = ["kisi_ad":kisi_ad,"kisi_tel":kisi_tel]
        collectionKisiler.document(kisi_id).updateData(guncellenenKisi)
    }
    
    func ara(aramaKelimesi:String){
        collectionKisiler.addSnapshotListener { snapshot , error in
            
            var liste = [Kisiler]()
            
            if let documents = snapshot?.documents {
                for document in documents {
                    let data = document.data()
                    let kisi_id = document.documentID
                    let kisi_ad = data["kisi_ad"] as? String ?? "isim bulunamadi"
                    let kisi_tel = data["kisi_tel"] as? String ?? "tel bulunamadi"
                    
                    if kisi_ad.lowercased().contains(aramaKelimesi.lowercased()){
                        let kisi = Kisiler(kisi_id: kisi_id, kisi_ad: kisi_ad, kisi_tel: kisi_tel)
                        liste.append(kisi)
                    }
                }
            }
            
            self.kisilerListesi.onNext(liste)//Tetikleme
        }
    }
    
    func sil(kisi_id:String){
        collectionKisiler.document(kisi_id).delete()
    }
    
    func kisileriYukle(){
        collectionKisiler.addSnapshotListener { snapshot , error in
            
            var liste = [Kisiler]()
            
            if let documents = snapshot?.documents {
                for document in documents {
                    let data = document.data()
                    let kisi_id = document.documentID
                    let kisi_ad = data["kisi_ad"] as? String ?? "isim bulunamadi"
                    let kisi_tel = data["kisi_tel"] as? String ?? "tel bulunamadi"
                    
                    let kisi = Kisiler(kisi_id: kisi_id, kisi_ad: kisi_ad, kisi_tel: kisi_tel)
                    liste.append(kisi)
                }
            }
            
            self.kisilerListesi.onNext(liste)//Tetikleme
        }
    }
}
