#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ My Salon ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  SERVICES=$($PSQL "SELECT name FROM services")

  echo "$SERVICES" | while read NAME
  do
    SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE name='$NAME'")
    echo "$SERVICE_ID) $NAME"
  done

  read SERVICE_ID_SELECTED

  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")


  while [[ -z $SERVICE_NAME ]]
  do
    echo "$SERVICES" | while read NAME
    do
      SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE name='$NAME'")
      echo "$SERVICE_ID) $NAME"
    done
    read SERVICE_ID_SELECTED
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
  done

  echo -e "\nWhat is you phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

  # if customer doesn't exist
  if [[ -z $CUSTOMER_NAME ]]
  then
    # get new customer name
    echo -e "\nWhat's your name?"
    read CUSTOMER_NAME

    # insert new customer
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 
  fi

  echo -e "\nWhat is the time of this service?"
  read SERVICE_TIME

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")

  echo "I have put you down for a $( echo $SERVICE_NAME | sed -E "s/^ *| *$//g" ) at $SERVICE_TIME, $( echo $CUSTOMER_NAME | sed -E "s/^ *| *$//g" )."
}

MAIN_MENU