package com.ibm.mil.loyalty.utils;

import java.util.ArrayList;

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

public class FragmentHistory {


    private ArrayList<Integer> stackArr;

    /**
     * constructor to create stack with size
     *
     * @param
     */
    public FragmentHistory() {
        stackArr = new ArrayList<>();


    }

    /**
     * This method adds new entry to the top
     * of the stack
     *
     * @param entry
     * @throws Exception
     */
    public void push(int entry) {

        if (isAlreadyExists(entry)) {
            return;
        }
        stackArr.add(entry);

    }

    private boolean isAlreadyExists(int entry) {
        return (stackArr.contains(entry));
    }

    /**
     * This method removes an entry from the
     * top of the stack.
     *
     * @return
     * @throws Exception
     */
    public int pop() {

        int entry = -1;
        if(!isEmpty()){

            entry = stackArr.get(stackArr.size() - 1);

            stackArr.remove(stackArr.size() - 1);
        }
        return entry;
    }


    /**
     * This method removes an entry from the
     * top of the stack.
     *
     * @return
     * @throws Exception
     */
    public int popPrevious() {

        int entry = -1;

        if(!isEmpty()){
            entry = stackArr.get(stackArr.size() - 2);
            stackArr.remove(stackArr.size() - 2);
        }
        return entry;
    }



    /**
     * This method returns top of the stack
     * without removing it.
     *
     * @return
     */
    public int peek() {
        if(!isEmpty()){
            return stackArr.get(stackArr.size() - 1);
        }

        return -1;
    }



    public boolean isEmpty(){
        return (stackArr.size() == 0);
    }


    public int getStackSize(){
        return stackArr.size();
    }

    public void emptyStack() {

        stackArr.clear();
    }
}
