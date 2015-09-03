package mil.ibm.com.loyaltyauto;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.RemoteInput;

public class MyMesageReplyReceiver extends BroadcastReceiver {
    public MyMesageReplyReceiver() {
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        // If you set up the intent as described in
        // "Create conversation read and reply intents",
        // you can get the conversation ID by calling:
        int thisConversationId = intent.getIntExtra("conversation_id", -1);

    }

    /**
     * Get the message text from the intent.
     * Note that you should call
     * RemoteInput.getResultsFromIntent() to process
     * the RemoteInput.
     */
    private CharSequence getMessageText(Intent intent) {
        Bundle remoteInput =
                RemoteInput.getResultsFromIntent(intent);
        if (remoteInput != null) {
            return remoteInput.getCharSequence("2");
        }
        return null;
    }

}
