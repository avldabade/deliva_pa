package com.apurva.deliva.deliva;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

import android.annotation.TargetApi;
import android.app.ProgressDialog;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.renderscript.Element;
import android.util.Log;
import android.webkit.URLUtil;
import android.widget.Toast;

import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugins.GeneratedPluginRegistrant;


public class MainActivity extends FlutterActivity {

  private static final String CHANNEL = "samples.flutter.io/battery";
  private static final String CHANNEL2 = "plugins.flutter.io/link_preview";
  public MethodChannel.Result result;
  String path = "";
  boolean serverResponse;
  // ProgressDialog pd;
  String sasToken, imagePath, uploadPath;
  ProgressDialog pd;
  boolean isshow = false;
  final private Handler mainHandler = new Handler();
  String sharedPath;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    pd = new ProgressDialog(this);
    pd.setMessage("Uploading...!");

    //pd.show();
    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
            new MethodCallHandler() {

              public Result result;

              @TargetApi(Build.VERSION_CODES.CUPCAKE)
              @Override
              public void onMethodCall(MethodCall call, Result result) {
                this.result = result;
                if (call.method.equals("getBatteryLevel")) {
                  sasToken = call.argument("sasToken");
                  imagePath = call.argument("imagePath");
                  uploadPath = call.argument("uploadPath");
                  Log.e("sasTokenMain+++", sasToken);
                  try {
                    new SendfeedbackJob2().execute().get();
                  } catch (Exception e) {

                  }
                  if (serverResponse) {
                    pd.cancel();
                    result.success(path);
                  } else {
                    pd.cancel();
                    result.success("false");
                  }
                }else {
                  result.notImplemented();
                }
              }
            });
  }
  @TargetApi(Build.VERSION_CODES.CUPCAKE)
  private class SendfeedbackJob2 extends AsyncTask<String, Void, String> {
    @Override
    protected void onPreExecute() {
      pd.show();
      super.onPreExecute();
    }

    @Override
    protected String doInBackground(String[] params) {
      // do above Server call here

      try {
        Log.e("uploadPath2", uploadPath);
        Log.e("imagePath2", imagePath);
        // Get the file data
        File file = new File(imagePath);
        if (!file.exists()) {

        }
        String extantion = file.getAbsolutePath().substring(file.getAbsolutePath().lastIndexOf("."));
        String type = "image_";
        String uniqueID = type + UUID.randomUUID().toString().replace("-", "") + extantion;

        String sasUrl2 = uploadPath + uniqueID + "?";
        // Log.e("sasurl", "path:-" + sasUrl2);
        String sasUrl = sasUrl2 + sasToken;
        Log.e("sasurlshubh", "path:-" + sasUrl);
        String absoluteFilePath = file.getAbsolutePath();
        path = uniqueID;
        FileInputStream fis = new FileInputStream(absoluteFilePath);
        int bytesRead = 0;
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        byte[] b = new byte[1024];
        while ((bytesRead = fis.read(b)) != -1) {
          bos.write(b, 0, bytesRead);
        }
        fis.close();
        byte[] bytes = bos.toByteArray();
        // Post our image data (byte array) to the server
        URL url = new URL(sasUrl.replace("\"", ""));
        HttpURLConnection urlConnection = (HttpURLConnection) url.openConnection();
        urlConnection.setDoOutput(true);
        urlConnection.setConnectTimeout(1000 * 60 * 2);
        urlConnection.setReadTimeout(1000 * 60 * 2);
        urlConnection.setRequestMethod("PUT");
        urlConnection.addRequestProperty("Content-Type", "image");
        urlConnection.setRequestProperty("Content-Length", "" + bytes.length);
        urlConnection.setRequestProperty("x-ms-blob-type", "BlockBlob");
        // Write file data to server
        DataOutputStream wr = new DataOutputStream(urlConnection.getOutputStream());
        wr.write(bytes);
        wr.flush();
        wr.close();
        int response = urlConnection.getResponseCode();
        //    pd.cancel();
        if (response == 201 && urlConnection.getResponseMessage().equals("Created")) {
          Log.e("created", "created shubh");
          serverResponse = true;
          pd.cancel();
          pd.dismiss();
          return "fvf";

        }
      } catch (Exception e) {
        pd.cancel();
        pd.dismiss();
        serverResponse = false;
        e.printStackTrace();
      }
      return "some message";
    }

    @Override
    protected void onPostExecute(String message) {
      pd.cancel();
      pd.dismiss();
      //process message
    }
  }

}
