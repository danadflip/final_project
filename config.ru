require 'sinatra/namespace'
require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/json'
require 'rest_client'
require 'redis'
require 'uri'
require 'pry'
require 'httparty'
require 'json'

require_relative 'server'

run Drive::Server
