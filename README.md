# Xonom-skeleton!

## Installation of environment


On Ubuntu:



### APP:

```sh
sudo apt-get install nodejs git
git clone git@github.com/askucher/xonom-skeleton
cd xonom-skeleton
sh install
sh run
#sh run debug
```

Open in browser [http://localhost:80]()


### DB

```sh
sudo apt-get install mongodb
# onfailed try: try http://docs.mongodb.org/manual/tutorial/install-mongodb-on-ubuntu/
# keep default mongo settings or change /etc/mongod.conf
sudo service mongodb restart

# For Mongo > 2.4.x
mongo --eval "db.createCollection('testcoll'); use gotogether; db.addUser({user: 'test', pwd: '3453fefsfdsfsfsfsFdsfsdf44', roles: ['dbAdmin']});"

# For Mongo 3.x
mongo --eval "db.createCollection('testcoll'); db.createUser({user: 'test', pwd: '3453fefsfdsfsfsfsFdsfsdf44', roles: ['dbAdmin']});"
```



## Dependencies


* Ruby (required by Sass) `sudo apt-get install ruby-full=1.9.3` (this will install old stable Ruby 1.9.3). 
* Sass `sudo su -c "gem install sass"`




## How to develop

All application files are located inside `app/components` folder.
Each component is folder which contains files:

* file.controller.server.js - server side controller
* file.controller.client.js - client side angularjs controller
* file.jade - html template
* file.sass - css stylesheet
* README.md - description and how to use example

and there could be compile-time files which generate into runtime .js files:

* file.controller.server.ls
* file.controller.server.ts


Each component should encapsulate everything inside.

There should not be dependencies between components.

Good practice is to provide a `README.md` file on how to work with concrete component.


## Component example

### Structure

```sh
app/
 components/
  user/
   user.controller.client.js
   user.controller.server.js
   user.jade
   user.sass
```

### user.controller.server.js

```Javascript 

module.exports = {
   all : function(callback) {
         var db = import('db')
         // `user` collection is declared in config.json
         db.user.find({}, { name: 1, _id: 1, connections: 1 }, function( err, users)  {
              callback(users);
         });
   },
   one: function(id, callback) {
        var db = import('db')
        db.user.findOne({ _id: id }, function( err, user ) {
              callback(user);
        });
   }
};
```

### user.controller.client.js

```Javascript 

app.controller("user", function($scope, xonom) {
  //`user` extracted from filename
  xonom.user.all(function(err, users)) {
    $scope.users = users;
  };
  
  $scope.getDetails = function(id) {
     xonom.user.one(id, function(err, details) { 
        $scope.details = details;
     };
  };
});

```

### user.jade

```Jade 
.user.component(ng:controller="user")
 .details(ng:if="details")
  h3 details.name
  p Connections: {{details.connections.length}}
  p Events: {{details.events.length}}
 .users
   .user(ng:repeat="user in users" ng:click="getDetails(user._id)")
      h3 {{user.name}}
      p Connections: {{user.connections.length}}
```

### user.sass

```Sass
.user.component
 .details
  h3
    font-weight: bold
  p 
    color: #CCC
 .users 
   .user
      h3
        font-weight: bold
      p
        color: #CCC
```

Then grunt should reload everything automatically


All your files will be concatenated into one js and css file and ready for usage.

No additional actions are required.