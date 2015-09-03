package mil.ibm.com.loyaltyauto.models;

import com.google.gson.annotations.SerializedName;

/**
 * Created by evancompton on 6/23/15.
 */
public class AuthenticatedUser {
    @SerializedName("id")
    private int user_id;

    private int rev;

    private String type;

    private String username;

    private Transaction[] transactions;

    private GasStation[] gas_stations;

    private Deal[] deals;

    private Profile profile;

    private GeoLocation geo_location;

    public AuthenticatedUser(int user_id, int rev, String type, String username, Profile profile, GeoLocation geo_location) {
        this.user_id = user_id;
        this.rev = rev;
        this.type = type;
        this.username = username;
        this.profile = profile;
        this.geo_location = geo_location;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public int getRev() {
        return rev;
    }

    public void setRev(int rev) {
        this.rev = rev;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public Profile getProfile() {
        return profile;
    }

    public void setProfile(Profile profile) {
        this.profile = profile;
    }

    public GeoLocation getGeo_location() {
        return geo_location;
    }

    public void setGeo_location(GeoLocation geo_location) {
        this.geo_location = geo_location;
    }

    public Transaction[] getTransactions() {
        return transactions;
    }

    public void setTransactions(Transaction[] transactions) {
        this.transactions = transactions;
    }

    public GasStation[] getGas_stations() {
        return gas_stations;
    }

    public void setGas_stations(GasStation[] gas_stations) {
        this.gas_stations = gas_stations;
    }

    public Deal[] getDeals() {
        return deals;
    }

    public void setDeals(Deal[] deals) {
        this.deals = deals;
    }
}
