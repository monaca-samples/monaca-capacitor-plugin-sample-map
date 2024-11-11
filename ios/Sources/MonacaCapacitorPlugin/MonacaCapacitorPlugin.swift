// 必要なフレームワークをインポート
import Foundation  // 基本的なiOSの機能を提供
import Capacitor   // Capacitorプラグインのフレームワーク
import MapKit      // Apple Maps関連の機能を提供

// MonacaCapacitorPluginクラスの定義
// @objcアノテーションはこのクラスをObjective-Cから利用可能にする
@objc(MonacaCapacitorPlugin)
public class MonacaCapacitorPlugin: CAPPlugin, CAPBridgedPlugin{    
    public let identifier = "MonacaCapacitorPlugin"
    public let jsName = "MonacaCapacitor"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "openMap", returnType: CAPPluginReturnPromise)
    ]
    /**
     * 指定された緯度経度で地図を開くメソッド
     * 優先順位：
     * 1. Apple Maps
     * 2. フォールバックとしてブラウザでGoogle Maps
     */
    @objc func openMap(_ call: CAPPluginCall) {
        // 必須パラメータ（緯度・経度）の存在確認
        guard let latitude = call.getDouble("latitude"),
              let longitude = call.getDouble("longitude") else {
            call.reject("Must provide latitude and longitude")
            return
        }
        
        // CLLocationCoordinate2Dオブジェクトを作成
        // これはApple Mapsで使用される座標オブジェクト
        let coordinate = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
        
        // 指定された座標にPlacemarkを作成
        // PlacemarkはMapsでの位置表示に使用される
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        
        // Maps表示のオプションを設定
        // - 経路案内モード：車での移動
        // - 交通情報：表示する
        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
            MKLaunchOptionsShowsTrafficKey: true
        ] as [String : Any]
        
        // Apple Mapsアプリで地図を開く
        if mapItem.openInMaps(launchOptions: launchOptions) {
            // 成功した場合、Apple Mapsで開いたことを通知
            call.resolve([
                "opened": true,
                "using": "apple-maps"
            ])
        } else {
            // Apple Mapsでの表示が失敗した場合のフォールバック処理
            // Google MapsのWeb版URLを作成
            let googleMapsURL = URL(string: "https://www.google.com/maps?q=\(latitude),\(longitude)")
            
            // URLが有効で、かつ開くことが可能か確認
            if let url = googleMapsURL, UIApplication.shared.canOpenURL(url) {
                // ブラウザでGoogle Mapsを開く
                UIApplication.shared.open(url, options: [:]) { success in
                    if success {
                        // ブラウザでの表示が成功した場合
                        call.resolve([
                            "opened": true,
                            "using": "browser"
                        ])
                    } else {
                        // ブラウザでの表示が失敗した場合
                        call.reject("Failed to open map in browser")
                    }
                }
            } else {
                // どの方法でも地図を開くことができなかった場合
                call.reject("Failed to open map with any available method")
            }
        }
    }
}