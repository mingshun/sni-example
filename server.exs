defmodule SSLServer do
  def start do
    :ssl.start
    {:ok, ssocket} = :ssl.listen 443, [{:reuseaddr, :true},{:sni_fun, &sni_fun/1}]
    loop(ssocket)
  end

  defp loop(ssocket) do
    {:ok, socket} = :ssl.transport_accept ssocket
    :ssl.ssl_accept socket, :infinity
    IO.puts inspect(:ssl.connection_information socket)
    :ssl.send socket, "hello"
    loop(ssocket)
  end

  defp sni_fun(server_name) do
    case server_name do
      'example.net' ->
        [
          {:certfile, 'example.net.crt'},
          {:keyfile, 'example.net.key'},
          {:ciphers, [{:ecdhe_rsa, :aes_128_gcm, :null}]},
          {:versions, [:"tlsv1.2"]}
        ]
      'example.com' ->
        [
          {:certfile, 'example.com.crt'},
          {:keyfile, 'example.com.key'},
          {:ciphers, [{:dhe_rsa, :aes_128_cbc, :sha}]},
          {:honor_cipher_order, :true},
          {:versions, [:"sslv3"]}
        ]
      _ -> nil
    end
  end
end
