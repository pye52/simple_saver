package com.kanade.simple_saver

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Environment
import com.kanade.simple_saver.utils.MediaStoreUtils
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream
import java.io.IOException

class SaverDelegateDefault(context: Context) : SaverDelegate(context) {
    override fun saveFile(path: String, result: MethodChannel.Result) {
        try {
            val file = File(path)
            val filename = file.nameWithoutExtension
            val extension = file.extension
            val mimeType = MediaStoreUtils.getMIMEType(extension)

            if (mimeType.isNullOrEmpty()) {
                result.success(SaveResultModel(false, "mimeType is empty").toHashMap())
                return
            }
            val relativePath = if (mimeType.startsWith("image")) {
                Environment.DIRECTORY_PICTURES
            } else if (mimeType.startsWith("video")) {
                Environment.DIRECTORY_MOVIES
            } else {
                Environment.DIRECTORY_DOWNLOADS
            }
            val uri = generateUri(filename,relativePath)

            val outputStream = context.contentResolver?.openOutputStream(uri)!!
            val fileInputStream = FileInputStream(file)
            val buffer = ByteArray(10240)
            var count: Int
            while (fileInputStream.read(buffer).also { count = it } > 0) {
                outputStream.write(buffer, 0, count)
            }

            outputStream.flush()
            outputStream.close()
            fileInputStream.close()

            context.sendBroadcast(Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, uri))
            result.success(SaveResultModel(true).toHashMap())
        } catch (e: IOException) {
            result.success(SaveResultModel(false, "Couldn't save the file").toHashMap())
        }
    }

    private fun generateUri(fileName: String, relativePath: String): Uri {
        @Suppress("DEPRECATION")
        val storePath =
            Environment.getExternalStorageDirectory().absolutePath + File.separator + relativePath
        val appDir = File(storePath)
        if (!appDir.exists()) {
            appDir.mkdirs()
        }
        return Uri.fromFile(File(appDir, fileName))
    }
}
