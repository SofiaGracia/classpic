package com.example.xml_fotos

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "classpic/saf_picker"
    private val REQUEST_CODE_OPEN_DOCUMENT_TREE = 1001
    private var resultPending: MethodChannel.Result? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getUri") {
                if (resultPending != null) {
                    result.error("ALREADY_ACTIVE", "Another directory pick is active", null)
                    return@setMethodCallHandler
                }
                resultPending = result
                openDocumentTree()
            } else {
                result.notImplemented()
            }
        }
    }

    private fun openDocumentTree() {
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT_TREE).apply {
            addFlags(Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION)
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
        }
        startActivityForResult(intent, REQUEST_CODE_OPEN_DOCUMENT_TREE)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode == REQUEST_CODE_OPEN_DOCUMENT_TREE) {
            if (resultPending == null) {
                super.onActivityResult(requestCode, resultCode, data)
                return
            }
            if (resultCode == Activity.RESULT_OK && data != null) {
                val uri: Uri? = data.data
                if (uri != null) {
                    contentResolver.takePersistableUriPermission(uri,
                        Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
                    resultPending?.success(uri.toString())
                } else {
                    resultPending?.error("NO_URI", "No directory selected", null)
                }
            } else {
                resultPending?.error("CANCELED", "Directory selection canceled", null)
            }
            resultPending = null
            return
        }
        super.onActivityResult(requestCode, resultCode, data)
    }
}
