#!/bin/bash

if [ "$1" = "before-configure" ]
then
  sed -i '/DepDescs = \[/a \{easton,           "easton",           "bc03c71de798be1f0e4b3c74da0eaeb7a2938c78"\},\n\{hastings ,        "hastings",         "1cca585bc63c3c246b674fca33a661b083e9f6f7"\},' rebar.config.script
  # Fix failing fauxton build
  sed -i '/fauxton/{n;s/".*"/"v1.1.13"/}' rebar.config.script
  sed -i '/MakeDep = fun/a\\t\t(\{AppName, RepoName, Version\}) when AppName == hastings; AppName == easton ->\n\t\t\tUrl = "https://github.com/cloudant-labs/" ++ RepoName ++ ".git",\n\t\t\t{AppName, ".*", \{git, Url, Version\}\};\n' rebar.config.script
  sed -i '/{plugins, \[/a    hastings_epi,' rel/apps/couch_epi.config
  sed -i '/{rel, "couchdb"/a        easton,' rel/reltool.config
  sed -i '/{rel, "couchdb"/a        hastings,' rel/reltool.config
  sed -i '/{app, global_changes,/a\{app, easton, \[\{incl_cond, include\}\]\},' rel/reltool.config
  sed -i '/{app, global_changes,/a\{app, hastings, \[\{incl_cond, include\}\]\},' rel/reltool.config
  cat <<EOT > share/server/spatial.js
var Spatial = (function() {

  var index_results = []; // holds temporary emitted values during index

  function handleIndexError(err, doc) {
    if (err == "fatal_error") {
      throw(["error", "map_runtime_error", "function raised 'fatal_error'"]);
    } else if (err[0] == "fatal") {
      throw(err);
    }
    var message = "function raised exception " + err.toSource();
    if (doc) message += " with doc._id " + doc._id;
      log(message);
    };

    return {
      index: function(value, options) {
        index_results.push([value, options || {}]);
      },

      indexDoc: function(doc) {
        Couch.recursivelySeal(doc);
        var buf = [];
        for each (fun in State.funs) {
          index_results = [];
          try {
            fun(doc);
            buf.push(index_results);
          } catch (err) {
            handleIndexError(err, doc);
            buf.push([]);
          }
        }
        print(JSON.stringify(buf));
      }

    }
})();
EOT

  sed -i '/sandbox = eval/a\\t\tsandbox.st_index = Spatial.index;' share/server/loop.js
  sed -i '/: DDoc.ddoc/a\\t\t"st_index_doc": Spatial.indexDoc,' share/server/loop.js

  echo "[hastings]
enabled = true" >> rel/overlay/etc/default.ini
  sed -i '/JsFiles = \[/a        "share/server/spatial.js",' support/build_js.escript
  sed -i '/CoffeeFiles = \[/a        "share/server/spatial.js",' support/build_js.escript
else
  sed -i '/{user, cloudant_util:customer_name(Db)},/d' src/hastings/src/hastings_index_updater.erl
fi
