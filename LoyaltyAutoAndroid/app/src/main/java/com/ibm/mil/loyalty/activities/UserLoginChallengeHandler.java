package com.ibm.mil.loyalty.activities;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.support.v4.content.LocalBroadcastManager;
import android.util.Log;
import android.widget.TextView;

import com.ibm.mil.loyalty.R;
import com.worklight.wlclient.api.WLAuthorizationManager;
import com.worklight.wlclient.api.WLClient;
import com.worklight.wlclient.api.WLFailResponse;
import com.worklight.wlclient.api.WLLoginResponseListener;
import com.worklight.wlclient.api.WLLogoutResponseListener;
import com.worklight.wlclient.api.challengehandler.SecurityCheckChallengeHandler;

import org.json.JSONException;
import org.json.JSONObject;
/**
 * Copyright 2016 IBM Corp.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


public class UserLoginChallengeHandler extends SecurityCheckChallengeHandler {
    private static String securityCheckName = "UserLogin";
    private int remainingAttempts = -1;
    private String errorMsg = "";
    private Context context;
    private boolean isChallenged = false;

    private LocalBroadcastManager broadcastManager;

    private UserLoginChallengeHandler() {
        super(securityCheckName);
        context = WLClient.getInstance().getContext();
        broadcastManager = LocalBroadcastManager.getInstance(context);

        //Reset the current user
        SharedPreferences preferences = context.getSharedPreferences(Constants.PREFERENCES_FILE, Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = preferences.edit();
        editor.remove(Constants.PREFERENCES_KEY_USER);
        editor.apply();

        //Receive login requests
        broadcastManager.registerReceiver(new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                try {
                    JSONObject credentials = new JSONObject(intent.getStringExtra("credentials"));
                    login(credentials);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        },new IntentFilter(Constants.ACTION_LOGIN));

        //Receive logout requests
        broadcastManager.registerReceiver(new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                logout();
            }
        }, new IntentFilter(Constants.ACTION_LOGOUT));


    }

    public static UserLoginChallengeHandler createAndRegister(){
        UserLoginChallengeHandler challengeHandler = new UserLoginChallengeHandler();
        WLClient.getInstance().registerChallengeHandler(challengeHandler);
        return challengeHandler;
    }


    @Override
    public void handleChallenge(JSONObject jsonObject) {
        Log.d(securityCheckName, "Challenge Received");
        isChallenged = true;
        try {
            if(jsonObject.isNull("errorMsg")){
                errorMsg = "";
            }
            else{
                errorMsg = jsonObject.getString("errorMsg");
            }

            remainingAttempts = jsonObject.getInt("remainingAttempts");

        } catch (JSONException e) {
            e.printStackTrace();
        }

        Intent intent = new Intent();
        intent.setAction(Constants.ACTION_LOGIN_REQUIRED);
        intent.putExtra("errorMsg", errorMsg);
        intent.putExtra("remainingAttempts",remainingAttempts);
        broadcastManager.sendBroadcast(intent);

    }

    @Override
    public void handleFailure(JSONObject error) {
        super.handleFailure(error);
        isChallenged = false;
        if(error.isNull("failure")){
            errorMsg = "Failed to login. Please try again later.";
        }
        else {
            try {
                errorMsg = error.getString("failure");
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
        Intent intent = new Intent();
        intent.setAction(Constants.ACTION_LOGIN_FAILURE);
        intent.putExtra("errorMsg",errorMsg);
        broadcastManager.sendBroadcast(intent);
        Log.d(securityCheckName, "handleFailure");
    }

    @Override
    public void handleSuccess(JSONObject identity) {
        Log.d(securityCheckName, "getting in shandleSuccess");
        super.handleSuccess(identity);
        isChallenged = false;
        try {
            //Save the current user
            SharedPreferences preferences = context.getSharedPreferences(Constants.PREFERENCES_FILE, Context.MODE_PRIVATE);
            SharedPreferences.Editor editor = preferences.edit();
            editor.putString(Constants.PREFERENCES_KEY_USER, identity.getJSONObject("user").toString());
            Log.d(securityCheckName, identity.toString());
            editor.apply();
        } catch (JSONException e) {
            e.printStackTrace();
        }

        Intent intent = new Intent();
        intent.setAction(Constants.ACTION_LOGIN_SUCCESS);
        broadcastManager.sendBroadcast(intent);
        Log.d(securityCheckName, "handleSuccess");
    }

    public void login(JSONObject credentials){
        if(isChallenged){
            submitChallengeAnswer(credentials);
        }
        else{
            WLAuthorizationManager.getInstance().login(securityCheckName, credentials, new WLLoginResponseListener() {
                @Override
                public void onSuccess() {
                    Log.d(securityCheckName, "Login Preemptive Success");

                }

                @Override
                public void onFailure(WLFailResponse wlFailResponse) {
                    Log.d(securityCheckName,wlFailResponse.getErrorMsg()+wlFailResponse.getErrorStatusCode().toString());
                    Log.d(securityCheckName, "Login Preemptive Failure, check network connection to MFP UserLogin adapter");

                }
            });
        }
    }


    public void logout(){
        WLAuthorizationManager.getInstance().logout(securityCheckName, new WLLogoutResponseListener() {
            @Override
            public void onSuccess() {
                Log.d(securityCheckName, "Logout Success");
                Intent intent = new Intent();
                intent.setAction(Constants.ACTION_LOGOUT_SUCCESS);
                broadcastManager.sendBroadcast(intent);
            }

            @Override
            public void onFailure(WLFailResponse wlFailResponse) {
                Log.d(securityCheckName, "Logout Failure");
                Intent intent = new Intent();
                intent.setAction(Constants.ACTION_LOGOUT_FAILURE);
                broadcastManager.sendBroadcast(intent);

            }
        });
    }

}

