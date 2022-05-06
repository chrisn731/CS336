package com.dbapp;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;


class ListingCloser extends Thread {
	private static final long TIMEOUT_SECONDS = 1;
	Connection c;
	
	public ListingCloser(Connection c) {
		this.c = c;
	}
	
	public void run() {
		while (true) {
			try {
				java.sql.PreparedStatement ps = c.prepareStatement(
					"SELECT l_id, dt, price, minsale FROM listings WHERE closed=0"
				);
				ResultSet rs = ps.executeQuery();
				
				while (rs.next()) {
					String lid = rs.getString(1);
					String price = rs.getString(3);
					String minsale = rs.getString(4);
					Timestamp close_time = rs.getTimestamp(2);
					Timestamp curr_time = new Timestamp(System.currentTimeMillis());
					
					Double p = Double.parseDouble(price);
					p = Math.round(p * 100.0)/100.0;
					Double m = Double.parseDouble(minsale);
					m = Math.round(m * 100.0)/100.0;
					
					if (close_time.before(curr_time) || close_time.equals(curr_time)) {
						ps = c.prepareStatement(
								"UPDATE listings SET closed=1 WHERE l_id=(?)"
						);
						ps.setString(1, lid);
						ps.executeUpdate();
						
						if(p>=m) {
							//add to sales table
							ps = c.prepareStatement(
									"INSERT INTO sales(dtime, amount) " 
											+ "VALUES(?, ?)");
							ps.setTimestamp(1, curr_time);
							ps.setString(2, price);
							ps.executeUpdate();
							
							//add to generates table
							ps = c.prepareStatement(
									"INSERT INTO generates(s_id, l_id) " 
											+ "VALUES((SELECT MAX(s_id) FROM sales), ?)");
							ps.setString(1, lid);
							ps.executeUpdate();
						}
					}
				}
				Thread.sleep(TIMEOUT_SECONDS * 1000);
			} catch (SQLException | InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
}