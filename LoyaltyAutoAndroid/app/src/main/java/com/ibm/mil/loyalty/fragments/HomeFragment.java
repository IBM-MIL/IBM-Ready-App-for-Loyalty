package com.ibm.mil.loyalty.fragments;

import android.content.Context;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationListener;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.design.widget.TabLayout;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.google.gson.Gson;
import com.ibm.mil.loyalty.R;
import com.ibm.mil.loyalty.activities.MainActivity;
import com.ibm.mil.loyalty.models.AuthenticatedUser;
import com.ibm.mil.loyalty.models.Deal;
import com.ibm.mil.loyalty.models.GasStation;
import com.ibm.mil.loyalty.models.DealData;
import com.ibm.mil.loyalty.utils.ImageAdapter;
import com.ibm.mil.loyalty.utils.Singleton;
import com.worklight.jsonstore.api.JSONStoreCollection;
import com.worklight.jsonstore.api.WLJSONStore;
import com.worklight.jsonstore.exceptions.JSONStoreException;
import com.worklight.wlclient.api.WLFailResponse;
import com.worklight.wlclient.api.WLResourceRequest;
import com.worklight.wlclient.api.WLResponse;
import com.worklight.wlclient.api.WLResponseListener;

import org.json.JSONArray;
import org.json.JSONObject;

import java.net.URI;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

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


public class HomeFragment extends BaseFragment {


    int fragCount;
    public static Location userlocation = new Location("dummyprovider");
    String responseText;
    View view;
    public static GasStation[] gasStationArray;
    public static Deal[] dealsArray;
    GasStation price_station,distance_station;
    Boolean networkfailure = false;
    public ProgressBar pgsBar;
    List mDealList;
    public View view1,view2;
    private RecyclerView mRecyclerView;
    private ImageAdapter imageAdapter,imageAdapterStart ;



    public static HomeFragment newInstance(int instance) {
        Bundle args = new Bundle();
        args.putInt(ARGS_INSTANCE, instance);
        HomeFragment fragment = new HomeFragment();
        fragment.setArguments(args);
        return fragment;
    }


