package com.example.classpic

import android.content.Context
import android.net.Uri
import androidx.documentfile.provider.DocumentFile


object PhotoUriHelper {

    fun getProfessorPhotoUriHelper(context: Context, baseUri: Uri, dni: String): Uri? {
        val baseDir = DocumentFile.fromTreeUri(context, baseUri) ?: return null
        val profFolder = baseDir.findFile("ClassPic")?.findFile("Professors") ?: return null
        return profFolder.findFile("$dni.jpg")?.uri
    }

    fun getAlumnePhotoUriHelper(context: Context, baseUri: Uri, grup: String, nia: String): Uri? {
        val baseDir = DocumentFile.fromTreeUri(context, baseUri) ?: return null
        val alumneFolder = baseDir.findFile("ClassPic")?.findFile("Alumnes")?.findFile(grup) ?: return null
        return alumneFolder.findFile("$nia.jpg")?.uri
    }
}
