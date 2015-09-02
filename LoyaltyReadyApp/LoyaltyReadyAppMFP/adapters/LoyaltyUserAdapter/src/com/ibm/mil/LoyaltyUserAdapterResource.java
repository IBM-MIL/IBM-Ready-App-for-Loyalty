/* 
 * Licensed Materials - Property of IBM © Copyright IBM Corporation 2015. All
 * Rights Reserved. This sample program is provided AS IS and may be used,
 * executed, copied and modified without royalty payment by customer (a) for its
 * own instruction and study, (b) in order to develop applications designed to
 * run with an IBM product, either for customer's own internal use or for
 * redistribution by customer, as part of such an application, in customer's own
 * products.
 */

package com.ibm.mil;

import java.io.UnsupportedEncodingException;
import java.util.logging.Logger;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.apache.commons.codec.binary.Base64;
import org.apache.http.HttpHost;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

import com.ibm.mil.utils.JsonReader;
import com.ibm.mil.utils.Messages;

/**
 * Java adapter implementation that exposes REST urls that will retrieve Watson
 * personality insights based on a user and also retrieve the user from the
 * "back end store".
 */
@Path("/")
public class LoyaltyUserAdapterResource {
	/*
	 * For more info on JAX-RS see
	 * https://jsr311.java.net/nonav/releases/1.1/index.html
	 */
	private static CloseableHttpClient client;
	private static HttpHost host;
	private PropertiesReader propsReader = PropertiesReader.getInstance();
	// Define logger (Standard java.util.Logger)
	static Logger logger = Logger.getLogger(LoyaltyUserAdapterResource.class
			.getName());
	private Messages messages = Messages.getInstance();

	// Define the server api to be able to perform server operations
	// WLServerAPI api = WLServerAPIProvider.getWLServerAPI();

	/*
	 * Path for method:
	 * "<server address>/LoyaltyReadyApp/adapters/LoyaltyUserAdapter/user-data/{phone-number}/{locale}"
	 */
	/**
	 * Method to retrieve user account (as JSON string) from "back end" store.
	 * Usually this method would talk to your back end database or other data
	 * store, but for simplicities sake we are just keeping our single user in a
	 * JSON file embedded within the adapter itself.
	 * 
	 * @param phoneNumber
	 *            The phone number of the user whose account we want to
	 *            retrieve.
	 * @param locale
	 *            The locale of the users device.
	 * @return ServerResopnse with the user embedded, or a ServerResponse with
	 *         the error message encountered while trying to retrieved the
	 *         specified user.
	 */
	@GET
	@Path("/user-data/{phone_number}/{locale}")
	@Produces(MediaType.APPLICATION_JSON)
	public Response getUserData(@PathParam("phone_number") String phoneNumber,
			@PathParam("locale") String locale) {
		logger.info("debug - phone: " + phoneNumber + ", locale: " + locale);
		// String user = null;
		Response response;
		if (phoneNumber == null) {
			response = Response.serverError()
					.entity(messages.getMessage("MSG0001", locale)).build();
		} else if (locale == null) {
			response = Response.serverError()
					.entity(messages.getMessage("MSG0002", locale)).build();
		} else {
			String userJson = new JsonReader()
					.loadJsonFile(phoneNumber, locale);

			if (userJson == null) {
				response = Response.serverError()
						.entity(messages.getMessage("MSG0003", locale)).build();
			} else {
				response = Response.ok(userJson, MediaType.APPLICATION_JSON)
						.build();
			}
		}

		return response;
	}
	
	/*
	 * Path for method:
	 * "<server address>/LoyaltyReadyApp/adapters/LoyaltyUserAdapter/app-data/{locale}"
	 */
	/**
	 * Method to retrieve generic app data from "back end" store.
	 * Usually this method would talk to your back end database or other data
	 * store, but for simplicities sake we are just keeping our single user in a
	 * JSON file embedded within the adapter itself.
	 * 
	 * 
	 * @param locale
	 *            The locale of the users device.
	 * @return ServerResopnse with the app data embedded, or a ServerResponse with
	 *         the error message encountered while trying to retrieved the
	 *         specified user.
	 */
	@GET
	@Path("/app-data/{locale}")
	@Produces(MediaType.APPLICATION_JSON)
	public Response getAppData(@PathParam("locale") String locale) {
		logger.info("debug - app data call - " + locale);
		// String user = null;
		Response response;
		
			String userJson = new JsonReader()
					.loadDefaultJsonFile(locale);

			if (userJson == null) {
				response = Response.serverError()
						.entity(messages.getMessage("MSG0003", locale)).build();
			} else {
				response = Response.ok(userJson, MediaType.APPLICATION_JSON)
						.build();
			}
		

		return response;
	}

