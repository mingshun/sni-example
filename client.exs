defmodule SSLClient do
  def connect do
    :ssl.start

    {:ok, socket} = :ssl.connect '0.0.0.0', 443, [{:server_name_indication, 'example.com'},{:versions, [:"sslv3"]},{:active, :false}], :infinity
    {:ok, data} = :ssl.recv socket, 0
    IO.puts data
    :ssl.close socket

    {:ok, socket} = :ssl.connect '0.0.0.0', 443, [{:server_name_indication, 'example.net'},{:active, :false}], :infinity
    {:ok, data} = :ssl.recv socket, 0
    IO.puts data
    :ssl.close socket
  end
end
