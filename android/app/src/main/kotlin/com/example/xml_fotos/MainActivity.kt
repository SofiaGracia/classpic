package com.example.xml_fotos

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import androidx.annotation.NonNull
import androidx.documentfile.provider.DocumentFile
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "classpic/saf_methods"
    private val REQUEST_CODE_OPEN_DOCUMENT_TREE = 1001
    private var resultPending: MethodChannel.Result? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getUri" -> {
                    if (resultPending != null) {
                        result.error("ALREADY_ACTIVE", "Another directory pick is active", null)
                        return@setMethodCallHandler
                    }
                    resultPending = result
                    openDocumentTree()
                }

                "createDirectory" -> {
                    val baseUriStr = call.argument<String>("baseUri")
                    val dirPath = call.argument<String>("name")

                    if (baseUriStr == null || dirPath == null) {
                        result.error("INVALID_ARGUMENTS", "baseUri and name are required", null)
                        return@setMethodCallHandler
                    }

                    try {
                        val baseUri = Uri.parse(baseUriStr)
                        val pickedDir = DocumentFile.fromTreeUri(this, baseUri)
                        if (pickedDir == null || !pickedDir.isDirectory) {
                            result.error("INVALID_URI", "Base URI is not a directory", null)
                        } else {
                            val finalDir = createDirectoryRecursively(pickedDir, dirPath)
                            if (finalDir != null && finalDir.isDirectory) {
                                result.success(finalDir.uri.toString())
                            } else {
                                result.error("FAILED", "Failed to create subdirectories", null)
                            }
                        }
                    } catch (e: Exception) {
                        result.error("ERROR", "Exception: ${e.message}", null)
                    }
                }

                "esborraFitxer" -> {
                    val path = call.argument<String>("path")
                    if (path != null) {
                        val file = File(path)
                        if (file.exists()) {
                            val deleted = file.delete()
                            result.success(deleted)
                        } else {
                            result.success(false)
                        }
                    } else {
                        result.error("ARGUMENT_MISSING", "Path no proporcionat", null)
                    }
                }

                else -> result.notImplemented()
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

    private fun createDirectoryRecursively(base: DocumentFile, path: String): DocumentFile? {
        var current = base
        val parts = path.split("/")

        for (part in parts) {
            val existing = current.findFile(part)
            current = if (existing != null && existing.isDirectory) {
                existing
            } else {
                current.createDirectory(part) ?: return null
            }
        }

        return current
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
                    contentResolver.takePersistableUriPermission(
                        uri,
                        Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION
                    )
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
