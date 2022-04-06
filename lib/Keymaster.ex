defmodule Keymaster do
  use Hound.Helpers
 

  @alphabet Enum.concat([?0..?9, ?A..?Z, ?a..?z])   #keys
  
  def key_gen(length \\ 1) do   #Generates a random characters from @alphabet at whichever length 
    :rand.seed(:exsss, :os.timestamp())
    Stream.repeatedly(&random_char_from_alphabet/0)
    |> Enum.take(length)
    |> List.to_string()
  end
  
  def random_char_from_alphabet() do
    Enum.random(@alphabet)
  end      

  
  def tap_key (retry_count \\ 10) do    #loop that executes function until the retry count is at 0
    send_text(Keymaster.key_gen(1))
    element = find_element(:id, "result")
    result = visible_text(element)   
    IO.inspect(result)     #Shows which key is pressed 
    Process.sleep(100)
    IO.inspect(retry_count, label: :retry_count)    #Shows retry count to check if function is looping correctly (should be counting down)
    if retry_count > 0 do 
      retry_count = retry_count - 1
      tap_key(retry_count)
    else 
      IO.puts("Test Complete!")
  end
end
end

  
  
