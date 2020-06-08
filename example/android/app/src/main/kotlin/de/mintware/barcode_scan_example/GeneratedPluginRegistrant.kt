package de.mintware.barcode_scan_example

import de.mintware.barcode_scan.BarcodeScanPlugin
import io.flutter.plugin.common.PluginRegistry

object GeneratedPluginRegistrant {

    fun registerWith(registry: PluginRegistry) {
        if (alreadyRegisteredWith(registry)) {
            return
        }
        BarcodeScanPlugin.registerWith(registry.registrarFor("de.mintware.barcode_scan.BarcodeScanPlugin"))
    }

    private fun alreadyRegisteredWith(registry: PluginRegistry): Boolean {
        val key = GeneratedPluginRegistrant::class.java.canonicalName
        if (registry.hasPlugin(key)) {
            return true
        }
        registry.registrarFor(key)
        return false
    }
    
}