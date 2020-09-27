defmodule Rabbit do
  def openConnection do
    options = [host: "localhost", port: 5672, virtual_host: "/", username: "guest", password: "guest"]
    {:ok, connection} = AMQP.Connection.open(options)
    connection
  end

  # def getChannel(connection) do
  #   {:ok, channel} = AMQP.Channel.open(connection)
  #   channel
  # end

  @spec getChannel :: %{channel: AMQP.Channel.t(), connection: AMQP.Connection.t()}
  def getChannel() do
    connection = openConnection()
    {:ok, channel} = AMQP.Channel.open(connection)
    %{channel: channel, connection: connection}
  end

  def close(connection) do
    AMQP.Connection.close(connection)
  end
  def getQueue(queueName) do
    test = getChannel()
    #AMQP.Exchange.declare(test.channel,"delay-exchange", :"x-delayed-message",durable: true, auto_delete: false, arguments: [ "x-delayed-type": "direct"] )
    AMQP.Queue.declare(test.channel, queueName, durable: true)
    AMQP.Queue.bind(test.channel, queueName, "delay-exchange", routing_key: queueName)
    close(test.connection)
  end

  def sendMessage(exchange, queueName, message, delay) do
    amqp = getChannel()
    AMQP.Basic.publish(amqp.channel, exchange, queueName, message, headers: [{"x-delay", delay}], persistence: true)
    close(amqp.connection)
  end

  # def sendMessage(exchange, queueName, message, channel) do
  #   AMQP.Basic.publish(channel, exchange, queueName, message)
  # end

  def sendMultMessage(number) do
    amqp = getChannel()
    for n <- 1..number do
      jsonMessage =  %{test: n} |> Poison.encode!
      AMQP.Basic.publish(amqp.channel, "", "test", jsonMessage)
    end
    close(amqp.connection)
  end
end
