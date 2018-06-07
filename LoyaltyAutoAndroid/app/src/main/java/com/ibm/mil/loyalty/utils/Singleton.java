package com.ibm.mil.loyalty.utils;

import com.ibm.mil.loyalty.models.DealData;

import java.util.ArrayList;
import java.util.List;

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

public class Singleton
{
    private static Singleton instance;

    public static Double Lat,Lon;

    private List mDealList;

    public static void initInstance()
    {
        if (instance == null)
        {
            // Create the instance
            instance = new Singleton();
        }
    }

    public static synchronized Singleton getInstance()
    {
        if (instance == null)
        {
            // Create the instance
            instance = new Singleton();
        }
        return instance;
    }

    private Singleton()
    {
        // Constructor hidden because this is a singleton
        mDealList = new ArrayList();
    }

    public void setLat(double Lat)
    {
        this.Lat = Lat;
    }
    public void setLon(double Lon){

        this.Lon = Lon;
    }

    public void addDeal(DealData dealData){
        mDealList.add(dealData);
    }

    public List getDealList(){
        return mDealList;
    }

    public Double getLat(){
        return this.Lat;
    }
    public Double getLon(){
        return this.Lon;
    }
    public static void reset() {
        instance = new Singleton();
    }
}
