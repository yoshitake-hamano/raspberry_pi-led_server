#!/usr/bin/env ruby

# File: raspberrypi_ruby_webio.rb - last edit
# yoshitake 07-Jan-2015

require 'webrick'

class RaspberrypiRubyWebio
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

  def on
    open(GPIO_TARGET_VALUE, "w") do |io|
      io.print("1")
    end
  end

  def off
    open(GPIO_TARGET_VALUE, "w") do |io|
      io.print("0")
    end
  end
end

webio = RaspberrypiRubyWebio.new

server = WEBrick::HTTPServer.new(:Port =>8000)
server.mount_proc('/on') do |req, res|
  webio.on
end

server.mount_proc('/off') do |req, res|
  webio.off
end

trap('INT') { server.shutdown }
server.start

# Log
# 07-Jan-2015 yoshitake Created.
