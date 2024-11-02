import android.bluetooth.le.AdvertiseCallback
import android.bluetooth.le.AdvertiseData
import android.bluetooth.le.AdvertiseSettings
import android.bluetooth.le.BluetoothLeAdvertiser
import android.bluetooth.BluetoothManager
import android.bluetooth.BluetoothAdapter
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
  private val CHANNEL = "ble_advertiser"

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
      if (call.method == "startAdvertising") {
        startAdvertising()
        result.success(null)
      } else {
        result.notImplemented()
      }
    }
  }

  private fun startAdvertising() {
    val bluetoothManager = getSystemService(BLUETOOTH_SERVICE) as BluetoothManager
    val bluetoothAdapter: BluetoothAdapter? = bluetoothManager.adapter
    val advertiser: BluetoothLeAdvertiser? = bluetoothAdapter?.bluetoothLeAdvertiser

    val settings = AdvertiseSettings.Builder()
      .setAdvertiseMode(AdvertiseSettings.ADVERTISE_MODE_LOW_LATENCY)
      .setConnectable(true)
      .setTimeout(0)
      .build()

    val data = AdvertiseData.Builder()
      .setIncludeDeviceName(true)
      .build()

    advertiser?.startAdvertising(settings, data, object : AdvertiseCallback() {
      override fun onStartSuccess(settingsInEffect: AdvertiseSettings) {
        super.onStartSuccess(settingsInEffect)
        // Advertising started successfully
      }

      override fun onStartFailure(errorCode: Int) {
        super.onStartFailure(errorCode)
        // Handle the failure of advertising
      }
    })
  }
}
