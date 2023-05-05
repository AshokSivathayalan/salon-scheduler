#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c "

SHOW_SERVICES() {
  SERVICES=$($PSQL "SELECT service_id, name FROM services;")
  echo "$SERVICES" | while read SERVICE_ID PIPE NAME
  do
    echo $SERVICE_ID\) $NAME
  done
}

APPOINTMENT_INFO() {
  #get customer info
  echo -e "\nPlease select a service ID:"
  read SERVICE_ID_SELECTED
  #checking that the choice was a number
  if [[ ! $SERVICE_ID_SELECTED  =~ ^[0-9]+$ ]]
  then
    echo -e "\nSelection must be a number."
    SHOW_SERVICES
    APPOINTMENT_INFO
  else
    #checking that the service exists
    SERVICE_EXISTS=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED;")
    if [[ -z $SERVICE_EXISTS ]]
    then
      echo -e "\nService does not exist."
      SHOW_SERVICES
      APPOINTMENT_INFO
    #Getting other info if service choice was valid
    else
      echo -e "\nPlease enter your phone number:"
      read CUSTOMER_PHONE
      #get customer id
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")
      #if user not found
      if [[ -z $CUSTOMER_ID ]]
      then
        #ask for name
        echo -e "\nPlease enter your name:"
        read CUSTOMER_NAME
        #add user to database
        INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE');")
        CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")
      fi
      #get desired appointment time
      echo -e "\nPlease enter your appointment time"
      read SERVICE_TIME
    fi
  fi
}

ADD_APPOINTMENT() {
  #adding the appointment to the database
  ADD_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")
  #outputting success message
  echo -e "\nI have put you down for a $($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;" | sed -E 's/^ *| *$//') at $SERVICE_TIME, $($PSQL "SELECT name FROM customers WHERE customer_id = $CUSTOMER_ID;" | sed -E 's/^ *| *$//')."
}

SHOW_SERVICES
APPOINTMENT_INFO
ADD_APPOINTMENT