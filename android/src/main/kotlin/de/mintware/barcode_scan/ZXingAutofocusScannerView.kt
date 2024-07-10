package de.mintware.barcode_scan

import android.content.Context
import android.hardware.Camera
import android.util.Log
import me.dm7.barcodescanner.core.CameraWrapper
import me.dm7.barcodescanner.zxing.ZXingScannerView
import com.google.zxing.PlanarYUVLuminanceSource
import de.mintware.barcode_scan.BarcodeView.Companion.scanHeight

class ZXingAutofocusScannerView(context: Context) : ZXingScannerView(context) {

    private var callbackFocus = false
    private var autofocusPresence = false

    override fun setupCameraPreview(cameraWrapper: CameraWrapper?) {
        cameraWrapper?.mCamera?.parameters?.let { parameters ->
            try {
                autofocusPresence = parameters.supportedFocusModes.contains(Camera.Parameters.FOCUS_MODE_AUTO);
                parameters.focusMode = Camera.Parameters.FOCUS_MODE_CONTINUOUS_PICTURE
                cameraWrapper.mCamera.parameters = parameters
            } catch (ex: Exception) {
                callbackFocus = true
            }
        }
        super.setupCameraPreview(cameraWrapper)
    }

    override fun setAutoFocus(state: Boolean) {
        //Fix to avoid crash on devices without autofocus (Issue #226)
        if(autofocusPresence){
            super.setAutoFocus(callbackFocus)
        }
    }

    override fun buildLuminanceSource(
        data: ByteArray?,
        width: Int,
        height: Int
    ): PlanarYUVLuminanceSource? {
        val rect = getFramingRectInPreview(width, height) ?: return null
        // Go ahead and assume it's YUV rather than die.
        var source: PlanarYUVLuminanceSource? = null
        try {
//            source = new PlanarYUVLuminanceSource(data, width, height, 0, 0,
//                    rect.width(), rect.height(), false);
            source = PlanarYUVLuminanceSource(
                data, width, height, 0, 0,
                width, scanHeight!!, false
            )
        } catch (e: java.lang.Exception) {
        }
        return source
    }

}