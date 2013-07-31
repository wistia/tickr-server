require 'sinatra'

require './boot'

require './lib/database_interface'
require './lib/ticket'
require './lib/ticket_group'

before {protect! unless APP_CONFIG[:http_auth_password].blank?}

get '/status' do
  {
    'last_ticket' => Ticket.last.id
  }.to_json
end

get '/tickets/create' do
  [Ticket.new.id].to_json
end

get '/tickets/create/:num_tickets' do
  TicketGroup.new(params[:num_tickets]).group.to_json
end

private
def authorized?
  auth = Rack::Auth::Basic::Request.new(request.env)
  auth.provided? && auth.basic? && auth.credentials && auth.credentials[1] == APP_CONFIG[:http_auth_password]
end
def protect!
  return if authorized?
  headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
  halt 401, 'Not authorized\n'
end
