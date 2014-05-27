file-monitor
============

## Install

```
npm install file-monitor
```

## Description

Easy to monitor files in directory. When file changed return the file content to you.

## Example

```js
var options;
options = {
  tryParseJson: true,
  filter: function(file, stat) {
    //Filter files you want to add monitor
    if (file.indexOf("ignore.txt") === -1) {
      return true;
    } else {
      return false;
    }
  }
};
filewatch.watchDirectory("./testFolder", options, function(err, f, c, p, data) {
  if (err == null) {
    console.log("File name: " + f);
    return console.log("File content is: " + data);
  }
});
```

The options object has two options:
* `tryParseJson` : When true means it will try to use `JSON.parse()` to parse file content and return the object in callback.
* `filter` : You can use this option to provide a function that returns true or false to decide whether add this file to monitor.