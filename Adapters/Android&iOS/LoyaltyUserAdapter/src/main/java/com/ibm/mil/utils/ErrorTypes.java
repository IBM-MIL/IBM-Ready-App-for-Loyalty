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

/**
 * Enum to contain the error types we want to be able to send back to the client.
 *
 */
public enum ErrorTypes {
	INVALID_PHONE_NUMBER, INVALID_LOCALE, INVALID_USER, UNSUPPORTED_ENCODING, GENERAL_EXCEPTION;
	
	/**
	 * @Override
	 */
	public String toString() {
		switch(this) {
			case INVALID_LOCALE: return "invalid_locale";
			case INVALID_PHONE_NUMBER: return "invalid_phone_number";
			case INVALID_USER: return "invalid_user";
			case UNSUPPORTED_ENCODING: return "unsupported_encoding";
			default: return "general_exception";
		}
	}
}
