package mil.ibm.com.loyaltyauto.models;

import com.google.gson.annotations.SerializedName;

/**
 * Created by evancompton on 6/23/15.
 */
public class GeoLocation {

    private double lat;

    @SerializedName("long")
    private double longitude;

    public GeoLocation(double lat, double longitude) {
        this.lat = lat;
        this.longitude = longitude;
    }

    public double getLat() {
        return lat;
    }

    public void setLat(double lat) {
        this.lat = lat;
    }

    public double getLongitude() {
        return longitude;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }
}
