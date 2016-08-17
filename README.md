Developing

# RedisQueueReaderParser

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `redis_queue_reader_parser` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:redis_queue_reader_parser, "~> 0.1.0"}]
    end
    ```

  2. Ensure `redis_queue_reader_parser` is started before your application:

    ```elixir
    def application do
      [applications: [:redis_queue_reader_parser]]
    end
    ```



0) iex --name redis_queue_reader_parser@127.0.0.1 --cookie 123  -S mix run


1) RedisQueueReader.Manager.init_reader("queue_1", [ &RedisQueueReaderParser.Parsers.parse_json_action_controller_loggers/1 ] )

OR

RedisQueueReader.Manager.init_reader("queue_1", [ &RedisQueueReaderParser.Parsers.response_json_to_map/1, &RedisQueueReaderParser.Parsers.convert_map_for_action_controller_loggers_table/1,  &RedisQueueReaderParser.Parsers.write_to_db/1] )



2) RedisQueueReader.Manager.start_new_reader("queue_1")

3) RedisQueueReader.Manager.stop_reader_of("queue_1")

4) RedisQueueReader.Manager.destroy_all_readers_without_check_child("queue_1")

5) RedisQueueReader.Manager.list_of_init_readers => ["queue_3", "queue_2", "queue_1"]
