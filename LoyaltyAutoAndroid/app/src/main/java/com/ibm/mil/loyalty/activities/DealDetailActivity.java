package com.ibm.mil.loyalty.activities;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.google.gson.Gson;
import com.ibm.mil.loyalty.R;
import com.ibm.mil.loyalty.models.DealData;
import com.ibm.mil.loyalty.utils.Singleton;
import com.worklight.jsonstore.api.JSONStoreAddOptions;
import com.worklight.jsonstore.api.JSONStoreCollection;
import com.worklight.jsonstore.api.WLJSONStore;
import com.worklight.jsonstore.exceptions.JSONStoreException;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

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


public class DealDetailActivity extends AppCompatActivity {

    Toolbar mToolbar;
    ImageView mDeal;
    TextView mDescription;

    public static ArrayList savedDealList;
    public DealData savedDealData;
    private Activity context;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_deal_detail);
        context = this.getParent();

        mToolbar = (Toolbar) findViewById(R.id.toolbardeal);
        mDeal = (ImageView) findViewById(R.id.ivImage);
        mDescription = (TextView) findViewById(R.id.tvDescription);

        final Bundle mBundle = getIntent().getExtras();
        if (mBundle != null) {
            mToolbar.setTitle(mBundle.getString("Title"));
            mDeal.setImageResource(mBundle.getInt("Image"));
            mDescription.setText(mBundle.getString("Description"));


                    }

        FloatingActionButton btnFab = (FloatingActionButton) findViewById(R.id.btnFloatingAction);
        savedDealList = new ArrayList<DealData>();
        btnFab.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                System.out.println("hello FAB");


                savedDealData = new DealData(mBundle.getString("Title"), mBundle.getString("Description")+ '\n' +mBundle.getInt("Image"),
                        mBundle.getInt("Image"));

                    //add entry to JSONStore
                    Context context = getApplicationContext();
                    try {
                        String collectionName = "deals";
                        JSONStoreCollection collection = WLJSONStore.getInstance(context).getCollectionByName(collectionName);
                        //Add options.
                        JSONStoreAddOptions options = new JSONStoreAddOptions();
                        options.setMarkDirty(false);
                        Gson gson = new Gson();
                        String jsonString = gson.toJson(savedDealData);
                        JSONObject data = new JSONObject(jsonString);
                        collection.addData(data, options);

                        // handle success
                    } catch (Exception e) {
                        // handle failure
                    }

                onBackPressed();


            }
        });
    }
}
