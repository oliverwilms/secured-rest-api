## secured-rest-api
This is my entry for InterSystems Security Contest. My plan was to implement Oauth authentication / authorization. I read some articles and learned Oauth requires HTTPS which requires a webserver.

I had previously added Apache 2 webserver to IRIS container. So I began by cloning github.com:intersystems-community/secured-rest-api and adding some stuff...
 
The template contains an example of unauthenticated and authenticated access to the persistent data via REST API. It demoes the creation of users, roles and how to grant the access.

## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

## Installation with ZPM

zpm:USER>install $$NotInZPM

## Installation for development with Docker

Clone/git pull the repo into any local directory e.g. like it is shown below:

```
$ git clone git@github.com:oliverwilms/secured-rest-api.git
```

Open the terminal in this directory and run:

```
$ docker-compose up -d --build
```
## How to Work With it

The template creates two REST API web Apps: 
1. unsecured /crudall with access from any user.
2. and /crud REST web-application with basic authentication. 
 Both REST API spec the same, have the same class-dispatcher and implement 4 types of communication: GET, POST, PUT and DELETE aka CRUD operations to read, write an delete from the database.
These interface work with a sample persistent class dc.sample.rest.Person.

Open http://localhost:52773/swagger-ui/index.html to discover and test the REST API

The template also creates:
 * 10 random records in dc.sample.rest.Person
 * two roles: Reader with right to read records from dc.sample.rest.Person and Writer with right to add and alter.
 * two users: Bill with Reader role and John with Writer role.

## Testing unsecure access

UnknownUser that represents the unauthenticated access has the Reader role. And we can test unsecure access with /crudall web app.

### Testing GET requests

Open http://localhost:52773/crudall/persons/all to see the records from Person class in JSON, like this:

We see them because /crudall doesn't demand authentication according to [this line in ZPM module](https://github.com/evshvarov/secured-rest-api/blob/master/module.xml#L38)

and thus the /crudall registers sign in of a UnknownUser which has a role Reader [assigned in Security class](https://github.com/evshvarov/secured-rest-api/blob/master/src/dc/sample/rest/Security.cls#L48).

## Testing Secure access (Beginning)

Secured access in this template expressed via [deploying](https://github.com/evshvarov/secured-rest-api/blob/master/src/dc/sample/rest/Security.cls#L8) of two users Bill and John and Reader and Writer roles for the data access regulation.
The regulation is implemented via role checking in the REST-API implementation calls: e.g. here for [GET](https://github.com/evshvarov/secured-rest-api/blob/master/src/dc/sample/rest/PersonREST.cls#L42) and [PUT](https://github.com/evshvarov/secured-rest-api/blob/master/src/dc/sample/rest/PersonREST.cls#115) calls.

Open http://localhost:52773/crud/persons/all. You'll be prompted for the basic authentication. Sign in with user Bill with ChangeMe password, that has Reader role. And you'll see the data as the Reader role is assigned to user Bill.

## Your connection to this site is not private

When my browser prompts for Username and Password to sign in, the form displays that your connection is not private.

Check also in another window or via request in Postman that if you sign in with user John you'll get 403 error back (Unauthorised access) as user John doesn't have role Reader.

PUT and POST requests can be tested on a http://localhost:52773/crud/persons/ call which we can test e.g. via Postman. The [postman collection](https://github.com/evshvarov/secured-rest-api/blob/master/secured%20rest-api.postman_collection.json) with calls can be found in the repo.
Try the Update Person PUT call that will change the name of the first record to John Doe and will perform the call with Basic Authentication and John as a user.
If you change the user to Bill you'll get 403 response.


## Next Steps

Next steps for these demo could be the representation of API map in Open API (swagger) standard and implementation if a Bearer Authentication

I added Apache 2 webserver but it is not working properly.
## Collaboration  

Pull requests are very welcome!
