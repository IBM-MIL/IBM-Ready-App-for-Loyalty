package com.ibm.mil.loyalty.activities;


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

public class Constants {
    static final String ACTION_LOGIN = "com.ibm.mil.loyalty.broadcast.login";
    static final String ACTION_LOGIN_SUCCESS = "com.ibm.mil.loyalty.broadcast.login.success";
    static final String ACTION_LOGIN_FAILURE = "com.ibm.mil.loyalty.broadcast.login.failure";
    static final String ACTION_LOGIN_REQUIRED = "com.ibm.mil.loyalty.broadcast.login.required";

    static final String ACTION_LOGOUT = "com.ibm.mil.loyalty.broadcast.logout";
    static final String ACTION_LOGOUT_SUCCESS = "com.ibm.mil.loyalty.broadcast.logout.success";
    static final String ACTION_LOGOUT_FAILURE = "com.ibm.mil.loyalty.broadcast.logout.failure";

    static final String PREFERENCES_FILE = "com.ibm.mil.loyalty.preferences";
    static final String PREFERENCES_KEY_USER = "com.ibm.mil.loyalty.preferences.user";
}

