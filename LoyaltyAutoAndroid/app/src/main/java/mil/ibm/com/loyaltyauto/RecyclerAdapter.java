package mil.ibm.com.loyaltyauto;

import android.support.v7.widget.CardView;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

import mil.ibm.com.loyaltyauto.models.Deal;

/**
 * Created by evancompton on 6/24/15.
 */
public class RecyclerAdapter extends RecyclerView.Adapter<RecyclerAdapter.DealViewHolder>{

    public static class DealViewHolder extends RecyclerView.ViewHolder {
        CardView cv;
        TextView dealName;
        TextView dealExp;
        ImageView dealPhoto;

        DealViewHolder(View itemView) {
            super(itemView);
            cv = (CardView)itemView.findViewById(R.id.card_deal);
            dealName = (TextView)itemView.findViewById(R.id.deal_name);
            dealExp = (TextView)itemView.findViewById(R.id.deal_exp);
            dealPhoto = (ImageView)itemView.findViewById(R.id.deal_photo);
        }
    }

    List<Deal> deals;

    RecyclerAdapter(List<Deal> deals){
        this.deals = deals;
    }

    @Override
    public int getItemCount() {
        return deals.size();
    }

    @Override
    public DealViewHolder onCreateViewHolder(ViewGroup viewGroup, int i) {
        View v = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.card_deal, viewGroup, false);
        DealViewHolder dvh = new DealViewHolder(v);
        return dvh;
    }

    @Override
    public void onBindViewHolder(DealViewHolder dealViewHolder, int i) {
        dealViewHolder.dealName.setText(deals.get(i).getName());
        DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DATE, deals.get(i).getExpiration());
        dealViewHolder.dealExp.setText("Expires " + dateFormat.format(cal.getTime()));
        if(deals.get(i).getImage_name().equals("fountainDrink")) {
            dealViewHolder.dealPhoto.setImageResource(R.drawable.deal1);
        } else if(deals.get(i).getImage_name().equals("freeOatmealBar")) {
            dealViewHolder.dealPhoto.setImageResource(R.drawable.deal3);
        } else if(deals.get(i).getImage_name().equals("pizza")) {
            dealViewHolder.dealPhoto.setImageResource(R.drawable.deal4);
        } else if(deals.get(i).getImage_name().equals("lunchMeal")) {
            dealViewHolder.dealPhoto.setImageResource(R.drawable.deal5);
        } else {
            dealViewHolder.dealPhoto.setImageResource(R.drawable.deal6);
        }


    }

    @Override
    public void onAttachedToRecyclerView(RecyclerView recyclerView) {
        super.onAttachedToRecyclerView(recyclerView);
    }

}
