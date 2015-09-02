/* 
 * Licensed Materials - Property of IBM © Copyright IBM Corporation 2015. All
 * Rights Reserved. This sample program is provided AS IS and may be used,
 * executed, copied and modified without royalty payment by customer (a) for its
 * own instruction and study, (b) in order to develop applications designed to
 * run with an IBM product, either for customer's own internal use or for
 * redistribution by customer, as part of such an application, in customer's own
 * products.
 */

package com.ibm.mil.utils;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.nio.charset.Charset;
import java.util.logging.Logger;

import com.google.gson.JsonParser;

/**
 * Class used to load the users JSON data from the "back end", which in our case is nothing more than an embedded
 * JSON file.
 */
public class JsonReader {
	public static final String BASE_JSON_PATH = "resources/json_data/";
	public static final String JSON_FILE_EXTENSION = ".json";
	public static final String DEFAULT_LOCALE = "en";
	private Messages messages = Messages.getInstance();
	public static final Charset DEFAULT_ENCODING = Charset.forName("UTF-8");
	
	static Logger logger = Logger.getLogger(JsonReader.class.getName());
	
	/**
	 * Method to retrieve the JSON data for the user with the specified phone number and the specified locale. If
	 * the requested locale is not available, but the user does exist, then the default JSON data is returned
	 * for the user (which would be in English). 
	 * 
	 * @param phoneNumber The phone number associated with the user being requested.
	 * @param locale The locale the client is requesting back from the server.
	 * @return The user data in the given locale (if available), or in English if the requested locale is not available.
	 * The method will return null if the requested user is not found.
	 */
	public String loadJsonFile(String phoneNumber, String locale) {
		String user = null;
		URL path = null;
    	String userDir = BASE_JSON_PATH + phoneNumber;
		String jsonDataFile = userDir + "/" + locale + JSON_FILE_EXTENSION;
		String jsonDefaultDataFile = userDir + "/" + DEFAULT_LOCALE + JSON_FILE_EXTENSION;
		
        try {
        	path = getClass().getClassLoader().getResource(userDir);
		} catch (Exception e) {
			logger.severe(messages.getMessage("MSG0004", locale, BASE_JSON_PATH) );
			logger.severe(e.getMessage());
		}
        
        if (path != null) {
        	user = loadJsonResource(jsonDataFile, locale);
        	if (user == null && !DEFAULT_LOCALE.equals(locale)) {
        		user = loadJsonResource(jsonDefaultDataFile, DEFAULT_LOCALE);
        	}
        }
        
        return user;
	}
	
	/**
	 * Method to retrieve the JSON data for an anonymous user and the specified locale. If
	 * the requested locale is not available, then the default JSON data is returned
	 * for the user (which would be in English). 
	 * 
	 * 
	 * @param locale The locale the client is requesting back from the server.
	 * @return The anonymous user data in the given locale (if available), or in English if the requested locale is not available.
	 * The method will return null if the requested data is not found.
	 */
	public String loadDefaultJsonFile(String locale) {
		String appData = null;
		URL path = null;
		String userDir = BASE_JSON_PATH;
		String jsonDataFile = userDir + "/app-data-" + locale + JSON_FILE_EXTENSION;
		String jsonDefaultDataFile = userDir + "/app-data-" + DEFAULT_LOCALE + JSON_FILE_EXTENSION;
		
		try {
        	path = getClass().getClassLoader().getResource(userDir);
		} catch (Exception e) {
			logger.severe(messages.getMessage("MSG0004", locale, BASE_JSON_PATH) );
			logger.severe(e.getMessage());
		}
        
        if (path != null) {
        	appData = loadJsonResource(jsonDataFile, locale);
        	if (appData == null && !DEFAULT_LOCALE.equals(locale)) {
        		appData = loadJsonResource(jsonDefaultDataFile, DEFAULT_LOCALE);
        	}
        }
        
		return appData;
	}
	
	/**
	 * Helper method which will load a JSON file with the associated locale.
	 * 
	 * @param resource The path to the JSON file that is requested to be loaded.
	 * @param locale The locale for the JSON file to be loaded.
	 * @return The contents of the JSON file that is loaded, or null if the JSON file cannot be loaded.
	 */
	private String loadJsonResource(String resource, String locale) {
		String contents = null;
		try {
        	if (resource != null) {
        		InputStream inStream = getClass().getClassLoader().getResourceAsStream(resource);
        		InputStreamReader reader = new InputStreamReader(inStream , DEFAULT_ENCODING);
            	contents = new JsonParser().parse(reader).toString();
        	}
		} catch (Exception e) {
			logger.severe(messages.getMessage("MSG0004", locale, resource) );
			logger.severe(e.getMessage());
		}
		return contents;
	}
}
