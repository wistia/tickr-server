# Tickr

Tickr is a distributed, decentralized, MySQL-backed 64-bit ID generation system
based on [Flickr's ticketing implementation](http://code.flickr.net/2010/02/08/ticket-servers-distributed-unique-primary-keys-on-the-cheap/).

One major difference from Flickr's implementation is that rather than rely on
MySQL to increment by a particular value, or maintain some starting offset,
MySQL will autoincrement as usual and our application interface will provide
the arithmetic to adjust it accordingly. This decision was made because MySQL
increment amounts are set globally, and we want to allow this ticketing system
to operate on databases that serve other applications as well, without requiring
them to conform to a non-standard auto_increment configuration.

## Environment variables

Tickr insists that you set a few environment variables.

### Database Configuration

Use the following environment variables to configure Tickr's MySQL 5 database connection:

* `TICKR_DATABASE_HOST`
* `TICKR_DATABASE_USERNAME`
* `TICKR_DATABASE_PASSWORD`
* `TICKR_DATABASE_NAME`

### Application Configuration

* `TICKR_MAX_NODES` is the maximum number of nodes you want your tickr cluster to
support. This cannot be changed once your system goes live.
* `TICKR_STARTING_OFFSET` is the first ID you wish to provide. This is useful if
you've been providing auto_increment IDs in your app, and are just now moving to
tickr. If your last auto_increment ID is 1,000,000, you could start tickr with
an offset of 1,000,001. This cannot be changed once your system goes live.
* `TICKR_NODE_NUMBER` is the 0-indexed node of the cluster.

## Getting Started

### Development

After setting your environment variables as specified, create your database with:

`rake db:create`

Run the spec suite and be sure your tests pass:

`rake spec`

### Production

After setting your environment variables as specified, create your database with:

`rake db:create`