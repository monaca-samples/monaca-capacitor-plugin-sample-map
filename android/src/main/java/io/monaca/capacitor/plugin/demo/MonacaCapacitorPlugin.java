package io.monaca.capacitor.plugin.demo;

// 必要なCapacitorの依存関係をインポート
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

// Androidの標準ライブラリをインポート
import android.content.Intent;
import android.net.Uri;
import android.content.ActivityNotFoundException;
import android.util.Log;

// Capacitorプラグインとして認識させるためのアノテーション
@CapacitorPlugin(name = "MonacaCapacitor")
public class MonacaCapacitorPlugin extends Plugin {
    // デバッグログ用のタグを定義（ログフィルタリング用）
    private static final String TAG = "MonacaCapacitorPlugin";

    /**
     * 指定された緯度経度でGoogle Mapsを開くメソッド
     * Google Mapsアプリがない場合はブラウザで地図を開く
     */
    @PluginMethod()
    public void openMap(PluginCall call) {
        try {
            // プラグインに渡された緯度経度パラメータを取得
            Double latitude = call.getDouble("latitude");
            Double longitude = call.getDouble("longitude");

            // デバッグ用に座標をログ出力
            Log.d(TAG, "Opening map with coordinates: lat=" + latitude + ", lng=" + longitude);

            // パラメータの有効性チェック
            if (latitude == null || longitude == null) {
                Log.e(TAG, "Latitude or longitude is null");
                call.reject("Latitude and longitude are required");
                return;
            }

            // Google Maps用のナビゲーションURIを生成
            Uri gmmIntentUri = Uri.parse("google.navigation:q=" + latitude + "," + longitude);
            Log.d(TAG, "Attempting to open Google Maps with URI: " + gmmIntentUri.toString());

            // Google Mapsアプリを開くためのIntentを作成
            Intent mapIntent = new Intent(Intent.ACTION_VIEW, gmmIntentUri);
            mapIntent.setPackage("com.google.android.apps.maps");

            try {
                // Google Mapsアプリを起動
                Log.i(TAG, "Starting Google Maps activity");
                getActivity().startActivity(mapIntent);
                Log.d(TAG, "Successfully opened Google Maps");
                call.resolve();  // 成功をプラグインに通知
            } catch (ActivityNotFoundException e) {
                // Google Mapsアプリが見つからない場合の処理
                Log.w(TAG, "Google Maps not found, falling back to browser", e);

                // ブラウザで開くためのGoogle Maps URLを生成
                Uri browserUri = Uri.parse("https://www.google.com/maps?q=" + latitude + "," + longitude);
                Log.d(TAG, "Attempting to open browser with URI: " + browserUri.toString());

                // ブラウザを開くためのIntentを作成して実行
                Intent browserIntent = new Intent(Intent.ACTION_VIEW, browserUri);
                getActivity().startActivity(browserIntent);
                Log.d(TAG, "Successfully opened map in browser");
                call.resolve();  // 成功をプラグインに通知
            }

        } catch (Exception e) {
            // その他の例外が発生した場合の処理
            Log.e(TAG, "Failed to open map", e);
            call.reject("Failed to open map: " + e.getMessage(), e);  // エラーをプラグインに通知
        }
    }
}