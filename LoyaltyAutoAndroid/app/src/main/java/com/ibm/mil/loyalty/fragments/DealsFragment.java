package com.ibm.mil.loyalty.fragments;

import android.os.Bundle;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.ibm.mil.loyalty.R;
import com.ibm.mil.loyalty.activities.MainActivity;
import com.ibm.mil.loyalty.models.DealData;
import com.ibm.mil.loyalty.utils.ImageAdapter;

import java.util.ArrayList;
import java.util.List;

import butterknife.ButterKnife;

import static com.ibm.mil.loyalty.fragments.HomeFragment.dealsArray;

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

public class DealsFragment extends BaseFragment{

    List mDealList;
    DealData mDealData;


    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);



    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment

        View view = inflater.inflate(R.layout.fragment_search, container, false);
        ButterKnife.bind(this, view);
        ( (MainActivity)getActivity()).updateToolbarTitle("Loyalty");

        RecyclerView mRecyclerView = (RecyclerView) view.findViewById(R.id.recyclerview);
        GridLayoutManager mGridLayoutManager = new GridLayoutManager(this.getActivity(), 2);
        mRecyclerView.setLayoutManager(mGridLayoutManager);

        mDealList = new ArrayList<>();

        mDealData = new DealData(dealsArray[0].getName(), dealsArray[0].getHighlight()+ '\n' +dealsArray[0].getFine_print(),
                 R.drawable.deal1);
        mDealList.add(mDealData);
        mDealData = new DealData(dealsArray[1].getName(), dealsArray[1].getHighlight()+'\n'+ dealsArray[1].getFine_print(),
                R.drawable.deal2);
        mDealList.add(mDealData);
        mDealData = new DealData(dealsArray[2].getName(), dealsArray[2].getHighlight()+'\n'+  dealsArray[2].getFine_print(),
                R.drawable.deal3);
        mDealList.add(mDealData);
        mDealData = new DealData(dealsArray[3].getName(), dealsArray[3].getHighlight()+'\n'+  dealsArray[3].getFine_print(),
                R.drawable.deal4);
        mDealList.add(mDealData);
        mDealData = new DealData(dealsArray[4].getName(), dealsArray[4].getHighlight()+'\n'+  dealsArray[4].getFine_print(),
                R.drawable.deal5);
        mDealList.add(mDealData);
        mDealData = new DealData(dealsArray[5].getName(), dealsArray[5].getHighlight()+ '\n'+ dealsArray[5].getFine_print(),
                R.drawable.deal6);
        mDealList.add(mDealData);

        ImageAdapter myAdapter = new ImageAdapter(this.getActivity(), mDealList);
        mRecyclerView.setAdapter(myAdapter);


        return view;
    }






}
