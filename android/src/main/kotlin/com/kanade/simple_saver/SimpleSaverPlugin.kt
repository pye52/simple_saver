package com.kanade.simple_saver

import android.content.Context
import android.os.Build

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result as MethodResult

class SimpleSaverPlugin: FlutterPlugin, MethodCallHandler {
  private var context: Context? = null
  private var delegate: SaverDelegate? = null
  private var channel: MethodChannel? = null
  private var binding: FlutterPluginBinding? = null

  companion object {
    private const val CHANNEL = "simple_saver"
  }

  override fun onMethodCall(call: MethodCall, result: MethodResult) {
    when (call.method) {
      "saveFile" -> {
        val path = call.argument<String>("path") ?: ""
        if (path.isEmpty()) return result.error("404", "path is empty", null)
        delegate?.saveFile(path, result)
      }
      else -> result.notImplemented()
    }

  }

  override fun onAttachedToEngine(binding: FlutterPluginBinding) {
    this.binding = binding
    context = binding.applicationContext
    channel = MethodChannel(binding.binaryMessenger, CHANNEL)
    channel?.setMethodCallHandler(this)
    delegate = constructDelegate(binding.applicationContext)
    delegate?.onReady()
  }

  override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
    this.binding = null
    channel?.setMethodCallHandler(null)
    channel = null
    delegate?.onClose()
    delegate = null
  }

  private fun constructDelegate(context: Context): SaverDelegate {
    return if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
      SaverDelegateDefault(context)
    } else {
      SaverDelegateScopeStorage(context)
    }
  }
}