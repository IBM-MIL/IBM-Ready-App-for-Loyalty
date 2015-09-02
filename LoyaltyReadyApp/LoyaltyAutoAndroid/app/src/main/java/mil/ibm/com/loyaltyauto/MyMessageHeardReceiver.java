package mil.ibm.com.loyaltyauto;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.support.v4.app.NotificationManagerCompat;

public class MyMessageHeardReceiver extends BroadcastReceiver {
    public MyMessageHeardReceiver() {
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        // If you set up the intent as described in
        // "Create conversation read and reply intents",
        // you can get the conversation ID by calling:
        int thisConversationId = intent.getIntExtra("conversation_id", -1);

        // Remove the notification to indicate it has been read
        // and update the list of unread conversations in your app.
        NotificationManagerCompat msgNotificationManager =
                NotificationManagerCompat.from(context);
        msgNotificationManager.cancel(thisConversationId);
    }
}
