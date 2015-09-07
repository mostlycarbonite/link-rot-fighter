archiveTool = new (require('./archiveIS'))()
capTool = new (require('./webCapture'))()
assert = require('assert')

assert(capTool.capture?, 'failed to find capture function')
assert(archiveTool.save?, 'failed to find archive save function')
assert(archiveTool.check?, 'failed to find archive check function')

archiveTool.check('http://nbcnews.com', (err, result) ->
  if err? then assert.fail 'error: ' + err.message
  if result.found
    console.log "NBC News present, passed."
  else
    console.error "Failed, query says NBC News not found."
    process.exit()
)

archiveTool.check('http://aslkdjflkajsdfluoiwueoriu0980989.com', (err, result) ->
  if err? then assert.fail 'error: ' + err.message
  #console.dir(result)
  if result.found == true
    assert.fail "Crazy fake url found when it should'nt have been"
    process.exit()
  else
    console.log "Crazy fake url not present, passed."
)

archiveTool.save('http://reddit.com', (err, result) ->
  if err?
    assert.fail 'error: ' + err.message
    process.exit()
  else
    console.log "Archive save passed"
)

capTool.capture('http://reddit.com', (err, path) ->
  if err?
    assert.fail 'error' + err.message
    process.exit()
  else
    console.log "Capture passed (dir: #{path})."
)

capTool.capture('http://reddit.com/r/bestof', (err, path) ->
  if err?
    assert.fail 'error' + err.message
    process.exit()
  else
    console.log "Capture passed (dir: #{path})."
)

capTool.capture('http://reddit.com/r/aww', (err, path) ->
  if err?
    assert.fail 'error' + err.message
    process.exit()
  else
    console.log "Capture passed (dir: #{path})."
)
capTool.capture('http://reddit.com/r/funny', (err, path) ->
  if err?
    assert.fail 'error' + err.message
    process.exit()
  else
    console.log "Capture passed (dir: #{path})."
)