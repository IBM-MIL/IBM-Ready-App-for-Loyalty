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

import java.util.logging.Logger;
import com.worklight.wink.extensions.MFPJAXRSApplication;

public class LoyaltyUserAdapterApplication extends MFPJAXRSApplication{

	static Logger logger = Logger.getLogger(LoyaltyUserAdapterApplication.class.getName());
	/**
     * Initializes the MFP Adapter
     * @throws Exception
     */
	@Override
	protected void init() throws Exception {
		logger.info("Adapter initialized!");
	}
    /**
     * Destroys the MFP Adapter
     * @throws Exception
     */
	@Override
	protected void destroy() throws Exception {
		logger.info("Adapter destroyed!");
	}
    /**
     * Finds the JAX_RS resources to use for this MFP Adapter
     */
    @Override
	protected String getPackageToScan() {
		//The package of this class will be scanned (recursively) to find JAX-RS resources. 
		//It is also possible to override "getPackagesToScan" method in order to return more than one package for scanning
		return getClass().getPackage().getName();
	}
}
