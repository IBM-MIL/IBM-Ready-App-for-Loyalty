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

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import java.util.logging.Logger;

/**
 * Class used to read application specific properties which can be tuned at application packaging time. This
 * class is a singleton which represents the single application properties file we will load.
 */
public final class PropertiesReader {

	public static final Object CREATE_LOCK = new Object();
	// Logger
	private final static Logger LOGGER = Logger
			.getLogger(PropertiesReader.class.getName());

	// Singleton instance
	private static PropertiesReader singleton;

	// Instance variables
	private Properties properties;
	private static final String fileName = "resources/loyalty.properties";

	/**
	 * Private constructor.
	 */
	private PropertiesReader() {
		try {
			properties = new Properties();
			InputStream inStream = getClass().getClassLoader()
					.getResourceAsStream(fileName);
			properties.load(inStream);
		} catch (IOException e) {
			LOGGER.severe("Could not load properties file: " + fileName);
			LOGGER.severe(e.getMessage());
		}
	}

	/**
	 * Accessor method for the only class instance availble.
	 * @return The instance of this class in memory.
	 */
	public static PropertiesReader getInstance() {
		synchronized(CREATE_LOCK) {
			if (singleton == null) {
				singleton = new PropertiesReader();
			}
		}
		
		return singleton;
	}

	/**
	 * Retrieve a property from the application properties file.
	 * 
	 * @param property The name of the property to be retrieved.
	 * @return If the specified property exists, the properties value as a string.. 
	 * If the property does not exist, then null is returned.
	 */
	public String getStringProperty(String property) {
		return properties.getProperty(property);
	}

	/**
	 * Method to retrieve a property from the application properties file, and retrieve its value as an integer.
	 * Note this method may throw a runtime exception if the property is either not found, or its value does not
	 * represent an integer.
	 * 
	 * @param property The name of the property to be retrieved.
	 * @return The integer representation of the properties value.
	 */
	public int getIntProperty(String property) {
		return Integer.parseInt(properties.getProperty(property));
	}
}
