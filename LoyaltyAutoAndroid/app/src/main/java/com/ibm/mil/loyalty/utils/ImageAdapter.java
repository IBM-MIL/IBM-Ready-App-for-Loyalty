package com.ibm.mil.loyalty.utils;

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

import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.CardView;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.ibm.mil.loyalty.R;
import com.ibm.mil.loyalty.activities.DealDetailActivity;
import com.ibm.mil.loyalty.models.DealData;

import java.util.List;


public class ImageAdapter extends RecyclerView.Adapter<ImageAdapter.DealViewHolder> {
    private Context mContext;
    private List mDealList;


    public ImageAdapter(Context mContext, List mDealList) {
        this.mContext = mContext;
        this.mDealList = mDealList;
    }

    @Override
    public DealViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View mView = LayoutInflater.from(parent.getContext()).inflate(R.layout.grid_single, parent, false);
        return new DealViewHolder(mView);
    }



    public void onBindViewHolder(final DealViewHolder holder, int position) {
        DealData dealnew = (DealData) mDealList.get(position);
        holder.mImage.setImageResource(dealnew.getDealImage());
        holder.mTitle.setText(dealnew.getDealName());

        holder.mCardView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                Intent mIntent = new Intent(mContext, DealDetailActivity.class);
                DealData dealdata = (DealData) mDealList.get(holder.getAdapterPosition());
                mIntent.putExtra("Title", dealdata.getDealName());
                mIntent.putExtra("Description", dealdata.getDealDescription());
                mIntent.putExtra("Image", dealdata.getDealImage());
                mContext.startActivity(mIntent);

            }
        });


    }

    @Override
    public int getItemCount() {
        return mDealList.size();
    }

    public class DealViewHolder extends RecyclerView.ViewHolder {

        ImageView mImage;
        TextView mTitle;
        CardView mCardView;

        DealViewHolder(View itemView) {
            super(itemView);

             mCardView = (CardView) itemView.findViewById(R.id.cardview);

            mImage = (ImageView) itemView.findViewById(R.id.ivImage);
            mTitle = (TextView) itemView.findViewById(R.id.tvTitle);
        }
    }


}

