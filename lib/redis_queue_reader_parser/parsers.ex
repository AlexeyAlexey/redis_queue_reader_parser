defmodule RedisQueueReaderParser.Parsers do
  use Timex
  
  def parse_json_action_controller_loggers(res) do
  	response_json_to_map(res)
  	|> convert_map_for_action_controller_loggers_table
  	|> write_to_db
  end

  def response_json_to_map( :undefined ) do
  	 :timer.sleep(1000)
     %{}
  end

  def response_json_to_map( res ) do 
    #return map
    :jsx.decode(res, [:return_maps])
  end

  defp write_to_db( name_of_table_and_list_of_params ) when name_of_table_and_list_of_params == %{} do
   %{}
  end
  defp write_to_db(name_of_table_and_list_of_params) do

    [name_of_table | list_of_params] = name_of_table_and_list_of_params
    RedisQueueReaderParser.Repo.insert_all(name_of_table, list_of_params)
  end

  def convert_map_for_action_controller_loggers_table(json) when json == %{} do
   %{}
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


end