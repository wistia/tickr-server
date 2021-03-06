# Tickr

Tickr is a distributed, decentralized, MySQL-backed 64-bit ID generation system
based in part on [Flickr's ticketing implementation](http://code.flickr.net/2010/02/08/ticket-servers-distributed-unique-primary-keys-on-the-cheap/).

There are a few major differences from Flickr's implementation. They are:

1. Rather than rely on MySQL to increment by a particular value, or maintain
some starting offset, MySQL will increment by way of an UPDATE query. This
decision was made because (1) MySQL increment amounts are set globally, and we
want to allow this ticketing system to operate on databases that serve other
applications as well, without requiring them to conform to a non-standard
auto_increment configuration; and (2) we desire support for creating batches of
tickets, and it is cheaper to generate a batch of size _n_ with one query than
with _n_ queries.

1. Tickets can be created in batches so that client applications can retrieve
IDs asynchronously for network-free inserts.

1. Batches of tickets are represented not by their literal IDs, but by
a small JSON structure that maps to a [potentially large] set of tickets.

The JSON structure for a group of tickets looks like this:

    {
      'first': 25,
      'increment': 5,
      'count': 5
    }

This example structure would map to the following array of tickets:

    [25, 30, 35, 40, 45]

## Creating tickets

Tickets are created via HTTP GET requests. To get a single ticket, run:

    GET /tickets/create

The response body will be a single-element JSON array containing the new ticket, e.g. `[54313001]`.

To generate a batch of 5 tickets, run:

    GET /tickets/create/5

If TICKR_MAX_NODES were 4 in our earlier example, this would return

    {
      'first': 54313005,
      'increment': 4,
      'count': 5
    }

which maps to `[54313005,54313009,54313013,543130017,543130021]`.

## Monitoring

Tickr supports a `GET /status` route that returns a response code of 200 to verify the application is running. The status body is a JSON hash with a `last_ticket` key, which maps to the last ticket that was generated.

## Environment variables

Tickr insists that you set a few environment variables.

### Database Configuration

Use the following environment variables to configure Tickr's MySQL 5 database connection:

* `TICKR_DATABASE_HOST`
* `TICKR_DATABASE_USERNAME`
* `TICKR_DATABASE_PASSWORD`
* `TICKR_DATABASE_NAME`
* `TICKR_DATABASE_POOL_SIZE` is the number of concurrent connections in the database pool.
* `TICKR_DATABASE_POOL_TIMEOUT` is the maximum  time the database pool will block before raising a `Timeout::Errror`.

### Application Configuration

Required configurations:

* `TICKR_MAX_NODES` is the maximum number of nodes you want your tickr cluster to
support. This cannot be changed once your system goes live.
* `TICKR_STARTING_OFFSET` is the first ID you wish to provide. This is useful if
you've been providing auto_increment IDs in your app, and are just now moving to
tickr. If your last auto_increment ID is 1,000,000, you could start tickr with
an offset of 1,000,001. This cannot be changed once your system goes live.
* `TICKR_NODE_NUMBER` is the 0-indexed node of the cluster.

Optional configurations:

* `TICKR_HTTP_AUTH_PASSWORD` if set, is a password to be used for HTTP BASIC
authentication. This is useful if your server is exposed through a public
network interface.

## Getting Started

### Development

After setting your environment variables as specified, create your database with:

`rake db:create`

Run the spec suite and be sure your tests pass:

`rake spec`

Start your server with:

`rackup` or `unicorn -E development`

### Production

After setting your environment variables as specified, create your database with:

`RACK_ENV=production rake db:create`

Start your server with:

`unicorn -E production`
