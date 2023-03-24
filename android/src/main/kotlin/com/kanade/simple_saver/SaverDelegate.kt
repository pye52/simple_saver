package com.kanade.simple_saver

import android.content.Context
import io.flutter.plugin.common.MethodChannel.Result as MethodResult

abstract class SaverDelegate(protected val context: Context) {
    open fun onReady() {}

    abstract fun saveFile(path: String, result: MethodResult)

    open fun onClose() {}
}