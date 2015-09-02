package mil.ibm.com.loyaltyauto.models;

import com.google.gson.annotations.SerializedName;

/**
 * Created by evancompton on 6/23/15.
 */
public class Transaction {
    @SerializedName("id")
    private int transaction_id;

    private long timestamp;

    private String type;

    private String method;

    private String provider;

    private double total;

    private TransactionItem[] items;

    public Transaction(int transaction_id, long timestamp, String type, String method, String provider, double total, TransactionItem[] items) {
        this.transaction_id = transaction_id;
        this.timestamp = timestamp;
        this.type = type;
        this.method = method;
        this.provider = provider;
        this.total = total;
        this.items = items;
    }

    public int getTransaction_id() {
        return transaction_id;
    }

    public void setTransaction_id(int transaction_id) {
        this.transaction_id = transaction_id;
    }

    public long getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(long timestamp) {
        this.timestamp = timestamp;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }

    public String getProvider() {
        return provider;
    }

    public void setProvider(String provider) {
        this.provider = provider;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    public TransactionItem[] getItems() {
        return items;
    }

    public void setItems(TransactionItem[] items) {
        this.items = items;
    }
}
