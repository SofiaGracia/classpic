package com.example.xml_fotos

import android.content.Context
import android.net.Uri
import androidx.documentfile.provider.DocumentFile

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result



object StorageHelper {

    fun getAppFolder(context: Context, baseUri: Uri, appName: String): DocumentFile? {
        val baseDir = DocumentFile.fromTreeUri(context, baseUri) ?: return null
        return baseDir.findFile(appName) ?: baseDir.createDirectory(appName)
    }

    fun getUserFolder(appFolder: DocumentFile, tipusUsuari: String, grup: List<String>?): DocumentFile? {
        var currentFolder = appFolder.findFile(tipusUsuari) ?: appFolder.createDirectory(tipusUsuari)

        var userFolder = currentFolder
        var grupFolder: DocumentFile? = userFolder

        if (tipusUsuari == "Alumnes" && grup != null) {
            for (subfolder in grup) {
                grupFolder = userFolder?.findFile(subfolder) ?: userFolder?.createDirectory(subfolder)
            }
        }

        return grupFolder
    }

    fun getUserFolderIfExists(appFolder: DocumentFile, tipusUsuari: String, grup: String?): DocumentFile? {
        val userFolder = appFolder.findFile(tipusUsuari) ?: return null

        return if (tipusUsuari == "Alumnes" && grup != null) {
            userFolder.findFile(grup)
        } else {
            userFolder
        }
    }

    fun writeImageFile(context: Context, destinacio: DocumentFile, fileName: String, bytes: ByteArray): Boolean {
        destinacio.findFile("$fileName.jpg")?.delete()
        val file = destinacio.createFile("image/jpeg", fileName) ?: return false
        return try {
            context.contentResolver.openOutputStream(file.uri)?.use {
                it.write(bytes)
                it.flush()
            }
            true
        } catch (e: Exception) {
            false
        }
    }

    fun deleteDocumentFileRecursive(file: DocumentFile): Boolean {
        if (file.isDirectory) {
            file.listFiles().forEach {
                deleteDocumentFileRecursive(it)
            }
        }
        return file.delete()
    }

    fun eliminaFotos(context: Context, call: MethodCall, result: Result): Boolean {
        val uris = call.argument<List<String>>("uris") ?: emptyList()
        var allDeleted = true

        for (uriStr in uris) {
            val uri = Uri.parse(uriStr)
            try {
                val docFile = DocumentFile.fromSingleUri(context, uri)
                if (docFile != null && docFile.exists()) {
                    val deleted = docFile.delete()
                    if (!deleted) allDeleted = false
                } else {
                    allDeleted = false
                }
            } catch (e: Exception) {
                e.printStackTrace()
                allDeleted = false
            }
        }

        return allDeleted
    }

    fun checkUri(context: Context, uriStr: String, appName: String, tipusFolder: String): Boolean {
        val baseUri = Uri.parse(uriStr)
        val baseDir = DocumentFile.fromTreeUri(context, baseUri)
        if (baseDir == null) {
            return false
        }

        val appFolder = baseDir.findFile(appName)
        if (appFolder == null) {
            return false
        }

        val tipusFolder = appFolder.findFile(tipusFolder)
        if (tipusFolder == null){
            return false
        }

        return true
    }
}
