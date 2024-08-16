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

- For the purpose of this test, I used sqlite3 as the database. So no need to setup any database.

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

```bash
bundle install
export GEOLOCATION_ACCESS_KEY={{YOUR_ACCESS_KEY}}
export GEOLOCATION_URL=http://api.ipstack.com/
bin/rails server
```

### Authentication


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
