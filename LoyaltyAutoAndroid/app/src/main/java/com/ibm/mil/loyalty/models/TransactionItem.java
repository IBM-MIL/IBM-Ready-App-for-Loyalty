package com.ibm.mil.loyalty.models;

/**
 * Created by evancompton on 6/23/15.
 */
public class TransactionItem {

    private String name;

    private int quantity;

    private String unit;

    private double ppu;

    public TransactionItem(String name, int quantity, String unit, double ppu) {
        this.name = name;
        this.quantity = quantity;
        this.unit = unit;
        this.ppu = ppu;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public double getPpu() {
        return ppu;
    }

    public void setPpu(double ppu) {
        this.ppu = ppu;
    }
}
