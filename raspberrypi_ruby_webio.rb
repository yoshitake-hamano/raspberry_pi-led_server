#!/usr/bin/env ruby

# File: raspberrypi_ruby_webio.rb - last edit
# yoshitake 07-Jan-2015

require 'json'
require 'webrick'

class InfraredDriver
  GPIO_INDEX            = 4
  GPIO_ROOT             = "/sys/class/gpio"
  GPIO_EXPORT           = "#{GPIO_ROOT}/export"
  GPIO_TARGET           = "#{GPIO_ROOT}/gpio#{GPIO_INDEX}"
  GPIO_TARGET_DIRECTION = "#{GPIO_TARGET}/direction"
  GPIO_TARGET_VALUE     = "#{GPIO_TARGET}/value"

  def initialize
    open(GPIO_EXPORT, "w") do |io|
      io.print("#{GPIO_INDEX}")
    end
    # wait for GPIO_TARGET files.
    sleep(1)
    open(GPIO_TARGET_DIRECTION, "w") do |io|
      io.print("out")
    end
  end

  def infrared_light(req, res)
    json = JSON.parse(req.body)
    io   = open(GPIO_TARGET_VALUE, "w")
    json["data"].each_with_index do |data, i|
      if ((i % 2) == 0)
        io.print("1")
      else
        io.print("0")
      end
      io.flush
      sleep_time = data / 2_000_000.0
      sleep(sleep_time)
    end
    puts
  end
end

webio = InfraredDriver.new

server = WEBrick::HTTPServer.new(:Port =>8000)
server.mount_proc('/infrared_light') do |req, res|
  webio.infrared_light(req, res)
end

trap('INT') { server.shutdown }
server.start

# Log
# 07-Jan-2015 yoshitake Created.
