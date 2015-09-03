package com.ibm.mil.loyalty.tests;

import java.util.Map;







import javax.ws.rs.core.Response;

import org.junit.Assert;
import org.junit.Test;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.ibm.mil.LoyaltyUserAdapterResource;

public class TestUserAdapter {
	/**
	 * Test that we can actually load the only known user JSON file correctly.
	 */
	@Test
	public void testLoadJsonFile() {
		LoyaltyUserAdapterResource adapter = new LoyaltyUserAdapterResource();
		Response response = adapter.getUserData("5128675309", "en");
		//boolean success = (Boolean) response.get("isSuccessful");
		Assert.assertEquals(200, response.getStatus());
		Map<Object, Object> map = null;
		try {
			map = new Gson().fromJson((String) response.getEntity(), new TypeToken<Map<Object, Object>>() {}.getType());
		}catch (Exception ex) {
			Assert.assertTrue("Should not have run into an exception converting the string user to a map.", false);
		}
		Assert.assertNotNull("Should not have parsed a null object.", map);
		int id = ( (Double)map.get("id")).intValue();
		Assert.assertEquals("id was not found or incorrect", 1000, id);
		
	}
	/**
	 * Test that when we supply an invalid phone number, we get an appropriate failure message back from the server.
	 */
	@Test
	public void testFailLoadJsonFile() {
		LoyaltyUserAdapterResource adapter = new LoyaltyUserAdapterResource();
		//Basically just providing wrong phone number.
		Response response = adapter.getUserData("512", "en");
		Assert.assertEquals(500, response.getStatus());
		Assert.assertTrue( ((String) response.getEntity()).contains("MSG0003 User not found"));
		
	}
	
	/**
	 * Test that if the client passes in the correct users phone number but passes in a client locale for which
	 * we don't have a JSON file on the back end (we only have English), that the server correctly returns the
	 * user data for the locale that we actually do have, which is English.
	 */
	
	@Test
	public void testLoadDefaultLocaleJsonFile() {
		LoyaltyUserAdapterResource adapter = new LoyaltyUserAdapterResource();
		//Basically just providing wrong phone number.
		Response response = adapter.getUserData("5128675309", "fr");
		Assert.assertEquals(200, response.getStatus());
		Map<Object, Object> map = null;
		try {
			map = new Gson().fromJson((String) response.getEntity(), new TypeToken<Map<Object, Object>>() {}.getType());
		}catch (Exception ex) {
			Assert.assertTrue("Should not have run into an exception converting the string user to a map.", false);
		}
		Assert.assertNotNull("Should not have parsed a null object.", map);
		int id = ( (Double)map.get("id")).intValue();
		Assert.assertEquals("id was not found or incorrect", 1000, id);
	}
	
	/**
	 * Test that when we call the adapter function to get Watson data base, we do actually get a response back
	 * from the watson service.
	 */
	
	@Test
	public void testWatsonData() {
		LoyaltyUserAdapterResource adapter = new LoyaltyUserAdapterResource();
		Response response = adapter.getUserWatsonData();
		Assert.assertEquals(200, response.getStatus());
		Map<Object, Object> map = null;
		try {
			map = new Gson().fromJson((String) response.getEntity(), new TypeToken<Map<Object, Object>>() {}.getType());
		}catch (Exception ex) {
			Assert.assertTrue("Should not have run into an exception converting the string user to a map.", false);
		}
		Assert.assertNotNull("Should not have parsed a null object.", map);
		
	}
	
}
