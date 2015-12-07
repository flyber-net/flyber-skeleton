# Xonom-skeleton!

Application skeleton. Included angularjs + expressjs + angular.material + grunt + xonom + grunt-xonom


Video tutorial: (Russian tutorial)[https://www.youtube.com/watch?v=wjoalo8WgJk] (Russian)

Just install 
And start to develop without additional required steps

![Xonom](http://content.screencast.com/users/a.stegno/folders/Jing/media/fe8168b5-3c33-4b08-97b1-04f45c6e77d2/00000382.png)

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

Open in browser [http://localhost]()



## How to develop



All application files are located inside `app/components` folder.
Each component is folder which contains files:

![The structure](http://content.screencast.com/users/a.stegno/folders/Jing/media/4c4bcd1b-cc94-4f5a-99cd-26969867cbcd/00000383.png)

* file.api.server.js - server side controller
* file.controller.client.js - client side angularjs controller
* file.jade - html template
* file.sass - css stylesheet
* README.md - description and how to use example

and there could be compile-time files which generate into runtime .js files:

* file.api.server.ls
* file.api.server.ts
* file.api.server.coffee
* file.api.server.js

and there could be compile-time files which generate into runtime .html files:

* file.html
* file.jade

and there could be compile-time files which generate into runtime .css files:

* file.css
* file.sass

Each component should encapsulate everything inside.

There should not be dependencies between components.

Good practice is to provide a `README.md` file on how to work with concrete component.


## Component example

### Structure

```sh
app/
 components/
  user/
   db.service.server.js
   user.controller.client.js
   user.api.server.js
   user.jade
   user.sass
```

### db.service.server.js

```Javascript 

module.exports = function($xonom) {
   $xonom.service('$db', function() {
   
      return {
        user : {
      
         find : function() {
         
           //implementation
         
         },
         findOne: function() {
         
          //implementation
         
         }
      
      }
      }
   
   })
};
```


### user.controller.server.js

```Javascript 

module.exports = function($db) {
   all : function(callback) {
         // `user` collection is declared in config.json
         $db.user.find({}, { name: 1, _id: 1, connections: 1 }, function( err, users)  {
              callback(users);
         });
   },
   one: function(id, callback) {
        var db = import('db')
        $db.user.findOne({ _id: id }, function( err, user ) {
              callback(user);
        });
   }
};
```

### user.controller.client.js

```Javascript 

app.controller("user", function($scope, $xonom) {
  //`user` extracted from filename
  $xonom.user.all(function(err, users)) {
    $scope.users = users;
  };
  
  $scope.getDetails = function(id) {
     $xonom.user.one(id, function(err, details) { 
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
