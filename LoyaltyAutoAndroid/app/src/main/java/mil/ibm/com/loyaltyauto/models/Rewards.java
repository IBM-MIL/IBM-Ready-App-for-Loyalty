package mil.ibm.com.loyaltyauto.models;

/**
 * Created by evancompton on 6/23/15.
 */
public class Rewards {

    private int points;

    private double savings;

    private int progress;

    public Rewards(int points, double savings, int progress) {
        this.points = points;
        this.savings = savings;
        this.progress = progress;
    }

    public int getPoints() {
        return points;
    }

    public void setPoints(int points) {
        this.points = points;
    }

    public double getSavings() {
        return savings;
    }

    public void setSavings(double savings) {
        this.savings = savings;
    }

    public int getProgress() {
        return progress;
    }

    public void setProgress(int progress) {
        this.progress = progress;
    }
}
