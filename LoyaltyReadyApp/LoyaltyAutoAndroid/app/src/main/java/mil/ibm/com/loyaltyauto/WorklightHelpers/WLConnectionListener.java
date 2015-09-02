package mil.ibm.com.loyaltyauto.WorklightHelpers;

import android.util.Log;

import com.worklight.wlclient.api.WLFailResponse;
import com.worklight.wlclient.api.WLResponse;
import com.worklight.wlclient.api.WLResponseListener;

/**
 * Created by evancompton on 6/11/15.
 */
public class WLConnectionListener implements WLResponseListener {

    private WLConnectionDelegate delegate;

    public WLConnectionListener(WLConnectionDelegate delegate) {
        this.delegate = delegate;
    }


    public void onSuccess(WLResponse response) {
        Log.d("Worklight", "Connected Successfully");
        delegate.connectionSuccessful();
    }

    public void onFailure(WLFailResponse response) {
        Log.d("Worklight", "Connected Unsuccessfully");
    }

}