    public HomeFragment() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setHasOptionsMenu(true);
    }

    @Override
    public void onStart() {
        super.onStart();

        mDealList = loadJsonStore();
        if(mDealList.size()>0){
            imageAdapterStart = new ImageAdapter(getActivity(), mDealList);
            mRecyclerView.setAdapter(imageAdapterStart);
            imageAdapterStart.notifyDataSetChanged();
        }



    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {


        //to return to saved state of fragment
        if(view!=null){
            if((ViewGroup)view.getParent()!=null)
                ((ViewGroup)view.getParent()).removeView(view);
            return view;
        }

        view = inflater.inflate(R.layout.fragment_home, container, false);
        pgsBar =    view.findViewById(R.id.progressBar_cyclic);
        pgsBar.setVisibility(View.VISIBLE);




        mDealList = loadJsonStore();

        imageAdapter = new ImageAdapter(getActivity(), mDealList);

        mRecyclerView = (RecyclerView) view.findViewById(R.id.recyclerview);
        GridLayoutManager mGridLayoutManager = new GridLayoutManager(getActivity(), 2);
        mRecyclerView.setLayoutManager(mGridLayoutManager);

        ButterKnife.bind(this, view);
        ((MainActivity)getActivity()).updateToolbarTitle((fragCount ==0) ?"Loyalty":"Sub Home "+fragCount);


        URI adapterPath = null;
        try {
            adapterPath = new URI("/adapters/LoyaltyUserAdapter/user-data/5128675309/en");
            WLResourceRequest request = new WLResourceRequest(adapterPath,WLResourceRequest.GET);
            request.send(new WLResponseListener(){

                public void onSuccess(WLResponse response) {
                    responseText = response.getResponseText();
                    userlocation = getLocation();
                    Log.d("Worklight", responseText);

                }

                public void onFailure(WLFailResponse response) {
                    String responseText = response.getResponseText();
                    Log.d("Worklight", "Was Failure: " + responseText);
                    networkfailure = true;
                    getActivity().runOnUiThread(new Runnable() {
                        @Override
                        public void run() {

                            TextView tv = (TextView) view.findViewById(R.id.errormsg);
                            tv.setText("Network failure");


                        }
                    });
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }

        Bundle args = getArguments();
        if (args != null)
            fragCount = args.getInt(ARGS_INSTANCE);

        //pgsBar.setVisibility(view.GONE);

        //to move to map tab onclick of cheapest station
         view1 = view.findViewById(R.id.cheap_station);
         view2 = view.findViewById(R.id.close_station);

       view1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                Singleton singleton = Singleton.getInstance();
                singleton.setLat(price_station.getGeo_location().getLat());
                singleton.setLon(price_station.getGeo_location().getLongitude());

                TabLayout tabhost = (TabLayout) getActivity().findViewById(R.id.bottom_tab_layout);
                tabhost.getTabAt(2).select();
            }

        });


        view2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                Singleton singleton = Singleton.getInstance();
                singleton.setLat(distance_station.getGeo_location().getLat());
                singleton.setLon(distance_station.getGeo_location().getLongitude());

                TabLayout tabhost = (TabLayout) getActivity().findViewById(R.id.bottom_tab_layout);
                tabhost.getTabAt(2).select();
            }

        });




        return view;
    }


    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        ( (MainActivity)getActivity()).updateToolbarTitle((fragCount == 0) ? "Loyalty" : "Sub Home "+fragCount);

    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
    }

    //new

    public GasStation sortGasStationByGasPrice( ArrayList gasstations){

        Collections.sort(gasstations,GasStation.PriceComparator);

        return (GasStation) gasstations.get(0);
    }

    public GasStation sortGasStationByDistance(ArrayList gasstations){


        Collections.sort(gasstations,GasStation.DistanceComparator);
        return (GasStation) gasstations.get(0);
    }



    public Location getLocation() {

        Gson gson = new Gson();
        final AuthenticatedUser user = gson.fromJson(responseText, AuthenticatedUser.class);

        dealsArray = user.getDeals();
        userlocation.setLatitude(user.getGeo_location().getLat());
        userlocation.setLongitude(user.getGeo_location().getLongitude());


        gasStationArray = user.getGas_stations();
        ArrayList<GasStation> gasStationList = new ArrayList(Arrays.asList(gasStationArray));

         price_station = sortGasStationByGasPrice(gasStationList);
         distance_station = sortGasStationByDistance(gasStationList);
        // dist_in_miles = distance * 0.00062f;

        getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {

                //View v = inflater.inflate(R.layout.main_header, null);
                TextView tv = (TextView) view.findViewById(R.id.cheapPrice);
                tv.setText("$"+String.valueOf(price_station.getGas_price()));
                TextView tv1 = (TextView) view.findViewById(R.id.cheapAddress);
                tv1.setText(price_station.getAddress());

                TextView tv2 = (TextView) view.findViewById(R.id.closePrice);
                tv2.setText("$"+String.valueOf(distance_station.getGas_price()));
                TextView tv3 = (TextView) view.findViewById(R.id.closeAddress);
                tv3.setText(distance_station.getAddress());

                pgsBar.setVisibility(view.GONE);

            }
        });

        return userlocation;
    }

    public List<DealData> loadJsonStore(){


        Context context = getContext();
        JSONStoreCollection collection = null;
        List<JSONObject> jsonResult = null;
        try {
            String collectionName = "deals";
            collection = WLJSONStore.getInstance(context).getCollectionByName(collectionName);
            jsonResult = collection.findAllDocuments();
            // handle success
        } catch(Exception e) {
            // handle failure

        }
        if  (jsonResult != null) {

            try {
                mDealList = new ArrayList<>();
                for (int i = 0; i < jsonResult.size(); i++) {
                    //String json = jsonResult.get(i).toString();
                    String json = jsonResult.get(i).get("json").toString();
                    DealData data = new Gson().fromJson(json, DealData.class);

                    if (!mDealList.contains(data)) {
                        mDealList.add(data);
                    }

                }
            }
            catch(Exception e) {
                Log.d("JSONStore failure","Failed to get data from jsonstore");
            }
        }

        return mDealList;

    }




}


