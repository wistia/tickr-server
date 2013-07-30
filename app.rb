require 'sinatra'

require './boot'

require './lib/database_interface'
require './lib/ticket'
require './lib/ticket_group'

use Rack::Auth::Basic, 'Restricted' do |username, password|
  APP_CONFIG[:http_auth_password].blank? || password == APP_CONFIG[:http_auth_password]
end

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
