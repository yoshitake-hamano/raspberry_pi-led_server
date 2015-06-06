#!/usr/bin/env ruby

# File: led_server.rb - last edit
# yoshitake 07-Jan-2015

require 'webrick'

class LedDriver
  LED_INDEX            = 4
  LED_ROOT             = "/sys/class/gpio"
  LED_EXPORT           = "#{LED_ROOT}/export"
  LED_TARGET           = "#{LED_ROOT}/gpio#{LED_INDEX}"
  LED_TARGET_DIRECTION = "#{LED_TARGET}/direction"
  LED_TARGET_VALUE     = "#{LED_TARGET}/value"

  def initialize
    open(LED_EXPORT, "w") do |io|
      io.print("#{LED_INDEX}")
    end
    # wait for LED_TARGET files.
    sleep(1)
    open(LED_TARGET_DIRECTION, "w") do |io|
      io.print("out")
    end
  end

  def on
    open(LED_TARGET_VALUE, "w") do |io|
      io.print("1")
    end
  end

  def off
    open(LED_TARGET_VALUE, "w") do |io|
      io.print("0")
    end
  end
end

led = LedDriver.new

server = WEBrick::HTTPServer.new(:Port =>8000)
server.mount_proc('/on') do |req, res|
  led.on
end

server.mount_proc('/off') do |req, res|
  led.off
end

trap('INT') { server.shutdown }
server.start

# Log
# 07-Jan-2015 yoshitake Created.
