module.exports = (grunt)->
  files = 
    require \./.compiled/app-structure.json
  make-pair = (mask-from, mask-to) ->
    make-pair = (source)->
      ".compiled/#{source.replace mask-from, mask-to}" : source
    files.filter(-> it.index-of(mask-from) > -1).map make-pair
  key = (o)->
      Object.keys(o).0
  require(\time-grunt) grunt
  load-module-first = (x)->
      | Object.keys(x).0.index-of('module') > -1 => -1
      | _ => 0
  separate = (arr, return-mods)->
       arr.filter(-> (Object.keys(it).0.index-of(\module) >  -1) is return-mods)
  live = 
      make-pair(\.ls,\.js)
  live-modules = 
      separate live, yes
  live-other =
      separate live, no
  coffee = 
      make-pair(\.coffee,\.js)
  ts = 
      make-pair(\.ts,\.js)
  coffee-modules = 
      separate coffee, yes
  coffee-other =
      separate coffee, no
  
  ts-modules = 
      separate ts, yes
  ts-other =
      separate ts, no
  
  
  files = 
    live: live-modules ++ live-other
    coffee: coffee-modules ++ coffee-other
    ts: ts-modules ++  ts-other
    jade: make-pair \.jade, \.html
    sass: make-pair \.sass, \.css
     
  path = do
    js = -> "client/js/#it"
    app: js \app.js
    app-style: \.compiled/app/index.css
    app-module: \.compiled/app/index.js
    templates: js \app_templates.js
  grunt.init-config do
    sass:
      no_options:
        files:
          files.sass
    jade:
      html:
        files: files.jade
        options:
          client: no
          wrap: no
          node: no
          runtime: no
    ngAnnotate:
      options:
         single-quotes: yes
      app1:
         files: files.live.map(key).filter(-> it.index-of(\client.js) > -1).map(-> "#it": [it])
    ngtemplates:
      app:
        src: files.jade.map(key).filter(-> it.index-of(\app/index) is -1)
        dest: path.templates
        options:
          url: (url) ->
            url.replace \.html, ''
               .replace /.+\//i, ''
          bootstrap: (module, script)->
            "angular.module('app').run(['$templateCache',function($templateCache) { #{script} }])"
    ts:
       options:
        bare: yes
       src: files.ts
    livescript:
       options:
        bare: yes
       src:
        files: files.live
    coffee:
       options:
        bare: yes
       src:
        files: files.coffee
    bower:
      install: {}
    bower_concat:
      all:
        dest: \lib/_bower.js
        cssDest: \lib/_bower.css
        dependencies: {}
        bowerOptions:
          relative: false
    concat:
      basic:
        src: 
            staf =
                * \lib/_bower.js
                * path.app-module
                * \.compiled/xonom.service.js
                * path.templates
            temp =
                * \.compiled/app/components/terminal/1.term.client.js
                ...
            lives =
                files.live.map(key).filter(-> it.index-of(\client.js) > -1)
            coffees =
                files.coffee.map(key).filter(-> it.index-of(\client.js) > -1)
            staf ++ temp ++ lives ++ coffees
        dest: path.app
        options:
          banner: "(function( window ){ \n 'use strict';"
          footer: "}( window ));"
      extra:
        src: do
          const bower = 
            * \lib/_bower.css
            ...
          const app = 
            files.sass.map(key)
          bower ++ app
        dest: \client/css/app.css
    min :
      dist : 
        src : [\client/js/app.js]
        dest: \client/js/app.js
    copy:
      main:
        files:
          * expand: no
            src: [\.compiled/app/index.html]
            dest: \client/index.html
          * expand: yes
            cwd: ''
            src: \app/components/**/*.js
            dest: \.compiled
            flatten: no
            filter: \isFile
          ...
    removelogging:
      dist:
        src: "js/application.js"
        dest: "js/application-clean.js"
    watch:
      scripts:
        files: 
          * \app/**/*.*
          ...
        tasks: 
           * \newer:sass
           * \newer:jade
           * \newer:livescript
           * \newer:coffee
           * \xonom
           * \ngtemplates
           * \copy
           * \concat:basic
           * \concat:extra
           * \shell:start
           * \clean
           ...
        options:
          spawn: no
          livereload: no
    clean:
      build:
        src: [\client/js/app_templates.js]
    open:
      dev:
        path: 'http://127.0.0.1:80'
        app: 'google-chrome'
    xonom:
      options:
        input:
          controllers: files.live.map(key).filter (.index-of(\api.server.js) > -1)
        output:
           angular-service: \.compiled/xonom.service.js
           express-route: \.compiled/xonom.route.js
    shell:
        start:
          command: 'killall -9 node; cd .compiled; forever stop server.js; forever start server.js'
        node:
          command: 'killall -9 node; node .compiled/server.js'
    newer:
      options:
        cache: \.cache
  const npm-tasks =
    * load: \bower-task
      register: \bower
      configs: [\default]
    * load: \bower-concat
      register: \bower_concat
      configs: [\default]
    * load: \ts
      register: \ts
      configs: []
    * load: \livescript
      register: \livescript
      configs:
         * \default
         * \dist
         * \debug
    * load: \contrib-coffee
      register: \coffee
      configs: [\default]
    * load: \contrib-jade
      register: \jade
      configs:
        * \default
        * \dist
        * \debug
    * load: \ng-constant
      register: \ngconstant
      configs:
        * \dist
        ...
    * load: \angular-templates
      register: \ngtemplates
      configs: 
        * \default
        * \dist
        * \debug
    * load: \contrib-sass
      register: \sass:no_options
      configs: 
        * \default
        * \dist
        * \debug
    * load: \contrib-copy
      register: \copy
      configs: 
        * \default
        * \debug
        ...
    * load: \xonom
      register: \xonom
      configs:
        * \default
        * \debug
        ...
    * load: \ng-annotate
      register: \ngAnnotate
      configs:
        * \default
        * \debug
        ...
    * load: \contrib-concat
      register: \concat
      configs:
        * \default
        * \debug
        ...
    * load: \contrib-uglify
      register: \uglify
      configs: []
    * load: \yui-compressor
      register: \min
      configs: []
    * load: \shell
      register: \shell:start
      configs: [\default]
    * load: \shell
      register: \shell:node
      configs: [\debug]
    * load: \aws-s3
      register: \aws_s3
      configs: [\dist]
    * load: \contrib-clean
      register: \clean
      configs:
         * \default
         * \debug
         * ...
    * load: \open
      register: \open
      configs: 
        []
        ...
    * load: \contrib-watch
      register: \watch
      configs:
         * \default
         ...
  for task in npm-tasks
    grunt.load-npm-tasks "grunt-#{task.load}"
  const load = (name)->
    grunt.register-task do
      * name
      * npm-tasks.filter(-> it.configs.index-of(name) > -1).map(-> it.register)
  
  grunt.load-npm-tasks('grunt-newer')
  
  load \default
  load \debug