	/*
	 * Path for method:
	 * "<server address>/LoyaltyReadyApp/adapters/LoyaltyUserAdapter/users"
	 */
	/**
	 * Retrieve the Watson personality insights for a user. You would normally
	 * take a users Twitter feed and supply it to the Watson personality
	 * insights service and leverage the results to make informed decisions
	 * about what types of offers to make to the user based on their
	 * personality.
	 * 
	 * For this simple application we are hard coding the "Twitter feed" that we
	 * are suppling the Watson service and are NOT using the results to generate
	 * the custom offers we provide for the user as this logic would be very
	 * specific to the industry the application is rolled into and the specific
	 * business owners needs.
	 * 
	 * @return The Watson personality insights response as a JSON string.
	 */
	@GET
	@Path("/watson-data")
	@Produces(MediaType.APPLICATION_JSON)
	public Response getUserWatsonData() {
		// log message to server log
		logger.info(messages.getMessage("MSG0006"));

		Response srvrResponse;
		try {
			HttpPost httpPost = getHttpPost();
			String result = execute(httpPost);

			srvrResponse = Response.ok(result, MediaType.APPLICATION_JSON)
					.build();

		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			srvrResponse = Response
					.serverError()
					.entity(messages.getMessage("MSG0005")
							+ System.getProperty("line.separator")
							+ e.getLocalizedMessage()).build();
		} catch (Exception ex) {
			ex.printStackTrace();
			srvrResponse = Response.serverError()
					.entity(ex.getLocalizedMessage()).build();
		}
		return srvrResponse;
	}

	/**
	 * Helper method to generate an HttpPost object which we can then use to
	 * query the Watson personality insights service.
	 * 
	 * @return An HttpPost object which can be used to query the Watson
	 *         personality insights service.
	 * @throws UnsupportedEncodingException
	 */
	private HttpPost getHttpPost() throws UnsupportedEncodingException {
		String watsonPath = propsReader.getStringProperty("WATSON_PATH");
		HttpPost httpPost = new HttpPost(watsonPath);
		try {
			String watsonString = propsReader
					.getStringProperty("WATSON_STRING");
			httpPost.setEntity(new StringEntity(watsonString));
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		httpPost.setHeader("Accept", MediaType.APPLICATION_JSON);
		httpPost.setHeader("Content-type", "text/plain; charset=UTF-8");
		String username = propsReader.getStringProperty("WATSON_USERNAME");
		String password = propsReader.getStringProperty("WATSON_PASSWORD");
		String creds = username + ":" + password;
		String encoding = Base64.encodeBase64String(creds.getBytes("UTF-8"));
		httpPost.setHeader("Authorization", "Basic " + encoding);

		return httpPost;
	}

	/**
	 * Helper method to call out to the Watson Service to retrieve the
	 * personality insights for the given user characteristics.
	 * 
	 * @param req
	 *            The request we will be submitting to Watson that contains the
	 *            user characteristics.
	 * @return String representing the reply from the Watson service.
	 * @throws Exception
	 *             General exception thrown whenever the Watson service returns
	 *             an unsuccessful response.
	 */
	private String execute(HttpUriRequest req) throws Exception {
		client = HttpClients.createDefault();
		String watsonHost = propsReader.getStringProperty("WATSON_HOST");
		host = new HttpHost(watsonHost, 443, "https");

		HttpResponse JSONResponse = client.execute(host, req);
		String message = EntityUtils.toString(JSONResponse.getEntity());

		if (JSONResponse.getStatusLine().getStatusCode() != HttpStatus.SC_OK) {
			throw new Exception(message);
		}
		return message;
	}
}
