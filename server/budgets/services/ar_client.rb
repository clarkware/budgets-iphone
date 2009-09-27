require 'rubygems'
require 'activeresource'
require 'highline/import'

def prompt(prompt, mask=true)
  ask(prompt) { |q| q.echo = mask}
end

ActiveResource::Base.logger = 
  Logger.new("#{File.dirname(__FILE__)}/active_resource.log")

class Budget < ActiveResource::Base
  login = prompt('Login: ')
  password = prompt('Password: ', '*')
  
  self.site = "http://#{login}:#{password}@localhost:3000/"
end

budgets = Budget.find(:all)
puts budgets.map(&:name)

