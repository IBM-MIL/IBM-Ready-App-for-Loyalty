package com.ibm.mil.loyalty.models;

import com.google.gson.annotations.SerializedName;

/**
 * Created by evancompton on 6/23/15.
 */
public class GeoLocation {

    public float lat;

    @SerializedName("lon")
    public float longitude;

    public GeoLocation(float lat, float longitude) {
        this.lat = lat;
        this.longitude = longitude;
    }

    public float getLat() {
        return lat;
    }

    public void setLat(float lat) {
        this.lat = lat;
    }

    public float getLongitude() {
        return longitude;
    }

    public void setLongitude(float longitude) {
        this.longitude = longitude;
    }
}
