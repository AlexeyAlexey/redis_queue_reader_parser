defmodule RedisQueueReaderParser.Parsers do
  use Timex
  
  
  def res_to_map_for_render_partial_action_view( :undefined ) do
    [%{}, :undefined]
  end
  def res_to_map_for_render_partial_action_view( :no_connection ) do
    [%{}, :no_connection]
  end
  def res_to_map_for_render_partial_action_view( res ) do 
    #return map
    res_to_map = :jsx.decode(res, [:return_maps])
    [res_to_map | res]
  end
  
  ####
  #process_action_controller
  ####
  def read_from_redis_json_action_controller_loggers?() do
    true
  end
  def parse_json_action_controller_loggers(res) do
    response_json_to_map(res)
    |> convert_map_for_action_controller_loggers_table
    |> write_to_db
  end
  def response_json_to_map( :undefined ) do
    %{}
  end
  def response_json_to_map( :no_connection ) do
    %{}
  end
  def response_json_to_map( res ) do 
    #return map
    :jsx.decode(res, [:return_maps])
  end
  def convert_map_for_action_controller_loggers_table(json) when json == %{} do
   []
  end
  def convert_map_for_action_controller_loggers_table(json) do
      #json_str = "{\"name\":\"process_action.action_controller\",\"payload\":{\"controller\":\"WelcomeController\",\"action\":\"index\",\"params\":{\"controller\":\"welcome\",\"action\":\"index\"},\"format\":\"html\",\"method\":\"GET\",\"path\":\"/\",\"status\":200,\"view_runtime\":1525.7584779999995,\"db_runtime\":642.8488560000003,\"user_id\":2,\"log_unique_id\":\"2163658047998db73fdf00059b931453100275\",\"remote_ip\":\"127.0.0.1\",\"request_user_agent\":\"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36\",\"request_from_page\":\"\",\"session_id\":\"96cbc8ea2291fb7570cec367e137535e\",\"body_response\":\"\",\"request_headers\":\"\"},\"time\":\"2016-01-18T08:57:55+02:00\",\"transaction_id\":\"981019b65417085881c9\",\"end\":\"2016-01-18T08:57:58+02:00\",\"duration\":2669.970255}"
      
      #json = :jsx.decode(json_str, [:return_maps])
      {:ok, date_time} = Timex.parse(json["time"], "{ISO:Extended}")
      date_time_str = DateTime.to_string Timezone.convert(date_time, "UTC")

      json_payload = json["payload"] |> Map.drop(["body_response", "request_headers"])

      json_db = Map.put(json, "payload", json_payload)

      [ "action_controller_loggers",  [log_unique_id: json["payload"]["log_unique_id"],
                                       user_id:      json["payload"]["user_id"],
                                       session_id:   json["payload"]["session_id"],
                                       request_user_agent: json["payload"]["request_user_agent"],
                                       request_headers:    json["payload"]["request_headers"],
                                       request_from_page:  json["payload"]["request_from_page"],
                                       controller:         json["payload"]["controller"],
                                       action:             json["payload"]["action"],
                                       status:             json["payload"]["status"],
                                       start_time:    date_time_str, 
                                       remote_ip:     json["payload"]["remote_ip"], 
                                       duration:      json["duration"], 
                                       view_runtime:  json["payload"]["view_runtime"],
                                       db_runtime:    json["payload"]["db_runtime"],
                                       process:       :jsx.encode(json_db),
                                       body_response: json["payload"]["body_response"]
                                      ]
      ]
    end

  ####
  #render_partial_action_view
  ####
  def read_from_redis_json_render_partial_action_view?() do
    true
  end
  def parse_json_render_partial_action_view(res) do
    res_to_map_for_render_partial_action_view(res)
    |> convert_map_for_render_partial_action_view
    |> write_to_db
  end
  def convert_map_for_render_partial_action_view([map_json | _string_from_redis]) when map_json == %{} do
    []
  end
  def convert_map_for_render_partial_action_view([map_json | string_from_redis]) do
    #map_json_string_from_redis = [map_json, string_from_redis]
    #string_from_redis = "{\"name\":\"render_partial.action_view\",\"payload\":{\"identifier\":\"/vagrant/redmine/app/views/admin/_menu.html.erb\",\"log_unique_id\":\"129827603298a5fe7d1172327aec1465219928\"},\"time\":\"2016-06-06T13:32:12+00:00\",\"transaction_id\":\"6a42494881ed53fc5d03\",\"end\":\"2016-06-06T13:32:13+00:00\",\"duration\":277.511038}"
    #map_json = :jsx.decode(json_str, [:return_maps])

    #[map_json | string_from_redis] = map_json_string_from_redis
    {:ok, date_time} = Timex.parse(map_json["time"], "{ISO:Extended}")
    date_time_str = DateTime.to_string Timezone.convert(date_time, "UTC")

    log_unique_id  = map_json["payload"]["log_unique_id"]
    duration       = map_json["duration"]

      

    [ "action_view_loggers",  [log_unique_id: log_unique_id,
                               start_time: date_time_str,
                               duration: duration,
                               process:  string_from_redis
                              ]
    ]
  end

  ####
  #render_template_action_view
  ####
  def read_from_redis_json_render_template_action_view?() do
    true
  end
  def parse_json_render_template_action_view(res) do
    res_to_map_for_render_partial_action_view(res)
    |> convert_map_for_render_template_action_view
    |> write_to_db
  end
  def convert_map_for_render_template_action_view([map_json | _string_from_redis]) when map_json == %{} do
    []
  end
  def convert_map_for_render_template_action_view([map_json | string_from_redis]) do
    #map_json_string_from_redis = [map_json, string_from_redis]
    #string_from_redis = "{\"name\":\"render_partial.action_view\",\"payload\":{\"identifier\":\"/vagrant/redmine/app/views/admin/_menu.html.erb\",\"log_unique_id\":\"129827603298a5fe7d1172327aec1465219928\"},\"time\":\"2016-06-06T13:32:12+00:00\",\"transaction_id\":\"6a42494881ed53fc5d03\",\"end\":\"2016-06-06T13:32:13+00:00\",\"duration\":277.511038}"
    #map_json = :jsx.decode(json_str, [:return_maps])

    #[map_json | string_from_redis] = map_json_string_from_redis

    {:ok, date_time} = Timex.parse(map_json["time"], "{ISO:Extended}")
    date_time_str = DateTime.to_string Timezone.convert(date_time, "UTC")

    log_unique_id  = map_json["payload"]["log_unique_id"]
    duration       = map_json["duration"]

      

    [ "action_view_loggers",  [log_unique_id: log_unique_id,
                               start_time: date_time_str,
                               duration: duration,
                               process:  string_from_redis
                              ]
    ]
  end

  ####
  #logstash
  ####
  def read_from_redis_json_logstash?() do
    true
  end
  def parse_json_logstash(res) do
    res_to_map_for_render_partial_action_view(res)
    |> convert_map_for_json_logstash
    |> write_to_db
  end
  def convert_map_for_json_logstash([map_json | _string_from_redis]) when map_json == %{} do
    []
  end
  def convert_map_for_json_logstash([map_json | string_from_redis]) do
    #map_json_string_from_redis = [map_json, string_from_redis]
    #string_from_redis = "{\"message\":\"WatcherGroupsWatcherHelperPatch monkey-patch\",\"@timestamp\":\"2016-08-19T07:31:14.565+00:00\",\"@version\":\"1\",\"severity\":\"INFO\",\"host\":\"vagrant-ubuntu-trusty-64\",\"log_unique_id\":\"18344780f1fc1da6d3aec520aacb1471591867\",\"session_id\":\"\",\"user_id\":\"\"}\n"
    #map_json = :jsx.decode(json_str, [:return_maps])


    log_unique_id  = map_json["log_unique_id"]

    {:ok, date_time} = Timex.parse(map_json["@timestamp"], "{ISO:Extended}")
    date_time_str    = DateTime.to_string Timezone.convert(date_time, "UTC")

    session_id = map_json["session_id"]
    user_id    = map_json["user_id"]
    severity   = map_json["severity"]

    [ "json_logstashs",  [log_unique_id: log_unique_id,
                          start_time: date_time_str,
                          session_id: session_id,
                          user_id: user_id,
                          severity: severity,
                          process: string_from_redis
                         ]
    ]
  end


  ####
  # DB
  ####
  def write_to_db( name_of_table_and_list_of_params ) when name_of_table_and_list_of_params == [] do
   []
  end
  def write_to_db(name_of_table_and_list_of_params) do

    db_pid = :poolboy.checkout(:write_into_db_pool)
    GenServer.cast(db_pid, {:write_into_db, name_of_table_and_list_of_params})
    :poolboy.checkin(:write_into_db_pool, db_pid)
    #[name_of_table | list_of_params] = name_of_table_and_list_of_params
    #RedisQueueReaderParser.Repo.insert_all(name_of_table, list_of_params)
  end 
end