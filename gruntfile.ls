module.exports = (grunt)->
  p = 
    require \prelude-ls
  files = 
    require \./.compiled/app-structure.json
  make-pair = (mask-from, mask-to) ->
    make-pair = (source)->
      ".compiled/#{source.replace mask-from, mask-to}" : source
    files |> p.filter(-> it.index-of(mask-from) > -1)
          |> p.map make-pair
  key = (o)->
      Object.keys(o).0
  require(\time-grunt) grunt
  const load-module-first = (x)->
      | Object.keys(x).0.index-of('module') > -1 => -1
      | _ => 0
  const separate = (arr, return-mods)->
       live.filter(-> (Object.keys(it).0.index-of(\module) >  -1) is return-mods)
  const live = 
      make-pair(\.ls,\.js)
  const live-modules = 
      separate live, yes
  const live-other =
      separate live, no
  const coffee = 
      make-pair(\.coffee,\.js)
  const coffee-modules = 
      separate coffee, yes
  const coffee-other =
      separate coffee, no
  
  files = 
    live: live-modules ++ live-other
    coffee: coffee-modules ++  coffee-other
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
         files: files.live |> p.map key
                           |> p.filter (.index-of(\client.js) > -1)
                           |> p.map (-> "#it": [it])
    ngtemplates:
      app:
        src: files.jade |> p.map key |> p.filter (.index-of(\app/index) is -1)
        dest: path.templates
        options:
          url: (url) ->
            url.replace \.html, ''
               .replace /.+\//i, ''
          bootstrap: (module, script)->
            "angular.module('app').run(['$templateCache',function($templateCache) { #{script} }])"
    ts:
      default :
        src:  
          * "app/**/*.ts"
          ...
    livescript:
       options:
        bare: yes
       src:
        files: files.live
    concat:
      basic:
        src: p.union do
              * * \bower_components/angular/angular.js
                * \bower_components/angular-animate/angular-animate.js
                * \bower_components/angular-aria/angular-aria.js
                * \bower_components/angular-material/angular-material.js
                * \bower_components/angular-ui-router/release/angular-ui-router.js
                * path.app-module
                * \.compiled/xonom.service.js
                * path.templates
              * files.live |> p.map key
                           |> p.filter (.index-of(\client.js) > -1)
        dest: path.app
        options:
          banner: "(function( window ){ \n 'use strict';"
          footer: "}( window ));"
      extra:
        src: do
          const bower = 
            * \bower_components/angular-material/angular-material.css
            ...
          const app = 
            files.sass |> p.map key
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
    
    watch:
      scripts:
        files: 
          * \app/components/**/*.*
          ...
        tasks: 
           * \newer:sass
           * \newer:jade
           * \newer:livescript
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
          livereload: yes  
    clean:
      build:
        src: [\client/js/app_templates.js]
    xonom:
      options:
        input:
          controllers: files.live |> p.map key
                                  |> p.filter (.index-of(\xonom.server.js) > -1)
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
    * load: \ts
      register: \ts
      configs: []
    * load: \livescript
      register: \livescript
      configs:
         * \default
         * \dist
         * \debug
         * \dev
    * load: \contrib-coffee
      register: \coffee
      configs: []
    * load: \contrib-jade
      register: \jade
      configs:
        * \default
        * \dist
        * \debug
        * \dev
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
        * \dev
    * load: \contrib-sass
      register: \sass:no_options
      configs: 
        * \default
        * \dist
        * \debug
        * \dev
    * load: \contrib-copy
      register: \copy
      configs: 
        * \default
        * \debug
        * \dev
        ...
    * load: \xonom
      register: \xonom
      configs:
        * \default
        * \debug
        * \dev
        ...
    * load: \ng-annotate
      register: \ngAnnotate
      configs:
        * \default
        * \debug
        * \dev
        ...
    * load: \contrib-concat
      register: \concat
      configs:
        * \default
        * \debug
        * \dev
        ...
    * load: \contrib-uglify
      register: \uglify
      configs: []
    * load: \yui-compressor
      register: \min
      configs: []
    * load: \shell
      register: \shell:start
      configs: [\default, \dev]
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
         * \dev
         * ...
    * load: \contrib-watch
      register: \watch
      configs:
         * \dev
         ...
  for task in npm-tasks 
    grunt.load-npm-tasks "grunt-#{task.load}"
  const load = (name)->
    grunt.register-task do
      * name
      * npm-tasks |> p.filter (.configs.index-of(name) > -1) |> p.map (.register)
  grunt.load-npm-tasks('grunt-newer')
  load \default
  load \debug
  load \dev
  #load \dist
