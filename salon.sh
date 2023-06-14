#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

echo -e "\n~~ MY SALON ~~\n"

MAIN_MENU() {
    if [[ $1 ]]; then
        echo -e "\n$1"
    fi
    echo -e "Welcome to My Salon, how can I help you?\n"
    echo "1) cut"
    echo "2) color"
    echo "3) style"
    read SERVICE_ID_SELECTED

    case $SERVICE_ID_SELECTED in
    1) SERVICE "1" "cut" ;;
    2) SERVICE "2" "color" ;;
    3) SERVICE "3" "style" ;;
    *) MAIN_MENU "I could not find that service. What would you like today?" ;;
    esac
}

SERVICE() {
    echo "What's your phone number?"
    read CUSTOMER_PHONE
    CUSTOMER_NAME="$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")"
    if [[ -z $CUSTOMER_NAME ]]; then
        echo "I don't have a record for that phone number, what's your name?"
        read CUSTOMER_NAME
        INSERT_CUSTOMER_RESULT="$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")"
    fi
    echo "What time would you like your $2, $CUSTOMER_NAME?"
    read SERVICE_TIME
    CUSTOMER_ID="$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME'")"
    INSERT_APPOINTMENT_RESULT="$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $1, '$SERVICE_TIME')")"
    echo "I have put you down for a $2 at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU
