package mil.ibm.com.loyaltyauto;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.NotificationCompat;
import android.support.v4.app.NotificationManagerCompat;
import android.support.v4.app.RemoteInput;
import android.util.Log;

import com.xtify.sdk.api.XtifyBroadcastReceiver;
import com.xtify.sdk.api.XtifySDK;

public class XtifyNotifier extends XtifyBroadcastReceiver {
    String TAG = XtifyNotifier.class.getName();
    private static final String NOTIFICATION_TITLE = "com.xtify.sdk.NOTIFICATION_TITLE";
    private static final String NOTIFICATION_CONTENT = "com.xtify.sdk.NOTIFICATION_CONTENT";

    @Override
    public void onMessage(Context context, Bundle msgExtras) {
        Log.i(TAG, "-- Notification recived");
        Log.i(TAG, "Notification Title: " + msgExtras.getString(NOTIFICATION_TITLE));
        Log.i(TAG, "Notification Content: " + msgExtras.getString(NOTIFICATION_CONTENT));
        String message = msgExtras.getString(NOTIFICATION_CONTENT);
        Intent msgHeardIntent = new Intent()
                .addFlags(Intent.FLAG_INCLUDE_STOPPED_PACKAGES)
                .setAction("mil.ibm.com.loyaltyauto.messagingservice.MY_ACTION_MESSAGE_HEARD")
                .putExtra("conversation_id", 1);

        PendingIntent msgHeardPendingIntent =
                PendingIntent.getBroadcast(context,
                        1,
                        msgHeardIntent,
                        PendingIntent.FLAG_UPDATE_CURRENT);

        Intent msgReplyIntent = new Intent()
                .addFlags(Intent.FLAG_INCLUDE_STOPPED_PACKAGES)
                .setAction("mil.ibm.com.loyaltyauto.messagingservice.MY_ACTION_MESSAGE_REPLY")
                .putExtra("conversation_id", 1);

        PendingIntent msgReplyPendingIntent = PendingIntent.getBroadcast(
                context,
                1,
                msgReplyIntent,
                PendingIntent.FLAG_UPDATE_CURRENT);

        // Present the message when sent from Push notification console.
        // Build a RemoteInput for receiving voice input in a Car Notification
        RemoteInput remoteInput = new RemoteInput.Builder("2")
                .setLabel("Some Label")
                .build();

        // Create an unread conversation object to organize a group of messages
        // from a particular sender.
        NotificationCompat.CarExtender.UnreadConversation.Builder unreadConvBuilder =
                new NotificationCompat.CarExtender.UnreadConversation.Builder("Roadrunner")
                        .setReadPendingIntent(msgHeardPendingIntent)
                        .setReplyAction(msgReplyPendingIntent, remoteInput);
        long unixTime = System.currentTimeMillis() / 1000L;
        unreadConvBuilder.addMessage(message.toString())
                .setLatestTimestamp(unixTime);

        NotificationCompat.Builder notificationBuilder =
                new NotificationCompat.Builder(context);

        notificationBuilder.extend(new NotificationCompat.CarExtender()
                .setUnreadConversation(unreadConvBuilder.build()));

        NotificationManagerCompat msgNotificationManager =
                NotificationManagerCompat.from(context);
        msgNotificationManager.notify("Roadrunner",
                1, notificationBuilder.build());
        //RichNotificationManger.processNotifExtras(context, msgExtras);

    }

    @Override
    public void onRegistered(Context context) {
        Log.i(TAG, "-- SDK registerd");
        Log.i(TAG, "XID is: " + XtifySDK.getXidKey(context));
        Log.i(TAG, "GCM registrationId is: " + XtifySDK.getRegistrationId(context));
    }

    @Override
    public void onC2dmError(Context context, String errorId) {
        Log.i(TAG, "ErrorId: " + errorId);
    }
}

