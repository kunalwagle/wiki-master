var pg = require('pg');
var connectionString = process.env.DATABASE_URL || 'postgres://g1427127_u:X3s8Llhgo2@db.doc.ic.ac.uk:5432/g1427127_u';

var client = new pg.Client(connectionString);
client.connect();
var query = client.query('CREATE TABLE users(id SERIAL PRIMARY KEY, username VARCHAR(40) not null, password VARCHAR(40) not null, score INTEGER)');
query.on('end', function() { client.end(); });
