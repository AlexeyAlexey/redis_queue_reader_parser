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


1)
```elixir
RedisQueueReader.Manager.init_reader("process_action_controller", [ &RedisQueueReaderParser.Parsers.read_from_redis_json_action_controller_loggers/0, &RedisQueueReaderParser.Parsers.parse_json_action_controller_loggers/1 ] )
```


2) 
```elixir
RedisQueueReader.Manager.start_new_reader("process_action_controller")
```

3) 
```elixir
RedisQueueReader.Manager.stop_reader_of("process_action_controller")
```

4) 
```elixir
RedisQueueReader.Manager.destroy_all_readers_without_check_child("process_action_controller")
```

5) 
```elixir
RedisQueueReader.Manager.list_of_init_readers => ["queue_3", "queue_2", "process_action_controller"]
```


**process_action_controller:** 
```elixir
  RedisQueueReader.Manager.init_reader("process_action_controller", [ &RedisQueueReaderParser.Parsers.read_from_redis_json_action_controller_loggers?/0, &RedisQueueReaderParser.Parsers.parse_json_action_controller_loggers/1 ] )

  RedisQueueReader.Manager.start_new_reader("process_action_controller")

```

**render_template_action_view:** 
```elixir
  RedisQueueReader.Manager.init_reader("render_template_action_view", [ &RedisQueueReaderParser.Parsers.read_from_redis_json_render_template_action_view?/0, &RedisQueueReaderParser.Parsers.parse_json_render_template_action_view/1 ] )

  RedisQueueReader.Manager.start_new_reader("render_template_action_view")
```

**render_partial_action_view:**
```elixir
  RedisQueueReader.Manager.init_reader("render_partial_action_view", [ &RedisQueueReaderParser.Parsers.read_from_redis_json_render_partial_action_view?/0, &RedisQueueReaderParser.Parsers.parse_json_render_partial_action_view/1 ] )

  RedisQueueReader.Manager.start_new_reader("render_partial_action_view")
```

**logstash:**
```elixir
  RedisQueueReader.Manager.init_reader("logstash", [&RedisQueueReaderParser.Parsers.read_from_redis_json_logstash?/0 ,  &RedisQueueReaderParser.Parsers.parse_json_json_logstash/1 ] )

  RedisQueueReader.Manager.start_new_reader("logstash")
```