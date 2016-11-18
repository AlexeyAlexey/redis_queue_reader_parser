defmodule RedisQueueReaderParser.RailsParsers do
  use Timex
#1
  def read_from_redis?() do
    true
  end
#2
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
#3
  def check_project_id(json) when json == %{} do
    recognize_structure(%{}, 0)
  end
  def check_project_id(json) do
    #https://saratchandra.in/post/hmac_in_elixir/
    case {:ok, json["project_id"]} do
       {:ok, nil} ->
         recognize_structure(%{}, 0)
       {:ok, project_id} ->
         recognize_structure(json, project_id)
       _ -> 
         recognize_structure(%{}, 0)
    end
  end

  def recognize_structure(json, _project_id) when json == %{} do
   []
  end
  def recognize_structure(json, project_id) when json["name"] == "process_action.action_controller" do
  	%{"name"    => "process_action.action_controller", 
      "payload" => payload,
       "time"   => time,
       "transaction_id" => transaction_id, 
       "end"        => end_,
       "duration"   => duration, 
       "@timestamp" => timestamp, 
       "@version"   => version, 
       "severity"   => severity, 
       "host"       => host, 
       "request_unique_id" => request_unique_id, 
       "project_id"        => project_id} = json

    %{"controller" => controller, 
      "action"     => action, "params" => params, 
      "format"     => format, "method" => method,
      "path"       => path,   "status" => status,
      "view_runtime" => view_runtime, 
      "db_runtime"   => db_runtime,
      "ip"           => ip,     
      "user_id"      => user_id,
      "session_id"   => session_id, 
      "http_user_agent" => http_user_agent, 
      "headers"         => headers} = payload

      %{"HTTP_USER_AGENT" => http_user_agent, 
        "HTTP_REFERER"    => http_referer} = headers

      get_table_name(project_id, 0)
   	
  end
  def recognize_structure(json, project_id) when json["message"] do
    %{"message"    => message,
      "@timestamp" => timestamp, 
      "@version"   => version,
      "severity"   => severity,
      "host"       => severity,
      "request_unique_id" => request_unique_id,
      "project_id"        => project_id} = json

    get_table_name(project_id, 1)
  end
  def recognize_structure(_json, _project_id) do
    []
  end

  def get_table_name(project_id, 0) do
    ""
  end

  def get_table_name(project_id, 1) do
    ""
  end

  ####
  # DB
  ####
#4
  def write_into_db( name_of_table_and_list_of_params ) when name_of_table_and_list_of_params == [] do
   []
  end
  def write_into_db(name_of_table_and_list_of_params) do

    db_pid = :poolboy.checkout(:write_into_db_pool)
    GenServer.cast(db_pid, {:write_into_db, name_of_table_and_list_of_params})
    :poolboy.checkin(:write_into_db_pool, db_pid)
    #[name_of_table | list_of_params] = name_of_table_and_list_of_params
    #RedisQueueReaderParser.Repo.insert_all(name_of_table, list_of_params)
  end 


end