package com.kanade.simple_saver

class SaveResultModel(
    var isSuccess: Boolean,
    var errorMessage: String? = null
) {
    fun toHashMap(): HashMap<String, Any?> {
        val hashMap = HashMap<String, Any?>()
        hashMap["isSuccess"] = isSuccess
        hashMap["errorMessage"] = errorMessage
        return hashMap
    }
}