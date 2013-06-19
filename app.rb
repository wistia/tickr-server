require 'sinatra'

require './boot'

require './lib/database_connection'
require './lib/ticket'

get '/status' do
  {
    'last_ticket' => Ticket.last.id
  }.to_json
end

get '/tickets/create' do
  [Ticket.new.id].to_json
end

get '/tickets/create/:num_tickets' do
  (1..params[:num_tickets].to_i).inject([]) do |result, t|
    result << Ticket.new.id
  end.to_json
end
