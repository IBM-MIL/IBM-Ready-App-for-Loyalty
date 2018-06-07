package com.ibm.mil.loyalty.models;

import android.location.Location;

import com.google.gson.annotations.SerializedName;

import java.util.Comparator;

import static com.ibm.mil.loyalty.fragments.HomeFragment.userlocation;

/**
 * Created by evancompton on 6/23/15.
 */
public class GasStation implements Comparable<GasStation>{

    private String name;

    private float gas_price;

    private String[] amenities;

    private GeoLocation geo_location;

    private String address;

    private Hours hours;

    private long phone_number;

    private String website;

    private Deal[] deals;

    private String[] items;

    public GasStation(String name, float gas_price, String[] amenities, GeoLocation geo_location, String address, Hours hours, int phone_number, String website, Deal[] deals, String[] items) {
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

    public float getGas_price() {
        return gas_price;
    }

    public void setGas_price(float gas_price) {
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

    public long getPhone_number() {
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

    public static Comparator<GasStation> PriceComparator = new Comparator<GasStation>() {
        public int compare(GasStation g1, GasStation g2) {
          // return Float.compare(g1.getGas_price() - g2.getGas_price());
           return g1.compareTo(g2);


        }
    };


    public int compareTo(GasStation gasStation) {

       return Float.compare(this.gas_price, gasStation.gas_price);
    }

    public static Comparator<GasStation> DistanceComparator = new Comparator<GasStation>() {
        @Override
        public int compare(GasStation g1, GasStation g2) {
            return Double.compare(distance(g1.geo_location.getLat(), userlocation.getLatitude(), g1.getGeo_location().getLongitude(), userlocation.getLongitude(), 0, 0),
                    distance(g2.getGeo_location().getLat(), userlocation.getLatitude(), g2.getGeo_location().getLongitude(), userlocation.getLongitude(), 0, 0));
        }
    };


    public static double distance(double lat1, double lat2, double lon1,
                                  double lon2, double el1, double el2) {

        final int R = 6371; // Radius of the earth

        double latDistance = Math.toRadians(lat2 - lat1);
        double lonDistance = Math.toRadians(lon2 - lon1);
        double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(lonDistance / 2) * Math.sin(lonDistance / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        double distance = R * c * 1000; // convert to meters

        double height = el1 - el2;

        distance = Math.pow(distance, 2) + Math.pow(height, 2);

        return Math.sqrt(distance);
    }
    }


