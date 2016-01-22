require "socket"

server = TCPServer.new "localhost", 2000 # Server bind to port 2000

def parse_method_path_params(client)
  line = client.gets
  method, path_and_params, _ = line.split
  path, params = path_and_params.split("?")
  [method, path, params]
end

def parse_headers(client)
  while line = client.gets
    client.puts line.chomp
    break if line =~ /^\s*$/
  end
end

class Request
  def initialize(client_request:)
    @client_request = client_request

    # run in initialize so that they happen in the right order and get memoized
    verb_path_params
    headers
    body
  end

  attr_reader :client_request

  def verb_path_params
    @verb_path_params ||= client_request.gets
  end

  def verb
    verb_path_params.split[0]
  end

  def path
    verb_path_params.split[1].split("?", 2)[0]
  end

  def params
    if params = verb_path_params.split[1].split("?", 2)[1]
      params.split("&")
    end
  end

  def headers
    @headers ||= begin
      headers = {}
      while line = client_request.gets
        key, value = line.split(":", 2)
        headers[key] = value.strip if key.strip != ""
        break if line =~ /^\s*$/
      end
      headers
    end
  end

  def body
    @body ||= begin
      if headers.has_key? "Content-Length"
        if (content_length = headers["Content-Length"].to_i) > 0
          client_request.read(content_length)
        end
      end
    end
  end
end

loop do
  request = Request.new(client_request: server.accept)

  request.client_request.puts "HTTP/1.1 200 OK"
  request.client_request.puts
  request.client_request.puts request.verb
  request.client_request.puts request.path
  request.client_request.puts request.params if request.params
  request.client_request.puts request.headers.inspect if request.headers.keys.size > 0
  request.client_request.puts request.body if request.body

  request.client_request.close
end
