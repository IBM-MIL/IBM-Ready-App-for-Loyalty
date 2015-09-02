package mil.ibm.com.loyaltyauto.models;

import com.google.gson.annotations.SerializedName;

/**
 * Created by evancompton on 6/23/15.
 */
public class GasStation {

    private String name;

    private double gas_price;

    private String[] amenities;

    private GeoLocation geo_location;

    private String address;

    private Hours hours;

    private int phone_number;

    private String website;

    private Deal[] deals;

    private String[] items;

    public GasStation(String name, double gas_price, String[] amenities, GeoLocation geo_location, String address, Hours hours, int phone_number, String website, Deal[] deals, String[] items) {
        this.name = name;
        this.gas_price = gas_price;
        this.amenities = amenities;
        this.geo_location = geo_location;
        this.address = address;
        this.hours = hours;
        this.phone_number = phone_number;
        this.website = website;
        this.deals = deals;
        this.items = items;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getGas_price() {
        return gas_price;
    }

    public void setGas_price(double gas_price) {
        this.gas_price = gas_price;
    }

    public String[] getAmenities() {
        return amenities;
    }

    public void setAmenities(String[] amenities) {
        this.amenities = amenities;
    }

    public GeoLocation getGeo_location() {
        return geo_location;
    }

    public void setGeo_location(GeoLocation geo_location) {
        this.geo_location = geo_location;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Hours getHours() {
        return hours;
    }

    public void setHours(Hours hours) {
        this.hours = hours;
    }

    public int getPhone_number() {
        return phone_number;
    }

    public void setPhone_number(int phone_number) {
        this.phone_number = phone_number;
    }

    public String getWebsite() {
        return website;
    }

    public void setWebsite(String website) {
        this.website = website;
    }

    public Deal[] getDeals() {
        return deals;
    }

    public void setDeals(Deal[] deals) {
        this.deals = deals;
    }

    public String[] getItems() {
        return items;
    }

    public void setItems(String[] items) {
        this.items = items;
    }

}
