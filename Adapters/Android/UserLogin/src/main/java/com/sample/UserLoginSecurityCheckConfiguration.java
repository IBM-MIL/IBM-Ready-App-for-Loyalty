/**
* Copyright 2016 IBM Corp.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
package com.sample;

import com.ibm.mfp.server.security.external.checks.SecurityCheckConfiguration;
import com.ibm.mfp.security.checks.base.UserAuthenticationSecurityCheckConfig;

import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

public class UserLoginSecurityCheckConfiguration extends UserAuthenticationSecurityCheckConfig {

    public int rememberMeDurationSec;
    public static String apic_url ;
    public static String apic_clientid ;
    public static String apic_clientsecret ;

    public UserLoginSecurityCheckConfiguration(Properties properties) {
        super(properties);
        rememberMeDurationSec = getIntProperty("rememberMeDurationSec", properties, 0);
		apic_url = getStringProperty("apic_url", properties, "https://api.eu.apiconnect.ibmcloud.com/dselvarainibmcom-sdp/sb/oauth-end/oauth2/token");
        apic_clientid = getStringProperty("apic_clientid", properties, "60d71c36-9d38-4735-9656-3ddcf15fe74c");
        apic_clientsecret = getStringProperty("apic_clientsecret", properties, "cI1xU6dW2aV3kW0vW7tQ4wT4sC1jG1oV3vK6cD7pV3iP4kS5cB");
        
    }

}
