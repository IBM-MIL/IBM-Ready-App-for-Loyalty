package mil.ibm.com.loyaltyauto;

import android.app.ActionBar;
import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.GridLayout;
import android.widget.GridView;
import android.widget.RelativeLayout;
import android.widget.ScrollView;
import android.widget.Toast;

import com.google.gson.Gson;
import com.worklight.wlclient.api.WLClient;
import com.worklight.wlclient.api.WLFailResponse;
import com.worklight.wlclient.api.WLResourceRequest;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.Arrays;

import mil.ibm.com.loyaltyauto.WorklightHelpers.WLConnectionDelegate;
import mil.ibm.com.loyaltyauto.WorklightHelpers.WLConnectionListener;
import mil.ibm.com.loyaltyauto.models.AuthenticatedUser;

import com.worklight.wlclient.api.WLResponse;
import com.worklight.wlclient.api.WLResponseListener;
import com.xtify.sdk.api.XtifySDK;


public class MainActivity extends Activity implements WLConnectionDelegate, WLResponseListener {

    //final String XTIFY_APP_KEY = getString(R.string.xtify_app_key);
    //final String PROJECT_NUM = getString(R.string.google_project_num); // This is the Google Project Number

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        RecyclerView rv = (RecyclerView) findViewById(R.id.recycler);
        GridLayoutManager gm = new GridLayoutManager(getApplicationContext(), 2);
        gm.setSpanSizeLookup(new GridLayoutManager.SpanSizeLookup() {
            @Override
            public int getSpanSize(int position) {
                if(position == 0) {
                    return 2;
                } else {
                    return 1;
                }

            }
        });
        rv.setLayoutManager(gm);


        WLClient client = WLClient.createInstance(this);
        WLConnectionListener listener = new WLConnectionListener(this);
       client.connect(listener);

        ActionBar mActionBar = getActionBar();
        mActionBar.setBackgroundDrawable(new ColorDrawable(0xffffffff));

    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu items for use in the action bar
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.menu_main, menu);
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    protected void onStart() {
        super.onStart();
        String xtify_app_key = getString(R.string.xtify_app_key);
        String project_num = getString(R.string.google_project_num);
        XtifySDK.start(getApplicationContext(), xtify_app_key, project_num);
    }


    public void connectionSuccessful() {
        URI adapterPath = null;
        try {
            adapterPath = new URI("/adapters/LoyaltyUserAdapter/user-data/5128675309/en");
            WLResourceRequest request = new WLResourceRequest(adapterPath,WLResourceRequest.GET);
            request.send(this);
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }

    }

    public void onSuccess(WLResponse response) {
        String responseText = response.getResponseText();
        Gson gson = new Gson();
        final LayoutInflater inflater = this.getLayoutInflater();
        final AuthenticatedUser user = gson.fromJson(responseText, AuthenticatedUser.class);
        runOnUiThread(new Runnable() {
            @Override
            public void run() {

                RecyclerView rv = (RecyclerView) findViewById(R.id.recycler);


                RecyclerAdapter adapter = new RecyclerAdapter(Arrays.asList(user.getDeals()));
                HeaderViewRecyclerAdapter headerAdapter = new HeaderViewRecyclerAdapter(adapter);

                View v = inflater.inflate(R.layout.main_header, null);
                headerAdapter.addHeaderView(v);
                rv.setAdapter(headerAdapter);

                rv.requestLayout();






            }
        });


        Log.d("Worklight", responseText);
    }

    public void onFailure(WLFailResponse response) {
        String responseText = response.getResponseText();
        Log.d("Worklight", "Was Failure: " + responseText);
    }
}
