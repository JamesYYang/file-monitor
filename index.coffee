sys = require("util")
fs = require("fs")
path = require("path")
events = require("events")

watchFiles = {}

walk = (dir, options, callback) ->
  if not callback.pending 
    callback.pending = 0
  callback.pending += 1

  fs.stat dir, (err, stat) ->
    return callback(err)  if err
    fs.readdir dir, (err, files) ->
      return callback(err)  if err
      callback.pending -= 1
      console.log "Pending dir: #{callback.pending}"
      files.forEach (f, index) ->
        f = path.join(dir, f);
        callback.pending += 1
        fs.stat f, (err, stat) ->
          return callback(err)  if err
          callback.pending -= 1
          console.log "Pending dir: #{callback.pending}"
          if stat.isFile() 
            if not options.filter or (options.filter? and options.filter(f, stat))
              watchFiles[f] = f
          else
            walk f, options, callback if stat.isDirectory()

          callback(null) if callback.pending is 0
      callback(null) if callback.pending is 0
    callback(null) if callback.pending is 0
            

  

exports.watchTree = (root, options, callback) ->
  unless callback
    callback = options
    options = {}
  walk root, options, (err) ->
    throw err  if err
    fileWatcher = (f) ->
      fs.watchFile f, options, (c, p) ->
        # Check if anything actually changed in stat
        return  if watchFiles[f] and c.nlink isnt 0 and p.mtime.getTime() is c.mtime.getTime()
        fs.readFile f, (err, data) ->
          return if err
          if options.tryParseJson?
            try
              obj = JSON.parse data
              callback null, f, c, p, obj
            catch
              callback null, f, c, p, data
            

    for file of watchFiles
      fileWatcher file

  return