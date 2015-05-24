var pg = require('pg');
var connectionString = process.env.DATABASE_URL || 'postgres://localhost:5432/wikimasterdb';

var client = new pg.Client(connectionString);
client.connect();
var query = client.query('CREATE TABLE users(id SERIAL PRIMARY KEY, username VARCHAR(40) not null, password VARCHAR(40) not null, score INTEGER)');
query.on('end', function() { client.end(); });