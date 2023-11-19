#!/bin/bash

URL="$1"
echo $URL

#Register test user
echo "-------------> Registering new user ..."
curl -v --request POST \
  --url $URL/auth/register \
  --header 'Content-Type: application/json' \
  --data '{
 "email": "test@email.com",
 "password": "strongpassword"
}'
echo ""

#Login test user
echo "-------------> Loggin in ..."
AUTH=$(curl --request POST \
  --url $URL/auth/login \
  --header 'Content-Type: application/json' \
  --data '{
 "email": "test@email.com",
 "password": "strongpassword"
}')

#Get authorization token
echo "-------------> Getting authorization token ..."
TOKEN=`jq '.token' <<< $AUTH`
TOKEN=${TOKEN:1:-1}
echo $TOKEN
echo ""

#Create a product
echo "-------------> Creating a new product ..."
PRODUCT=$(curl --request POST \
  --url $URL/product \
  --header "Authorization: Bearer $TOKEN" \
  --header 'Content-Type: application/json' \
  --data '{
 "name": "Product A",
 "stock": 5,
 "price": 15
}')
echo""

# Get product ID
echo "-------------> Getting the product ID..."
ID=`jq '.id' <<< $PRODUCT`
echo $ID
echo ""

#Get product by ID
echo "-------------> Getting the newly created product by ID..."
curl --request GET \
  --url "$URL/product/$ID" \
  --header "Authorization: Bearer $TOKEN"
echo ""

#Create order
echo "-------------> Creating an order ..."
curl --request POST \
  --url $URL/order \
  --header "Authorization: Bearer $TOKEN" \
  --header 'Content-Type: application/json' \
  --data '{
 "productId": 1,
 "quantity": 1
}'
