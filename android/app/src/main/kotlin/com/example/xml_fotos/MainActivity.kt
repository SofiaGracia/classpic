package com.example.classpic

import android.app.Activity
import android.content.Intent
import android.content.ContentResolver
import android.content.Context
import android.net.Uri
import android.provider.DocumentsContract
import android.os.Bundle
import android.util.Log

import androidx.annotation.NonNull
import androidx.documentfile.provider.DocumentFile
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

import com.example.classpic.StorageHelper
import com.example.classpic.PhotoUriHelper

class MainActivity : FlutterActivity() {
    private val CHANNEL = "classpic/saf_methods"
    private val REQUEST_CODE_OPEN_DOCUMENT_TREE = 1001
    private var resultPending: MethodChannel.Result? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            Log.d("MethodCallHandler", "Mètode rebut: ${call.method}")
            when (call.method) {
                "getUri" -> {
                    if (resultPending != null) {
                        result.error("ALREADY_ACTIVE", "Another directory pick is active", null)
                        return@setMethodCallHandler
                    }
                    resultPending = result
                    openDocumentTree()
                }

                "creaEstructuraProf" -> {
                    val baseUriStr = call.argument<String>("baseUri")
                        ?: return@setMethodCallHandler result.error("MISSING_ARG", "Missing uri", null)
                    val appName = call.argument<String>("appName")
                        ?: return@setMethodCallHandler result.error("MISSING_ARG", "Missing appName", null)

                    try {
                        val baseUri = Uri.parse(baseUriStr)
                        val appFolder = StorageHelper.getAppFolder(context, baseUri, appName)
                        val profFolder = StorageHelper.getUserFolder(appFolder!!, "Professors", null)
                        if (profFolder != null && profFolder.isDirectory) {
                            result.success(profFolder.uri.toString())
                        } else {
                            result.error("FAILED", "Failed to create professor folder", null)
                        }
                    } catch (e: Exception) {
                        result.error("ERROR", "Exception: ${e.message}", null)
                    }
                }

                "creaEstructuraAlu" -> {
                    val baseUriStr = call.argument<String>("baseUri")
                        ?: return@setMethodCallHandler result.error("MISSING_ARG", "Missing uri", null)
                    val appName = call.argument<String>("appName")
                        ?: return@setMethodCallHandler result.error("MISSING_ARG", "Missing appName", null)
                    val grups = call.argument<List<String>>("grups")

                    try {
                        val baseUri = Uri.parse(baseUriStr)
                        val appFolder = StorageHelper.getAppFolder(context, baseUri, appName)
                        val aluFolder = StorageHelper.getUserFolder(appFolder!!, "Alumnes", grups)
                        if (aluFolder != null && aluFolder.isDirectory) {
                            result.success(aluFolder.uri.toString())
                        } else {
                            result.error("FAILED", "Failed to create alumnes folder", null)
                        }
                    } catch (e: Exception) {
                        result.error("ERROR", "Exception: ${e.message}", null)
                    }
                }

                "getProfessorPhotoUri" -> {
                    val dni = call.argument<String>("dni")!!
                    val baseUriStr = call.argument<String>("uri")!!
                    val baseUri = Uri.parse(baseUriStr)
                    try {
                        val uri: Uri? = PhotoUriHelper.getProfessorPhotoUriHelper(context, baseUri, dni)
                        if (uri != null) result.success(uri.toString())
                        else result.success(uri)
                    } catch (e: Exception) {
                        result.error("READ_ERROR", "Failed to get image: $e", null)
                    }
                }

                "getAlumnePhotoUri" -> {
                    val nia = call.argument<String>("nia")!!
                    val baseUriStr = call.argument<String>("uri")!!
                    val grup = call.argument<String>("grup")!!
                    val baseUri = Uri.parse(baseUriStr)

                    try {
                        val uri: Uri? = PhotoUriHelper.getAlumnePhotoUriHelper(context, baseUri, grup, nia)
                        if (uri != null) result.success(uri.toString())
                        else result.success(uri)

                    } catch (e: Exception) {
                        result.error("READ_ERROR", "Failed to get image: $e", null)
                    }
                }

                "deleteProfsPhotos" -> {
                    val dnis = call.argument<List<String>>("dnis")
                        ?: return@setMethodCallHandler result.error("MISSING_ARG", "Missing dnis", null)
                    val uriStr = call.argument<String>("uri")
                        ?: return@setMethodCallHandler result.error("MISSING_ARG", "Missing uri", null)
                    val appName = call.argument<String>("appName")
                        ?: return@setMethodCallHandler result.error("MISSING_ARG", "Missing appName", null)

                    val baseUri = Uri.parse(uriStr)
                    val results = mutableMapOf<String, Boolean>()

                    try {
                        val baseDir = DocumentFile.fromTreeUri(context, baseUri)
                            ?.findFile(appName)
                            ?.findFile("Professors")

                        if (baseDir == null || !baseDir.isDirectory) {
                            return@setMethodCallHandler result.error("NOT_FOUND", "Professors folder not found", null)
                        }

                        for (dni in dnis) {
                            val photoFile = baseDir.findFile("$dni.jpg")
                            val deleted = photoFile?.delete() ?: false
                            results[dni] = deleted
                        }

                        result.success(results)
                    } catch (e: Exception) {
                        result.error("WRITE_ERROR", "Failed to delete file: ${e.message}", null)
                    }
                }

                "readBytesFromUri" -> {
                    val uriStr = call.argument<String>("uri")
                    if (uriStr == null) {
                        result.error("NO_URI", "No uri provided", null)
                    } else {
                        try {
                            val uri = Uri.parse(uriStr)
                            val inputStream = contentResolver.openInputStream(uri)
                            val bytes = inputStream?.use { it.readBytes() }
                            result.success(bytes)
                        } catch (e: Exception) {
                            result.error("READ_ERROR", "Failed to read bytes: ${e.message}", null)
                        }
                    }
                }

                "deleteGrupFolders" -> {
                    val uriStr = call.argument<String>("uri")
                        ?: return@setMethodCallHandler result.error("MISSING_ARG", "Missing uri", null)
                    val appName = call.argument<String>("appName")
                        ?: return@setMethodCallHandler result.error("MISSING_ARG", "Missing appName", null)
                    val grups = call.argument<List<String>>("grups")
                        ?: return@setMethodCallHandler result.error("MISSING_ARG", "Missing grups", null)
                    val aluName = call.argument<String>("aluName")
                        ?: return@setMethodCallHandler result.error("MISSING_ARG", "Missing aluName", null)

                    val baseUri = Uri.parse(uriStr)
                    val baseDir = DocumentFile.fromTreeUri(context, baseUri)
                    if (baseDir == null) {
                        result.error("INVALID_URI", "Could not access base directory", null)
                        return@setMethodCallHandler
                    }

                    val appFolder = baseDir.findFile(appName)
                    if (appFolder == null) {
                        result.error("NO_FOLDER", "Could not access $appName folder", null)
                        return@setMethodCallHandler
                    }

                    val aluFolder = appFolder.findFile(aluName)
                    if (aluFolder == null) {
                        result.error("NO_FOLDER", "Could not access $aluName folder", null)
                        return@setMethodCallHandler
                    }

                    val results = mutableMapOf<String, Boolean>()
                    for (grup in grups) {
                        val grupFolder = aluFolder.findFile(grup)
                        if (grupFolder != null) {
                            try {
                                results[grup] = StorageHelper.deleteDocumentFileRecursive(grupFolder)
                            } catch (e: Exception) {
                                results[grup] = false
                            }
                        } else {
                            results[grup] = false
                        }
                    }

                    result.success(results)
                }

                "savePhotoFile" -> {
                    val uriStr = call.argument<String>("uri")!!
                    val appName = call.argument<String>("appName")!!
                    val id = call.argument<String>("id")!!
                    val tipusUsuari = call.argument<String>("tipusUsuari")!!
                    val grup = call.argument<List<String>>("grup")
                    val bytes = call.argument<ByteArray>("bytes")

                    val baseUri = Uri.parse(uriStr)
                    val appFolder = StorageHelper.getAppFolder(context, baseUri, appName)
                    val destinacio = appFolder?.let { StorageHelper.getUserFolder(it, tipusUsuari, grup) }

                    if (destinacio == null) {
                        result.error("NO_DEST", "Could not access/create destination", null)
                        return@setMethodCallHandler
                    }

                    val res = StorageHelper.writeImageFile(context, destinacio, id, bytes!!)
                    if (res) result.success(true)
                    else result.error("WRITE_ERROR", "Failed to write image", null)
                }

                "eliminaFotos" -> {

                    try {
                        val deleted = StorageHelper.eliminaFotos(context, call, result)
                        if (deleted) result.success(true)
                        else result.error("PRIMER_ERROR", "Failed to delete image", false)
                    } catch (e: Exception) {
                        result.error("WRITE_ERROR", "Failed to delete image", false)
                    }
                }

                "createFolder" -> {
                    val uriStr = call.argument<String>("uri")!!
                    val appName = call.argument<String>("appName")!!
                    val tipusUsuari = call.argument<String>("tipusUsuari")!!
                    val grup = call.argument<List<String>>("grup")

                    val baseUri = Uri.parse(uriStr)
                    val appFolder = StorageHelper.getAppFolder(context, baseUri, appName)
                    val destinacio = appFolder?.let { StorageHelper.getUserFolder(it, tipusUsuari, grup) }

                    if (destinacio == null) {
                        result.error("WRITE_ERROR", "Failed to create folder", false)
                        return@setMethodCallHandler
                    } else {
                        result.success(true)
                    }

                }

                "renameFolder" -> {
                    val newName = call.argument<String>("newName")!!
                    val uriStr = call.argument<String>("uri")!!
                    val appName = call.argument<String>("appName")!!
                    val tipusUsuari = call.argument<String>("tipusUsuari")!!
                    val grup = call.argument<String>("grup")

                    val baseUri = Uri.parse(uriStr)
                    val appFolder = StorageHelper.getAppFolder(context, baseUri, appName)
                    val destinacio = appFolder?.let { StorageHelper.getUserFolderIfExists(it, tipusUsuari, grup) }

                    if (destinacio == null) {
                        result.error("NO_DEST", "Could not access/create destination", null)
                        return@setMethodCallHandler
                    }

                    val parent = destinacio.parentFile
                    if (parent == null) {
                        result.error("NO_PARENT", "No s’ha pogut obtindre la carpeta pare", null)
                        return@setMethodCallHandler
                    }

                    val parentUri = parent.uri
                    val parentDocumentId = DocumentsContract.getDocumentId(parentUri)
                    val childrenUri = DocumentsContract.buildChildDocumentsUriUsingTree(parentUri, parentDocumentId)

                    val cursor = context.contentResolver.query(
                        childrenUri,
                        arrayOf(DocumentsContract.Document.COLUMN_DISPLAY_NAME),
                        null,
                        null,
                        null
                    )

                    val newNameValue = newName.trim()

                    cursor?.use {
                        while (it.moveToNext()) {
                            val existingName = it.getString(0)
                            if (existingName == newNameValue) {
                                result.error("FOLDER_EXISTS", "Ja existeix una carpeta amb eixe nom", null)
                                return@setMethodCallHandler
                            }
                        }
                    }

                    val newFolderUri = DocumentsContract.createDocument(
                        contentResolver,
                        parentUri,
                        DocumentsContract.Document.MIME_TYPE_DIR,
                        newNameValue
                    ) ?: run {
                        result.error("WRITE_ERROR", "Failed to create folder", null)
                        return@setMethodCallHandler
                    }

                    val targetFolder = DocumentFile.fromTreeUri(context, newFolderUri)

                    if (targetFolder == null || !targetFolder.exists()) {
                        result.error("FOLDER_INVALID", "No s’ha pogut accedir al nou directori", null)
                        return@setMethodCallHandler
                    }

                    fun copyRecursively(src: DocumentFile, dest: DocumentFile) {
                        val files = src.listFiles()
                        for (file in files) {
                            if (file.isDirectory) {
                                val newSubfolder = dest.createDirectory(file.name ?: "Subcarpeta")
                                if (newSubfolder != null) {
                                    copyRecursively(file, newSubfolder)
                                }
                            } else if (file.isFile) {
                                val inputStream = context.contentResolver.openInputStream(file.uri)
                                val outputFile = dest.createFile(file.type ?: "application/octet-stream", file.name ?: "fitxer")
                                if (inputStream != null && outputFile != null) {
                                    val outputStream = context.contentResolver.openOutputStream(outputFile.uri)
                                    if (outputStream != null) {
                                        inputStream.copyTo(outputStream)
                                        outputStream.close()
                                    }
                                    inputStream.close()
                                }
                            }
                        }
                    }

                    try {
                        copyRecursively(destinacio, targetFolder)
                        // Opcional: esborrar l'original si cal
                        destinacio.delete()
                        result.success("FOLDER_RENAMED_AND_COPIED")
                    } catch (e: Exception) {
                        result.error("COPY_FAILED", "Error en copiar el contingut: ${e.message}", null)
                    }

                }

                "checkUri" -> {
                    val uriStr = call.argument<String>("uri")
                        ?: return@setMethodCallHandler result.error("MISSING_ARG", "Missing uri", false)
                    val appName = call.argument<String>("appName")
                        ?: return@setMethodCallHandler result.error("MISSING_ARG", "Missing appName", false)
                    val tipusFolder = call.argument<String>("folder")
                        ?: return@setMethodCallHandler result.error("MISSING_ARG", "Missing folder", false)

                    val dirExists = StorageHelper.checkUri(context, uriStr, appName, tipusFolder)
                    if(dirExists){
                        result.success(true)
                    }else{
                        result.error("ESTRUCTURE ERROR", "Estructure does not exists", false)
                    }
                }

                "checkFolderHasPhotos" -> {
                    val baseUriStr = call.argument<String>("uri")
                        ?: return@setMethodCallHandler result.error("MISSING_ARG", "Missing uri", false)
                    val appName = call.argument<String>("appName")
                        ?: return@setMethodCallHandler result.error("MISSING_ARG", "Missing appName", false)
                    val user = call.argument<String>("user")
                        ?: return@setMethodCallHandler result.error("MISSING_ARG", "Missing user", false)
                    val groups = call.argument<List<String>?>("groups")

                    val baseUri = Uri.parse(baseUriStr)
                    val appFolder = StorageHelper.getAppFolder(context, baseUri, appName)

                    val folder = StorageHelper.getUserFolder(appFolder!!, user, groups)

                    val hasPhotos = folder?.listFiles()
                        ?.any { it.isFile && it.name?.endsWith(".jpg", ignoreCase = true) == true
                                || it.name?.endsWith(".jpeg", ignoreCase = true) == true
                                || it.name?.endsWith(".png", ignoreCase = true) == true }

                    if (hasPhotos == true) {
                        result.success(true)
                    } else {
                        result.success(false)
                    }
                }
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
