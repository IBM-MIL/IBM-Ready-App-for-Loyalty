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


import com.ibm.mfp.security.checks.base.UserAuthenticationSecurityCheck;
import com.ibm.mfp.server.registration.external.model.AuthenticatedUser;
import com.ibm.mfp.server.registration.external.model.PersistentAttributes;
import com.ibm.mfp.server.security.external.checks.AuthorizationResponse;
import com.ibm.mfp.server.security.external.checks.SecurityCheckConfiguration;







import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.util.logging.Logger;


import org.json.JSONObject;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLSocketFactory;



public class UserLogin extends UserAuthenticationSecurityCheck {
    private String userId, displayName;
    private String errorMsg;
    private boolean rememberMe = false;
    
    
    static Logger logger = Logger.getLogger(UserLogin.class.getName());
    
	
	@Override
	public SecurityCheckConfiguration createConfiguration(Properties properties) {
		return new UserLoginSecurityCheckConfiguration(properties);
	}

    @Override
    protected AuthenticatedUser createUser() {
        return new AuthenticatedUser(userId, displayName, this.getName());
    }

    @Override
    protected boolean validateCredentials(Map<String, Object> credentials) {
    	
    	System.out.println("inside validatecredentials");
    	
        if(credentials!=null && credentials.containsKey("username") && credentials.containsKey("password")){
            String username = credentials.get("username").toString();
            String password = credentials.get("password").toString();
            
            //new code
            
            System.out.println("username" + username);
            System.out.println("password" + password);
            
            
            if(!username.isEmpty() && !password.isEmpty())
            {
            	HttpsURLConnection connection = null;
            //	SSLSocketFactory sslSocketFactory = null;

        		try {
        			
        			URL url = new URL(UserLoginSecurityCheckConfiguration.apic_url);
        			        			
        			connection = (HttpsURLConnection) url.openConnection();
        			
					//connection.setSSLSocketFactory(sslSocketFactory);
        			connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");    			
        			connection.setRequestMethod("POST");
        			
        			String requestBody = "client_id="+UserLoginSecurityCheckConfiguration.apic_clientid+ "&client_secret=" + UserLoginSecurityCheckConfiguration.apic_clientsecret + "&grant_type=password&scope=apicscope&username=" + username + "&password=" + password;
        			
                    connection.setDoInput(true);
                    connection.setDoOutput(true);
                    connection.setUseCaches(false);
         
                    
                    OutputStream outputStream = connection.getOutputStream();
                    outputStream.write(requestBody.getBytes("UTF-8"));
                    outputStream.close();
                    
                    System.out.println("before connect");
        			connection.connect();
   			
        			int status = connection.getResponseCode();
        			
        			System.out.println("statuscode" + status);
					
					if (status == 200 || status == 201)
					{
						userId = username;
						displayName = username;
						
						
							BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
        	                StringBuilder sb = new StringBuilder();
        	                String line;
        	                while ((line = bufferedReader.readLine()) != null) {
        	                    sb.append(line + "\n");
        	                }
        	                bufferedReader.close();
        	                
        	                String content = sb.toString();
        	                String apic_token = null, refresh_token=null;
        	                
							System.out.println(content);
        	                if (content != null) {
                				JSONObject response = new JSONObject(content); 
                				 apic_token = (String) response.get("access_token"); 
                				 refresh_token=(String) response.get("refresh_token"); 
                				System.out.println("APIC token: "+ apic_token);
                				
                			}
        	                //add the APIC token and other values to the Persistent attributes
        	                
        	                PersistentAttributes attributes = registrationContext.getRegisteredPublicAttributes();


        	                attributes.put("apic_user_pwd_token",apic_token);  
        	              
        	                
        	                System.out.println("-----------After put-------------");
        	                System.out.println(attributes.get("apic_user_pwd_token"));         	              
        	                System.out.println("-----------End -------------");
						
												
						return true;
						}
					else
						return false;	
					} catch (Exception e) {        			
        			logger.info("exception"+e.toString());
        		} finally {
        			if (connection != null) {
        				connection.disconnect();
        			}
        		}
            	
            }
            
            
            
          /*  if(!username.isEmpty() && !password.isEmpty() && username.equals(password)) {
                userId = username;
                displayName = username;

                //Optional RememberMe
                if(credentials.containsKey("rememberMe") ){
                    rememberMe = Boolean.valueOf(credentials.get("rememberMe").toString());
                }
                errorMsg = null;
                return true;
            }*/
            else {
                errorMsg = "Wrong Credentials";
            }
        }
        else{
            errorMsg = "Credentials not set properly";
        }
        return false;
    }

    @Override
    protected Map<String, Object> createChallenge() {
        Map challenge = new HashMap();
        challenge.put("errorMsg",errorMsg);
        challenge.put("remainingAttempts",getRemainingAttempts());
        return challenge;
    }

    @Override
    protected boolean rememberCreatedUser() {
        return rememberMe;
    }
}
