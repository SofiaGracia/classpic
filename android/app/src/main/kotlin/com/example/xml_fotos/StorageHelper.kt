package com.example.xml_fotos

import android.content.Context
import android.net.Uri
import androidx.documentfile.provider.DocumentFile


object StorageHelper {

    fun getAppFolder(context: Context, baseUri: Uri, appName: String): DocumentFile? {
        val baseDir = DocumentFile.fromTreeUri(context, baseUri) ?: return null
        return baseDir.findFile(appName) ?: baseDir.createDirectory(appName)
    }

    fun getUserFolder(appFolder: DocumentFile, tipusUsuari: String, grup: List<String>?): DocumentFile? {
        var currentFolder = appFolder.findFile(tipusUsuari) ?: appFolder.createDirectory(tipusUsuari)

        var userFolder = currentFolder
        var grupFolder: DocumentFile?

        if (tipusUsuari == "Alumnes" && grup != null) {
            for (subfolder in grup) {
                grupFolder = userFolder?.findFile(subfolder) ?: userFolder?.createDirectory(subfolder)
            }
        }

        return userFolder
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
}
