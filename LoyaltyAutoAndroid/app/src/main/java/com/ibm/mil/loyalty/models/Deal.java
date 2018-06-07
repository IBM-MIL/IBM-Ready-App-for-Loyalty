package com.ibm.mil.loyalty.models;

/**
 * Created by evancompton on 6/23/15.
 */
public class Deal {

    private String name;

    private String image_name;

    private int expiration;

    private String highlight;

    private String fine_print;

    private boolean saved = false;

    public Deal(String name, String image_name, int expiration, String highlight, String fine_print) {
        this.name = name;
        this.image_name = image_name;
        this.expiration = expiration;
        this.highlight = highlight;
        this.fine_print = fine_print;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getImage_name() {
        return image_name;
    }

    public void setImage_name(String image_name) {
        this.image_name = image_name;
    }

    public int getExpiration() {
        return expiration;
    }

    public void setExpiration(int expiration) {
        this.expiration = expiration;
    }

    public String getHighlight() {
        return highlight;
    }

    public void setHighlight(String highlight) {
        this.highlight = highlight;
    }

    public String getFine_print() {
        return fine_print;
    }

    public void setFine_print(String fine_print) {
        this.fine_print = fine_print;
    }

    public boolean isSaved() {
        return saved;
    }

    public void setSaved(boolean saved) {
        this.saved = saved;
    }
}
