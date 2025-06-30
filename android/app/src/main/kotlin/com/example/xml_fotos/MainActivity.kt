package com.example.xml_fotos

import android.app.Activity
import android.content.Intent
import android.content.Context
import android.net.Uri
import android.os.Bundle
import android.util.Log
import androidx.annotation.NonNull
import androidx.documentfile.provider.DocumentFile
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File



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

                "getProfessorPhotoUri" ->{
                    val dni = call.argument<String>("dni")!!
                    val baseUriStr = call.argument<String>("uri")!!

                    val baseUri = Uri.parse(baseUriStr)
                    val uri = getProfessorPhotoUri(context, baseUri, dni)
                    result.success(uri?.toString())
                }

                "getAlumnePhotoUri" ->{
                    val nia = call.argument<String>("nia")!!
                    val baseUriStr = call.argument<String>("uri")!!
                    val grup = call.argument<String>("grup")!!


                    val baseUri = Uri.parse(baseUriStr)
                    val uriRes = getAlumnePhotoUri(context, baseUri, grup, nia)
                    result.success(uriRes?.toString())
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

                "savePhotoFile" -> {
                    val uriStr = call.argument<String>("uri")!!
                    val appName = call.argument<String>("appName")!!
                    val id = call.argument<String>("id")!!
                    val tipusUsuari = call.argument<String>("tipusUsuari")!!
                    val grup = call.argument<String>("grup") // pot ser null per a professors
                    val bytes = call.argument<ByteArray>("bytes")

                    if (bytes == null) {
                        result.error("NO_BYTES", "No image bytes provided", null)
                        return@setMethodCallHandler
                    }

                    val baseUri = Uri.parse(uriStr)
                    val baseDir = DocumentFile.fromTreeUri(context, baseUri)
                    if (baseDir == null) {
                        result.error("INVALID_URI", "Could not access base directory", null)
                        return@setMethodCallHandler
                    }

                    //Troba la carpeta de l'aplicació
                    val appFolder = baseDir.findFile(appName) ?: baseDir.createDirectory(appName)
                    if (appFolder == null) {
                        result.error("NO_FOLDER", "Could not access/create $appName folder", null)
                        return@setMethodCallHandler
                    }

                    // Troba el subdirectori
                    val usuariFolder = appFolder.findFile(tipusUsuari) ?: appFolder.createDirectory(tipusUsuari)
                    if (usuariFolder == null) {
                        result.error("NO_FOLDER", "Could not access/create $tipusUsuari folder", null)
                        return@setMethodCallHandler
                    }

                    // Si és alumne, entra dins del grup
                    val destinacio = if (tipusUsuari == "Alumnes" && grup != null) {
                        usuariFolder.findFile(grup) ?: usuariFolder.createDirectory(grup)
                    } else {
                        usuariFolder
                    }

                    if (destinacio == null) {
                        result.error("NO_DEST", "Could not access/create final directory", null)
                        return@setMethodCallHandler
                    }

                    // Esborra si ja existix
                    destinacio.findFile("$id.jpg")?.delete()

                    // Crea el fitxer
                    val photoFile = destinacio.createFile("image/jpeg", id)
                    if (photoFile == null) {
                        result.error("FILE_ERROR", "Could not create file", null)
                        return@setMethodCallHandler
                    }

                    try {
                        val out = context.contentResolver.openOutputStream(photoFile.uri)
                        out?.write(bytes)
                        out?.flush()
                        out?.close()
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("WRITE_ERROR", "Failed to write image: ${e.message}", null)
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

    fun getProfessorPhotoUri(context: Context, baseUri: Uri, dni: String): Uri? {
        val baseDir = DocumentFile.fromTreeUri(context, baseUri)
        if (baseDir == null) {
            Log.e("PhotoUri", "No es pot accedir al baseUri")
            return null
        }
        baseDir?.listFiles()?.forEach {
            Log.d("SAF", "Fitxer a Alumnes: ${it.name}")
        }

        val classPic = baseDir.findFile("ClassPic") ?: baseDir?.createDirectory("ClassPic")
        if (classPic == null) {
            Log.e("PhotoUri", "No s'ha trobat la carpeta ClassPic")
            return null
        }

        val professorsFolder = baseDir?.findFile("Professors")
        if (professorsFolder == null) {
            Log.e("PhotoUri", "No s'ha trobat la carpeta Alumnes")
            return null
        }
        val photoFile = professorsFolder?.findFile("$dni.jpg")
        if (photoFile == null) {
            Log.e("PhotoUri", "No s'ha trobat la foto per $nia.jpg")
            return null
        }

        return photoFile?.uri
    }

    fun getAlumnePhotoUri(
        context: Context,
        baseUri: Uri,
        grup: String,
        nia: String
    ): Uri? {
        val baseDir = DocumentFile.fromTreeUri(context, baseUri)
        if (baseDir == null) {
            Log.e("PhotoUri", "No es pot accedir al baseUri")
            return null
        }
        baseDir?.listFiles()?.forEach {
            Log.d("SAF", "Fitxer a Alumnes: ${it.name}")
        }

        val classPic = baseDir.findFile("ClassPic") ?: baseDir?.createDirectory("ClassPic")
        if (classPic == null) {
            Log.e("PhotoUri", "No s'ha trobat la carpeta ClassPic")
            return null
        }

        val alumnes = classPic.findFile("Alumnes") ?: classPic?.createDirectory("Alumnes")
        if (alumnes == null) {
            Log.e("PhotoUri", "No s'ha trobat la carpeta Alumnes")
            return null
        }

        val grupFolder = alumnes.findFile(grup) ?: alumnes?.createDirectory(grup)
        if (grupFolder == null) {
            Log.e("PhotoUri", "No s'ha trobat el grup: $grup")
            return null
        }

        val photoFile = grupFolder.findFile("$nia.jpg")
        if (photoFile == null) {
            Log.e("PhotoUri", "No s'ha trobat la foto per $nia.jpg")
            return null
        }

        return photoFile.uri
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
