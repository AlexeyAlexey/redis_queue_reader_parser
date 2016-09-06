defmodule RedisQueueReaderParser.WriteIntoDb do
  use GenServer

  ####
  #External API
  def start_link(_params) do
  
    GenServer.start_link(__MODULE__, [])
  end


  #####
  # GenServer implementation


  def handle_cast({:write_into_db, name_of_table_and_list_of_params}, []) do
  	[name_of_table | list_of_params] = name_of_table_and_list_of_params

    RedisQueueReaderParser.Repo.insert_all(name_of_table, list_of_params)

  	{ :noreply, []}
  end
  

  def terminate(reason, []) do

  	#IO.inspect reason
    :ok
  end
  
end