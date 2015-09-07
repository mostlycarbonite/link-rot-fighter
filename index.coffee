http = require('http')
qs = require('querystring')
jsonify = require 'json-stringify-safe'

formOutput = '<html><body>' + '<h1>XYZ Repository Commit Monitor</h1>' + '<form method="post" action="inbound" enctype="application/x-www-form-urlencoded"><fieldset>' + '<div><label for="UserName">User Name:</label><input type="text" id="UserName" name="UserName" /></div>' + '<div><label for="Repository">Repository:</label><input type="text" id="Repository" name="Repository" /></div>' + '<div><label for="Branch">Branch:</label><input type="text" id="Branch" name="Branch" value="master" /></div>' + '<div><input id="ListCommits" type="submit" value="List Commits" /></div></fieldset></form></body></html>'

serverPort = process.env.LRF_PORT or 7777

server = http.createServer((request, response) ->
  if request.method == 'GET'
    if request.url == '/favicon.ico'
      response.writeHead 404, 'Content-Type': 'text/html'
      response.write '<!doctype html><html><head><title>404</title></head><body>404: Resource Not Found</body></html>'
      response.end()
    else
      response.writeHead 200, 'Content-Type': 'text/html'
      response.end """
          <html>
          <body>
          <h1>Link Rot Fighter</h1>
          <p>POST a url to this address to capture a page and store it to the file system.</p>

          <p>Files are stored in directories that match their base url (google for http://google.com for instance). The image file names are UUIDs and stored next to a file called url.txt that contains the url that the image was pulled from. </p>

          </body></html>

          """
  else if request.method == 'POST'
    console.log "POST received"
    if request.url == '/scrape'
      requestBody = ''

      request.on 'data', (data) ->
        requestBody += data

        if requestBody.length > 1e7
          response.writeHead 413, 'Request Entity Too Large', 'Content-Type': 'text/html'
          response.end '<!doctype html><html><head><title>413</title></head><body>413: Request Entity Too Large</body></html>'

        request.on 'end', ->
          formData = qs.parse(requestBody)
          response.writeHead 200, 'Content-Type': 'text/html'

          if formData.url?
            console.dir ('capturing ' + formData.url)
            wc = new (require './webCapture')()
            ais = new (require './archiveIS')()

            hadError = (err) ->
              if err?
                console.error(jsonify(err))
                response.write("<p>Failed: #{err}</p>")
                response.end()
                return true
              else
                return false

            # check AIS for this url
            ais.check formData.url, (err, result) ->
              console.log "checked url: #{formData.url}"
              if hadError(err) then return null
              if not result.found
                # save AIS for this url
                console.log "saving url with archive.is"
                ais.save(formData.url, (err, result) ->
                  if hadError(err) then return null
                  # capture shot of this url
                  console.log "capturing url"
                  wc.capture(formData.url, (err) ->

                    if hadError(err)
                      return null
                    else
                      console.log('capture complete')
                      response.end("Capture for url: #{formData.url} -- complete.")
                  )
                )
              else
                console.log "Archive has url, no capture needed."
                response.end("No capture needed.")


    else
      response.writeHead 404, 'Resource Not Found', 'Content-Type': 'text/html'
      return response.end '<!doctype html><html><head><title>404</title></head><body>404: Resource Not Found</body></html>'

  else
    response.writeHead 405, 'Method Not Supported', 'Content-Type': 'text/html'
    return response.end('<!doctype html><html><head><title>405</title></head><body>405: Method Not Supported</body></html>')
)

server.listen(serverPort)

console.log 'Server running at localhost:' + serverPort
