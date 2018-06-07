package com.ibm.mil.loyalty.models;

/**
 * Created by evancompton on 6/23/15.
 */
public class Hours {

    private int open;

    private int close;

    public Hours(int open, int close) {
        this.open = open;
        this.close = close;
    }

    public int getOpen() {
        return open;
    }

    public void setOpen(int open) {
        this.open = open;
    }

    public int getClose() {
        return close;
    }

    public void setClose(int close) {
        this.close = close;
    }
}
