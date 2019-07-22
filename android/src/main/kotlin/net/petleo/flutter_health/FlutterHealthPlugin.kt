package net.petleo.flutter_health

import android.app.Activity
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.fitness.Fitness
import com.google.android.gms.fitness.FitnessOptions
import com.google.android.gms.fitness.data.DataType
import com.google.android.gms.fitness.request.DataReadRequest
import com.google.android.gms.fitness.result.DataReadResponse
import com.google.android.gms.tasks.Tasks
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import android.content.Intent
import android.util.Log
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener
import java.util.*
import java.util.concurrent.TimeUnit
import kotlin.concurrent.thread


const val GOOGLE_FIT_PERMISSIONS_REQUEST_CODE = 1111

class FlutterHealthPlugin(val activity: Activity, val channel: MethodChannel) : MethodCallHandler, ActivityResultListener {

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "flutter_health")
            val plugin = FlutterHealthPlugin(registrar.activity(), channel)

            registrar.addActivityResultListener(plugin)
            channel.setMethodCallHandler(plugin)
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent): Boolean {
        Log.d("authResult", "AUTH RESULT    $resultCode   ")
        Log.d("authResult 222", activity.localClassName)
        if (resultCode == Activity.RESULT_OK) {
            if (requestCode == GOOGLE_FIT_PERMISSIONS_REQUEST_CODE) {
                Log.d("authThere", "AUTH GRANTED")
                mResult?.success(true)
            }else{
                Log.d("authNotThere", "AUTH NOT GRANTED")
            }
        }
        return false
    }

    var mResult: Result? = null

    val fitnessOptions = FitnessOptions.builder()
            .addDataType(DataType.TYPE_STEP_COUNT_DELTA, FitnessOptions.ACCESS_READ)
            .build()

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "requestAuthorization") {
            mResult = result

            if (!GoogleSignIn.hasPermissions(GoogleSignIn.getLastSignedInAccount(activity), fitnessOptions)) {
                Log.d("authResult 111", activity.localClassName)
                GoogleSignIn.requestPermissions(
                        activity, // your activity
                        GOOGLE_FIT_PERMISSIONS_REQUEST_CODE,
                        GoogleSignIn.getLastSignedInAccount(activity),
                        fitnessOptions)
            } else {
                Log.d("authThere", "AUTH ALREADY THERE")
            }
        } else if (call.method == "getGFHealthData") {
             thread {
                 val gsa = GoogleSignIn.getAccountForExtension(activity.applicationContext, fitnessOptions)

                 val startTime = Calendar.getInstance()
                 startTime.add(Calendar.DATE, -5)
                 val endTime = Calendar.getInstance()

                 val response = Fitness.getHistoryClient(activity.applicationContext, gsa)
                         .readData(DataReadRequest.Builder()
                                 .read(DataType.TYPE_STEP_COUNT_DELTA)
                                 .setTimeRange(startTime.timeInMillis, endTime.timeInMillis, TimeUnit.MILLISECONDS)
                                 .build())

                 val readDataResult = Tasks.await<DataReadResponse>(response)
                 val dataSet = readDataResult.getDataSet(DataType.TYPE_STEP_COUNT_DELTA)
                 result.success("DATASET SIZE IS ${dataSet.dataPoints.size}");
             }
        } else {
            result.notImplemented()
        }
    }
}
