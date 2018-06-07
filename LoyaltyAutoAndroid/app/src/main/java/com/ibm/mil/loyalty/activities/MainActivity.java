package com.ibm.mil.loyalty.activities;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.support.v4.app.Fragment;
import android.support.v4.content.LocalBroadcastManager;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ImageView;


import com.ibm.mil.loyalty.R;
import com.ibm.mil.loyalty.fragments.BaseFragment;
import com.ibm.mil.loyalty.fragments.DealsFragment;
import com.ibm.mil.loyalty.fragments.HomeFragment;
import com.ibm.mil.loyalty.fragments.StationFragment;
import com.ibm.mil.loyalty.utils.FragmentHistory;
import com.ibm.mil.loyalty.utils.Utils;
import com.ibm.mil.loyalty.views.FragNavController;
import com.ibm.mobilefirstplatform.clientsdk.android.core.api.BMSClient;
import com.ibm.mobilefirstplatform.clientsdk.android.push.api.MFPPush;
import com.ibm.mobilefirstplatform.clientsdk.android.push.api.MFPPushException;
import com.ibm.mobilefirstplatform.clientsdk.android.push.api.MFPPushNotificationListener;
import com.ibm.mobilefirstplatform.clientsdk.android.push.api.MFPPushResponseListener;
import com.ibm.mobilefirstplatform.clientsdk.android.push.api.MFPSimplePushNotification;
import com.worklight.jsonstore.api.JSONStoreCollection;
import com.worklight.jsonstore.api.WLJSONStore;
import com.worklight.jsonstore.database.SearchFieldType;

import java.util.LinkedList;
import java.util.List;

import butterknife.BindArray;
import butterknife.BindView;
import butterknife.ButterKnife;

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

public class MainActivity extends BaseActivity implements BaseFragment.FragmentNavigation, FragNavController.TransactionListener, FragNavController.RootFragmentListener {




    @BindView(R.id.content_frame)
    FrameLayout contentFrame;

    @BindView(R.id.toolbar)
    Toolbar toolbar;

    private int[] mTabIconsSelected = {
            R.drawable.tab_home,

            R.drawable.tab_news,

            R.drawable.tab_search,


            };


    @BindArray(R.array.tab_name)
    String[] TABS;

    @BindView(R.id.bottom_tab_layout)
    TabLayout bottomTabLayout;

    private FragNavController mNavController;

    private FragmentHistory fragmentHistory;
    private BroadcastReceiver logoutReceiver, loginRequiredReceiver;
    private MainActivity _this;


    private MFPPush push; // Push client
    private MFPPushNotificationListener notificationListener; // Notification listener to handle a push sent to the phone

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        _this = this;



        // initialize core SDK with IBM Bluemix application Region,
        BMSClient.getInstance().initialize(this, BMSClient.REGION_UK);

        // Grabs push client sdk instance
        push = MFPPush.getInstance();
        // Initialize Push client
        // You can find your App Guid and Client Secret by navigating to the Configure section of your Push dashboard, click Mobile Options (Upper Right Hand Corner)
        // TODO: Please replace <APP_GUID> and <CLIENT_SECRET> with a valid App GUID and Client Secret from the Push dashboard Mobile Options
        push.initialize(this, "abf20737-4aa7-41ed-af6f-86e137299216", "b71f0593-5bfc-48a7-8d89-47ec0453bebf");

        // Create notification listener and enable pop up notification when a message is received
        notificationListener = new MFPPushNotificationListener() {
            @Override
            public void onReceive(final MFPSimplePushNotification message) {
                Log.i("Push", "Received a Push Notification: " + message.toString());
                runOnUiThread(new Runnable() {
                    public void run() {
                        new android.app.AlertDialog.Builder(MainActivity.this)
                                .setTitle("Received a Push Notification")
                                .setMessage(message.getAlert())
                                .setPositiveButton(android.R.string.ok, new DialogInterface.OnClickListener() {
                                    public void onClick(DialogInterface dialog, int whichButton) {
                                    }
                                })
                                .show();
                    }
                });
            }
        };

        ButterKnife.bind(this);
        initToolbar();
        initTab();


        fragmentHistory = new FragmentHistory();
        mNavController = FragNavController.newBuilder(savedInstanceState, getSupportFragmentManager(), R.id.content_frame)
                .transactionListener(this)
                .rootFragmentListener(this, TABS.length)
                .build();
        switchTab(0);

        //jsonstore initialisation
        Context context = this.getApplicationContext();
        try {
            JSONStoreCollection deals= new JSONStoreCollection("deals");
            deals.setSearchField("dealName", SearchFieldType.STRING);
            List<JSONStoreCollection> collections = new LinkedList<>();
            collections.add(deals);
            WLJSONStore.getInstance(context).openCollections(collections);
            // handle success
        } catch(Exception e) {
            // handle failure
        }

        bottomTabLayout.addOnTabSelectedListener(new TabLayout.OnTabSelectedListener() {
            @Override
            public void onTabSelected(TabLayout.Tab tab) {

                fragmentHistory.push(tab.getPosition());

                switchTab(tab.getPosition());

            }

            @Override
            public void onTabUnselected(TabLayout.Tab tab) {

            }

            @Override
            public void onTabReselected(TabLayout.Tab tab) {

                mNavController.clearStack();

                switchTab(tab.getPosition());
            }
        });

        logoutReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                Intent login = new Intent(_this, LoginActivity.class);
                //Make sure to start with the clean stack
                login.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
                login.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                _this.startActivity(login);
            }
        };

        loginRequiredReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                Intent login = new Intent(_this, LoginActivity.class);
                _this.startActivity(login);
            }
        };

        // push registration
        registerDevice();
    } //oncreate

    private void initToolbar() {
        setSupportActionBar(toolbar);
    }
    private static final String NOTIFICATION_MSG = "NOTIFICATION MSG";
    public static Intent makeNotificationIntent(Context context, String msg) {
        Intent intent = new Intent( context, MainActivity.class );
        intent.putExtra( NOTIFICATION_MSG, msg );
        return intent;
    }

    private void initTab() {
        if (bottomTabLayout != null) {
            for (int i = 0; i < TABS.length; i++) {
                bottomTabLayout.addTab(bottomTabLayout.newTab());
                TabLayout.Tab tab = bottomTabLayout.getTabAt(i);
                if (tab != null)
                    tab.setCustomView(getTabView(i));
            }
        }
    }


    private View getTabView(int position) {
        View view = LayoutInflater.from(MainActivity.this).inflate(R.layout.tab_item_bottom, null);
        ImageView icon = (ImageView) view.findViewById(R.id.tab_icon);
        icon.setImageDrawable(Utils.setDrawableSelector(MainActivity.this, mTabIconsSelected[position], mTabIconsSelected[position]));
        return view;
    }


    @Override
    public void onStart() {
        super.onStart();
        LocalBroadcastManager.getInstance(this).registerReceiver(logoutReceiver, new IntentFilter(Constants.ACTION_LOGOUT_SUCCESS));
        LocalBroadcastManager.getInstance(this).registerReceiver(loginRequiredReceiver, new IntentFilter(Constants.ACTION_LOGIN_REQUIRED));


    }

    @Override
    public void onStop() {

        super.onStop();
    }


    public void switchTab(int position) {
        mNavController.switchTab(position);


//        updateToolbarTitle(position);
    }


    @Override
    protected void onResume() {
        super.onResume();
        if (push != null) {
            push.listen(notificationListener);
        }
    }


    @Override
    protected void onPause() {
        LocalBroadcastManager.getInstance(this).unregisterReceiver(logoutReceiver);
        LocalBroadcastManager.getInstance(this).unregisterReceiver(loginRequiredReceiver);
        super.onPause();
        if (push != null) {
            push.hold();
        }
    }


    @Override
    public boolean onOptionsItemSelected(MenuItem item) {

        switch (item.getItemId()) {
            case android.R.id.home:
                onBackPressed();
                return true;
        }
        return super.onOptionsItemSelected(item);
    }

    @Override
    public void onBackPressed() {

        if (!mNavController.isRootFragment()) {
            mNavController.popFragment();
        } else {

            if (fragmentHistory.isEmpty()) {
                super.onBackPressed();
            } else {


                if (fragmentHistory.getStackSize() > 1) {
                    int position = fragmentHistory.popPrevious();
                    switchTab(position);
                    updateTabSelection(position);

                } else {
                    switchTab(0);
                    updateTabSelection(0);
                    fragmentHistory.emptyStack();
                }
            }

        }
    }


    private void updateTabSelection(int currentTab){

        for (int i = 0; i <  TABS.length; i++) {
            TabLayout.Tab selectedTab = bottomTabLayout.getTabAt(i);
            if(currentTab != i) {
                selectedTab.getCustomView().setSelected(false);
            }else{
                selectedTab.getCustomView().setSelected(true);
            }
        }
    }

    @Override
    protected void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        if (mNavController != null) {
            mNavController.onSaveInstanceState(outState);
        }
    }

    @Override
    public void pushFragment(Fragment fragment) {
        if (mNavController != null) {
            mNavController.pushFragment(fragment);
        }
    }


    @Override
    public void onTabTransaction(Fragment fragment, int index) {
        // If we have a backstack, show the back button
        if (getSupportActionBar() != null && mNavController != null) {


            updateToolbar();

        }
    }

    private void updateToolbar() {
        getSupportActionBar().setDisplayHomeAsUpEnabled(!mNavController.isRootFragment());
        getSupportActionBar().setDisplayShowHomeEnabled(!mNavController.isRootFragment());
        getSupportActionBar().setHomeAsUpIndicator(R.drawable.ic_arrow_back);
    }


    @Override
    public void onFragmentTransaction(Fragment fragment, FragNavController.TransactionType transactionType) {
        //do fragmentty stuff. Maybe change title, I'm not going to tell you how to live your life
        // If we have a backstack, show the back button
        if (getSupportActionBar() != null && mNavController != null) {

            updateToolbar();

        }
    }

    @Override
    public Fragment getRootFragment(int index) {
        switch (index) {

            case FragNavController.TAB1:
                return new HomeFragment();
            case FragNavController.TAB2:
                return new DealsFragment();

            case FragNavController.TAB4:
                return new StationFragment();


        }
        throw new IllegalStateException("Need to send an index that we know");
    }



    public void updateToolbarTitle(String title) {
        getSupportActionBar().setTitle(title);
    }


    public void registerDevice() {

        // Checks for null in case registration has failed previously
        if(push==null){
            push = MFPPush.getInstance();
        }
        Log.i("Push", "Registering for notifications");
        // Creates response listener to handle the response when a device is registered.
        MFPPushResponseListener registrationResponselistener = new MFPPushResponseListener<String>() {
            @Override
            public void onSuccess(String response) {

                Log.i("Push", "Successfully registered for push notifications, " + response);
                // Start listening to notification listener now that registration has succeeded
                push.listen(notificationListener);
            }

            @Override
            public void onFailure(MFPPushException exception) {
                String errLog = "Error registering for push notifications: ";
                Log.e("Push",errLog);
            // make push null since registration failed
            push = null;
        }
    };
        push.registerDevice(registrationResponselistener);

  }








}
