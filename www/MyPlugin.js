cordova.define("de.websector.myplugin.MyPlugin", function(require, exports, module) { var exec = require('cordova/exec');
/**
 * Constructor
 */
               function MyPlugin() {}
               
               MyPlugin.prototype.sayHello = function(win,fail,options) {
               exec(win,fail, "MyPlugin", "sayHello",options);
               }
               
               var myPlugin = new MyPlugin();
               module.exports = myPlugin
               });

