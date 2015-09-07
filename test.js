// Generated by CoffeeScript 1.9.3
(function() {
  var archiveTool, assert, capTool;

  archiveTool = new (require('./archiveIS'))();

  capTool = new (require('./webCapture'))();

  assert = require('assert');

  assert(capTool.capture != null, 'failed to find capture function');

  assert(archiveTool.save != null, 'failed to find archive save function');

  assert(archiveTool.check != null, 'failed to find archive check function');

  archiveTool.check('http://nbcnews.com', function(err, result) {
    if (err != null) {
      assert.fail('error: ' + err.message);
    }
    if (result.found) {
      return console.log("NBC News present, passed.");
    } else {
      console.error("Failed, query says NBC News not found.");
      return process.exit();
    }
  });

  archiveTool.check('http://aslkdjflkajsdfluoiwueoriu0980989.com', function(err, result) {
    if (err != null) {
      assert.fail('error: ' + err.message);
    }
    if (result.found === true) {
      assert.fail("Crazy fake url found when it should'nt have been");
      return process.exit();
    } else {
      return console.log("Crazy fake url not present, passed.");
    }
  });

  archiveTool.save('http://reddit.com', function(err, result) {
    if (err != null) {
      assert.fail('error: ' + err.message);
      return process.exit();
    } else {
      return console.log("Archive save passed");
    }
  });

  capTool.capture('http://reddit.com', function(err, path) {
    if (err != null) {
      assert.fail('error' + err.message);
      return process.exit();
    } else {
      return console.log("Capture passed (dir: " + path + ").");
    }
  });

  capTool.capture('http://reddit.com/r/bestof', function(err, path) {
    if (err != null) {
      assert.fail('error' + err.message);
      return process.exit();
    } else {
      return console.log("Capture passed (dir: " + path + ").");
    }
  });

  capTool.capture('http://reddit.com/r/aww', function(err, path) {
    if (err != null) {
      assert.fail('error' + err.message);
      return process.exit();
    } else {
      return console.log("Capture passed (dir: " + path + ").");
    }
  });

  capTool.capture('http://reddit.com/r/funny', function(err, path) {
    if (err != null) {
      assert.fail('error' + err.message);
      return process.exit();
    } else {
      return console.log("Capture passed (dir: " + path + ").");
    }
  });

}).call(this);

//# sourceMappingURL=test.js.map
