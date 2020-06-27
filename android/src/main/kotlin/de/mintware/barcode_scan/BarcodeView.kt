package de.mintware.barcode_scan

import android.content.Context
import android.hardware.Camera
import android.os.Looper
import android.util.Log
import android.view.View
import android.widget.LinearLayout
import com.google.zxing.BarcodeFormat
import com.google.zxing.Result
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView


class BarcodeView : PlatformView , MyScannerView.ResultHandler , MethodChannel.MethodCallHandler{

    private lateinit var config: Protos.Configuration
    private var scannerView: MyScannerView?=null
    private lateinit var mContext: Context
    private lateinit var channelHandler: MethodChannel
    private val TAG="BarcodeView"
    
    companion object {
        const val TOGGLE_FLASH = 200
        const val CANCEL = 300
        const val EXTRA_CONFIG = "config"
        const val EXTRA_RESULT = "scan_result"
        const val EXTRA_ERROR_CODE = "error_code"
        var scanHeight: Int?=null

        private val formatMap: Map<Protos.BarcodeFormat, BarcodeFormat> = mapOf(
                Protos.BarcodeFormat.aztec to BarcodeFormat.AZTEC,
                Protos.BarcodeFormat.code39 to BarcodeFormat.CODE_39,
                Protos.BarcodeFormat.code93 to BarcodeFormat.CODE_93,
                Protos.BarcodeFormat.code128 to BarcodeFormat.CODE_128,
                Protos.BarcodeFormat.dataMatrix to BarcodeFormat.DATA_MATRIX,
                Protos.BarcodeFormat.ean8 to BarcodeFormat.EAN_8,
                Protos.BarcodeFormat.ean13 to BarcodeFormat.EAN_13,
                Protos.BarcodeFormat.interleaved2of5 to BarcodeFormat.ITF,
                Protos.BarcodeFormat.pdf417 to BarcodeFormat.PDF_417,
                Protos.BarcodeFormat.qr to BarcodeFormat.QR_CODE,
                Protos.BarcodeFormat.upce to BarcodeFormat.UPC_E
        )

    }

    constructor(context: Context, message: BinaryMessenger, args: Double){
        mContext=context
        BarcodeView.Companion.scanHeight=DisplayUtil.dip2px(context,args)
        Log.d("args","args==$args")
        config = Protos.Configuration.newBuilder()
                .putAllStrings(mapOf(
                        "cancel" to "Cancel",
                        "flash_on" to "Flash on",
                        "flash_off" to "Flash off"
                ))
                .setAndroid(Protos.AndroidConfiguration
                        .newBuilder()
                        .setAspectTolerance(0.5)
                        .setUseAutoFocus(true))
                .addAllRestrictFormat(mutableListOf())
                .setUseCamera(-1)
                .build()
        setupScannerView()
        var handler:android.os.Handler=android.os.Handler(Looper.getMainLooper())
        handler.postDelayed(Runnable { startScanner() },1000)
        channelHandler=MethodChannel(message,"plugins.flutter.io/barcode_view")
        channelHandler.setMethodCallHandler(this)
//        startScanner();
    }

    private fun setupScannerView() {
        if (scannerView != null) {
            return
        }

        scannerView = MyScannerView(mContext).apply {
            setAutoFocus(true)
            val restrictedFormats = mapRestrictedBarcodeTypes()
            if (restrictedFormats.isNotEmpty()) {
                setFormats(restrictedFormats)
            }

            // this parameter will make your HUAWEI phone works great!
            setAspectTolerance(config.android.aspectTolerance.toFloat())
            if (config.autoEnableFlash) {
                flash = config.autoEnableFlash
            }
        }
    }

    fun startScanner(){
        scannerView?.setResultHandler(this)
        if (config.useCamera > -1) {
            scannerView?.startCamera(config.useCamera)
        } else {
            scannerView?.startCamera()
        }
    }

    private fun mapRestrictedBarcodeTypes(): List<BarcodeFormat> {
        val types: MutableList<BarcodeFormat> = mutableListOf()

        this.config.restrictFormatList.filterNotNull().forEach {
            if (!formatMap.containsKey(it)) {
                print("Unrecognized")
                return@forEach
            }

            types.add(formatMap.getValue(it))
        }

        return types
    }

    override fun handleResult(result: Result?) {
        Log.v("handleResult","result=${result}")
        var response:String=""
        if (result == null) {
            response=""
        } else {
            response=result.text
        }
        channelHandler.invokeMethod("onScanCallBack",response);
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
    }
    
    override fun dispose() {
        scannerView?.stopCamera()
    }

    override fun getView(): View {
        return scannerView as MyScannerView;
    }
}