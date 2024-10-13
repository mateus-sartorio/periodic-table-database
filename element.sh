#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"



if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    WHERE_QUERY="atomic_number = $1"
  elif [[ ${#1} -le 2 ]]
  then
    WHERE_QUERY="symbol = '$1'"
  else
    WHERE_QUERY="name = '$1'"
  fi

  QUERY_RESULT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE $WHERE_QUERY")

  if [[ -z $QUERY_RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    echo $QUERY_RESULT | while read ATOMIC_NUMBER PIPE NAME PIPE SYMBOL PIPE TYPE PIPE ATOMIC_MASS PIPE MELTING_POINT PIPE BOILING_POINT
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi