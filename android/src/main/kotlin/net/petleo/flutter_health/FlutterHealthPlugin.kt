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
import java.util.*
import java.util.concurrent.TimeUnit
import kotlin.concurrent.thread


class FlutterHealthPlugin(val activity: Activity, val channel: MethodChannel) : MethodCallHandler {
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "flutter_health")
            channel.setMethodCallHandler(FlutterHealthPlugin(registrar.activity(), channel))
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "getPlatformVersion") {
            thread {
                val fitnessOptions = FitnessOptions.builder()
                        .addDataType(DataType.TYPE_STEP_COUNT_DELTA, FitnessOptions.ACCESS_READ)
                        .build()

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
                result.success("Android ${android.os.Build.VERSION.RELEASE} .. ")
            }
        } else {
            result.notImplemented()
        }
    }
}
