package com.kanade.simple_saver

import android.content.Context
import android.os.Build
import com.kanade.simple_saver.utils.MediaStoreUtils
import com.kanade.simple_saver.utils.MediaStoreUtils.scanUri
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch
import java.io.File
import java.io.FileInputStream
import java.io.IOException
import io.flutter.plugin.common.MethodChannel.Result as MethodResult

class SaverDelegateScopeStorage(context: Context) : SaverDelegate(context) {
    private val mainScope = CoroutineScope(Dispatchers.IO)

    override fun saveFile(path: String, result: MethodResult) {
        mainScope.launch(Dispatchers.IO) {
            val file = File(path)
            val filename = file.nameWithoutExtension
            val extension = file.extension
            val mimeType = MediaStoreUtils.getMIMEType(extension)

            if (mimeType.isNullOrEmpty()) {
                result.success(SaveResultModel(false, "mimeType is empty").toHashMap())
                return@launch
            }

            val uri = if (mimeType.startsWith("image")) {
                MediaStoreUtils.createImageUri(context, filename, mimeType)
            } else if (mimeType.startsWith("video")) {
                MediaStoreUtils.createVideoUri(context, filename, mimeType)
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                MediaStoreUtils.createDownloadUri(context, filename)
            } else {
                null
            }
            if (uri == null) {
                result.success(SaveResultModel(false, "could not create uri").toHashMap())
                return@launch
            }

            try {
                context.contentResolver.openOutputStream(uri, "w")?.use { outputStream ->
                    val fileInputStream = FileInputStream(path)

                    val buffer = ByteArray(10240)
                    var count: Int
                    while (fileInputStream.read(buffer).also { count = it } > 0) {
                        outputStream.write(buffer, 0, count)
                    }

                    outputStream.flush()
                    outputStream.close()
                    fileInputStream.close()
                    scanUri(context, uri, mimeType)
                    result.success(SaveResultModel(true).toHashMap())
                }
            } catch (e: IOException) {
                e.printStackTrace()
                result.success(SaveResultModel(false, "Couldn't save the file\n$uri").toHashMap())
            }
        }
    }

    override fun onClose() {
        super.onClose()
        mainScope.cancel()
    }

}