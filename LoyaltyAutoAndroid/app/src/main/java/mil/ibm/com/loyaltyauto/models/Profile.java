package mil.ibm.com.loyaltyauto.models;

/**
 * Created by evancompton on 6/23/15.
 */
public class Profile {

    private String[] preferences;

    private String[] tags;

    private Contact contact;

    private Vehicle[] vehicles;

    private Rewards rewards;

    public Profile(String[] preferences, String[] tags, Contact contact, Vehicle[] vehicles, Rewards rewards) {
        this.preferences = preferences;
        this.tags = tags;
        this.contact = contact;
        this.vehicles = vehicles;
        this.rewards = rewards;
    }

    public String[] getPreferences() {
        return preferences;
    }

    public void setPreferences(String[] preferences) {
        this.preferences = preferences;
    }

    public String[] getTags() {
        return tags;
    }

    public void setTags(String[] tags) {
        this.tags = tags;
    }

    public Contact getContact() {
        return contact;
    }

    public void setContact(Contact contact) {
        this.contact = contact;
    }

    public Vehicle[] getVehicles() {
        return vehicles;
    }

    public void setVehicles(Vehicle[] vehicles) {
        this.vehicles = vehicles;
    }

    public Rewards getRewards() {
        return rewards;
    }

    public void setRewards(Rewards rewards) {
        this.rewards = rewards;
    }

}
