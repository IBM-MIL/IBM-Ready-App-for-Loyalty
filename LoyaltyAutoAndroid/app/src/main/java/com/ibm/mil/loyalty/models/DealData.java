package com.ibm.mil.loyalty.models;

import com.google.gson.annotations.Expose;

/**
 * Created by dselvara on 5/11/2018.
 */

public class DealData {
    @Expose
    private String dealName;
    @Expose
    private String dealDescription;
    @Expose
    private int dealImage;

    public DealData(String dealName, String dealDescription, int dealImage) {
        this.dealName = dealName;
        this.dealDescription = dealDescription;
        this.dealImage = dealImage;
    }

    public String getDealName() {
        return dealName;
    }

    public String getDealDescription() {
        return dealDescription;
    }

    public int getDealImage() {
        return dealImage;
    }

    @Override
    public boolean equals(Object obj) {


        DealData other = (DealData)obj;
        return dealName.equals(other.dealName);

    }

    @Override
    public int hashCode() {
        return getDealName().hashCode();
    }

}
