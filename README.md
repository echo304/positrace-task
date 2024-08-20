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

#### Database initialization

- Run the following commands in the root directory of the project

```bash
bin/rails db:setup
```

- You will have some sample data in the database
    - 5 Geolocations
    - 1 User
- You can also run the following command to reset the database

```bash
bin/rails db:reset
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

### Authentication

- The API is protected with API key authentication. You need to provide the API key in the request headers to access the
  API
- API authentication is implemented in `ApiKeysController`, `ApiKeyAuthenticatable` and `ApiKeys` model
- To secure the API key, it is stored in the database after hashing with `SHA256` algorithm

### Components

- **Geolocation**: It is the main component of this application. It is responsible for fetching geolocation data from
  `ipstack` API and storing it in the database
- **User**: It is the user model of the application. It is used for authentication purpose
- **ApiKeys**: It is the model to store the API keys for authentication purpose
- **ApiKeysController**: It is the controller to manage the API keys
- **ApiKeyAuthenticatable**: It is the module to authenticate the API keys
- **GeolocationsController**: It is the controller to manage the geolocation data

#### Why I didn't use PostGIS?
- TL;DR: PostGIS is an overkill for this application. It is a spatial database extender for PostgreSQL object-relational
  database. It adds support for geographic objects allowing location queries to be run in SQL. But for this application,
  we don't need to run any location queries in SQL. We are just fetching the geolocation data from `ipstack` API and
  storing it in the database. So, using PostGIS will be an overkill for this application
- https://blog.rebased.pl/2020/04/07/why-you-probably-dont-need-postgis.html

### API

- Make sure you have the authentication data in the request headers
- **For the brevity of this document, I will not include the authentication data in the request headers in the following
  examples**

#### Get geolocation data


#### Create geolocation data


#### Delete geolocation data



### How to run the test suite

- Run the following commands in the root directory of the project

```bash
docker-compose run rails rails spec
```
