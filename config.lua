-- change to match with your database --
ip = GetConvar('trp_couchdb_url', '127.0.0.1')
port = GetConvar('trp_couchdb_port', '5984')
auth = GetConvar('trp_couchdb_password', 'root:1202') --"user:password" (only change if you have auth setup)
metrics = GetConvar('trp_enable_metrics', '1')