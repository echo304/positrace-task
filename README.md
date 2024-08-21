# README

### Ruby version

* 3.1.2

### Rails version

* 7.1.2

### Prerequisites

- Docker

### Run the app in development mode with docker (Recommended)

- **Make sure you replace `{{YOUR_ACCESS_KEY}}` with your own ipstack access key in `docker-compose.yml` file**
- Run the following commands in the root directory of the project

```bash
docker-compose up
```

- You can now access the app at http://localhost:3000
- Code change on local machine will be reflected in the container automatically

### Database

- For the purpose of this test, I used postgresql as the database. And it will be running with docker. So if you run the
  app with docker, you don't need to setup any database.
- Make sure you don't have any process running on port 5432 in your local machine

#### Database initialization

- Run the following commands in the root directory of the project

```bash
rails db:setup
```

- You will have some sample data in the database
    - 5 Geolocations
    - 1 User with ApiKey
    - 1 User without ApiKey
- You can also run the following command to reset the database

```bash
rails db:reset
```

### Run the app in development mode without docker (Not recommended)

- Make sure you have proper Ruby version installed
- Run the following commands in the root directory of the project
- Make sure you have PostgreSQL running in your local machine with the following configurations
    - username: `positrace_task`
    - password: `positrace_task`
    - host: `localhost`
    - port: `5432`

```bash
bundle install
export GEOLOCATION_ACCESS_KEY={{YOUR_ACCESS_KEY}}
export GEOLOCATION_URL=http://api.ipstack.com/
bin/rails server
```

### Components

- **Geolocation**: It is the main component of this application. It is responsible for fetching geolocation data from
  `ipstack` API and storing it in the database
- **User**: It is the user model of the application. It is used for authentication purpose
- **ApiKeys**: It is the model to store the API keys for authentication purpose
- **ApiKeysController**: It is the controller to manage the API keys
- **ApiKeyAuthenticatable**: It is the module to authenticate the API keys
- **GeolocationsController**: It is the controller to manage the geolocation data
- **GeolocationClient**: It is the client to fetch geolocation data from external geolocation API
  - **GeolocationAdapters**: It is the adapter module contains adapters that parse the response from the external geolocation API

#### Why I didn't use PostGIS?
- TL;DR: PostGIS is an overkill for this application. It is a spatial database extender for PostgreSQL object-relational
  database. It adds support for geographic objects allowing location queries to be run in SQL. But for this application,
  we don't need to run any location queries in SQL. We are just fetching the geolocation data from `ipstack` API and
  storing it in the database. So, using PostGIS will be an overkill for this application

### Authentication

- The API is protected with API key authentication. You need to provide the API key in the request headers to access the
  API
- API authentication is implemented in `ApiKeysController`, `ApiKeyAuthenticatable` and `ApiKeys` model
- To secure the API key, it is stored in the database after hashing with `SHA256` algorithm

#### How to get the API key
- You can get the API key by calling the following endpoint with the credentials below
```bash
curl -v -X POST http://localhost:3000/api/v1/api_keys \
    -u test@test.com:password
```

- And you will get the API key from token field in the response similar to the following
```json
{"id":3,"bearer_id":1,"bearer_type":"User","created_at":"2024-08-21T21:50:41.575Z","updated_at":"2024-08-21T21:50:41.575Z","token":"e2d169758f921258a320595819d26c01"}%
```

- You can use this API key to access the API
```bash
curl -X GET --location "http://localhost:3000/api/v1/geolocations/1" \
    -H "Authorization: Bearer e2d169758f921258a320595819d26c01"
```

### API

- Make sure you have the authentication data in the request headers
- **For the brevity of this document, I will not include the authentication data in the request headers in the following
  examples**

#### Get multiple geolocation data

```http
GET /api/v1/geolocations?filter\[ip_address\]=1.1.1.1
```
- Filtering: Only filtering by ip_address is supported.

```http
GET /api/v1/geolocations?page[limit]=10&page[cursor]=11
```
- Pagination
  - Works with cursor-based pagination.
  - In this case, we are using the id as the cursor to paginate the records because the id is auto-incremented and unique.
  - As a trade-off, we are limiting sorting capabilities.

```bash
curl -X GET "http://localhost:3000/api/v1/geolocations?page[limit]=10&page[cursor]=11" \
    -H "Authorization: Bearer YOUR_API_KEY"
```

#### Get single geolocation data

```http
GET /api/v1/geolocations/:id
```

```bash
curl -X GET "http://localhost:3000/api/v1/geolocations/1" \
    -H "Authorization: Bearer YOUR_API_KEY"
```

#### Create geolocation data
- To create geolocation data, call the following endpoint with the ipv4 or ipv6 or url(ex- www.google.com) in the
  request body
- Geolocation data will be created by calling the external api

```http
POST /api/v1/geolocations

{
  "endpoint": "1.1.1.1"
}
```

```bash
curl -X POST "http://localhost:3000/api/v1/geolocations" \
    -H "Authorization Bearer YOUR_API_KEY" \
    --data '{"endpoint": "www.google.com"}'
```

#### Delete geolocation data
- To delete geolocation data, call the following endpoint with the proper id of the Geolocation data

```http
DELETE /api/v1/geolocations/:id
```

```bash
curl -X DELETE 'http://localhost:3000/api/v1/geolocations/1' \
    -H 'Authorization Bearer YOUR_API_KEY'
```


### How to run the test suite

- Run the following commands in the root directory of the project

```bash
rails spec
```
