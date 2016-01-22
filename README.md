# Ruby web server

Me learning how to build a web server with Ruby.

In one terminal clone this repo, cd into the directory, and then run:

```bash
$ ruby server.rb
```

In another terminal use curl to send a request to the server:

```bash
$ curl -d "hello world" http://localhost:2000?foo=bar
```

And you should get back something like this:

```
POST
/
foo=bar
{"Host"=>"localhost:2000", "User-Agent"=>"curl/7.43.0", "Accept"=>"*/*", "Content-Length"=>"11", "Content-Type"=>"application/x-www-form-urlencoded"}
hello world
```
