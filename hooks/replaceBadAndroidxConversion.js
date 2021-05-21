var fs = require('fs');
var path = require('path');

function isCordovaAbove (context, version) {
  var cordovaVersion = context.opts.cordova.version;
  console.log(cordovaVersion);
  var sp = cordovaVersion.split('.');
  return parseInt(sp[0]) >= version;
}


module.exports = function (context) {
  var cordovaAbove8 = isCordovaAbove(context, 8);
  if (cordovaAbove8) {
    console.log("Start changing Code Files!")
    //get EmojiFragment and ImageFragment
    var rawConfig = fs.readFileSync("config.xml", 'ascii');
    var match = /<name>([\s|\S]*)<\/name>/gm.exec(rawConfig);
    console.log(match)
    if(!match || match.length != 2){
        throw new Error("id parse failed");
    }

    var appname = match[1];
    console.log(appname)
    
    var projectRoot = context.opts.cordova.project ? context.opts.cordova.project.root : context.opts.projectRoot;
    var sdkPath = path.join(projectRoot,"platforms","android","com.outsystems.imageeditorplugin",appname+"-photoeditor","src","main","java","com","ahmedadeltito","photoeditor");
    var emojiPath = path.join(sdkPath,"EmojiFragment.java");
    var imagePath = path.join(sdkPath,"ImageFragment.java");
    if(fs.existsSync(emojiPath) && fs.existsSync(imagePath)){
      
      var regex = /([\s|\S]*)(androidx\.gridlayout\.widget)([\s|\S]*)/g

      replaceRegexOnFile(emojiPath,regex);
      replaceRegexOnFile(imagePath,regex);

      console.log("Finished changing Files!");
    }
  }

  function replaceRegexOnFile(path,regex){
    var content = fs.readFileSync(path,"utf8");
    content = content.replace(regex,replacerCallback)
    fs.writeFileSync(path,content);
  }

  function replacerCallback(match, p1,p2, p3, offset, string){
    return [p1,"androidx.recyclerview.widget.GridLayoutManager",p3].join("");
  }
}
