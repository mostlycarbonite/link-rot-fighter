webshotLib = require('webshot')
capturesSavePath = process.env.LRF_HOSTS_PATH or 'captures'
captureHeight = process.env.LRF_HEIGHT or 'all'
captureWidth = process.env.LRF_WIDTH or 1440

path = require 'path'
urlLib = require 'url'
sanitize = require("sanitize-filename")
fs = require('fs')
yamlLib = require 'yamljs'
moment = require('moment')
ld = require 'lodash'

class WebCapture

  constructor: (saveDir) ->

  capture: (url, cb) =>
    hostName = new urlLib.parse(url).hostname
    fileName = sanitize(url).replace(".", "_")
    pathWithHost = path.join(process.cwd(), capturesSavePath, sanitize(hostName))
    @captureList = null
    yamlPath = path.join(capturesSavePath, 'captures.yaml')
    capturePath = path.join(pathWithHost, "#{fileName}-#{new moment().format('DD-MMM-YYYY')}.png")

    afterYamlLoad = (captureList) =>

      if captureList?
        @captureList = captureList
      else
        captureList = []

      options =  shotSize: { width: captureWidth , height: captureHeight }

      # does a capture need to be done?
      unless ld.find(@captureList, {site: hostName, url: url})
        webshotLib(url, capturePath, options, afterWebshotComplete)

    afterWebshotComplete = (err) =>
      if err? cb(err, null)

      else
        ###
          structure is:

            site: host name
              captures: [
                url: image path
                url: image path
                url: image path
              ]
        ###
        debugger
        (@captureList ?= [])
        hostObj = null
        unless ld.find(@captureList, {site: {baseUrl: hostName}})
          hostObj = {site: {baseUrl: hostName, captures: []}}
          @captureList.push(hostObj)
        else
          hostObj = ld.find(@captureList, {site: {baseUrl: hostName}})

        unless ld.find(hostObj.site.captures, {url: url, capturePath: capturePath })
          (hostObj.site.captures ?= []).push( {url: url, capturePath: capturePath })

        fs.writeFile(yamlPath, (yamlLib.stringify @captureList), (err) ->
          if err
            cb?(err, null)
          else cb(null, capturePath)
        )

    yamlLib.load(yamlPath, afterYamlLoad)

module.exports = WebCapture

