#!/bin/bash

# parse command line arguments
for i in "$@"
do
case $i in
    -d=*|--deployment=*)
    DEPLOY="${i#*=}"
    shift # past argument=value
    ;;
    -p=*|--profile=*)
    PROFILE="${i#*=}"
    shift # past argument=value
    ;;
    *)
            # unknown option
    ;;
esac
done

echo "Deployment starts, $DEPLOY version"
echo "-----------------\n"

# load the correct key file
if [ $DEPLOY = 'prod' ]
then
  KEY_FILE=prod_keys.txt
  echo "Key file to deploy: $KEY_FILE"
else
  KEY_FILE=dev_keys.txt
  echo "Key file to deploy: $KEY_FILE"
fi

#get all the values from the key-value pairs
values=$(cat $KEY_FILE | grep "^${KEY}${DELIMITER}" | cut -f2 -d ":")
#get the number of values
len=$(wc -w  <<< "$values")

#initialise a counter variable
INDEX=1

# reset the previous deployed django.config
ORIG_FILE_NAME=django.bak
FILE_NAME=.ebextensions/django.config
cp $ORIG_FILE_NAME $FILE_NAME
echo "Reset config file"
echo "Setting key-value pairs in $FILE_NAME"

#loop over the values and give the values to the keys
for value in $values 
  do  
    echo "value$INDEX << $value"
    sed -i -e "s/value$INDEX/$value/g" $FILE_NAME
    ((INDEX++))
  done


# add the modified file to gitignore if not present
IGNORE=$(cat .gitignore | grep $FILE_NAME)
if [ -z "$IGNORE" ]
then
  echo $FILE_NAME >> .gitignore
  echo "$FILE_NAME added to .gitignore"
else
  echo "File already in .gitignore"
fi

IGNORE=$(cat .gitignore | grep $KEY_FILE)
if [ -z "$IGNORE" ]
then
echo $KEY_FILE >> .gitignore
echo "$KEY_FILE added to .gitignore"
else
echo "File already in .gitignore"
fi

#call the EB CLI to deploy the app
# obs: specify the environment where to deploy
echo "$DEPLOY version ready to deploy on EB as profile $PROFILE"
echo "-----------------\n"
eb deploy --profile $PROFILE
