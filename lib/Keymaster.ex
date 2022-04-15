defmodule Keymaster do
  use Hound.Helpers
  
  import ExUnit.Assertions

  @alphabet Enum.concat([?0..?9,?A..?Z])   #range of keys chosen
  
  def key_gen(length \\ 1) do   #Generates a random characters from @alphabet at whichever length 
    :rand.seed(:exsss, :os.timestamp())
    Stream.repeatedly(&random_char_from_alphabet/0)
    |> Enum.take(length)
    |> List.to_string()
  end
  
  def random_char_from_alphabet() do
    Enum.random(@alphabet)
  end      

  def compare_key_to_result (retry_count \\ 10) do    #loop that presses random key and compares it to the result until the retry count is at 0
    key = Keymaster.key_gen()
    send_text(key)
    element = find_element(:id, "result")
    result = visible_text(element)
    assert result == "You entered: #{key}", "You entered: #{key}, but result was #{result}, It did not match. Test failed."    #put assert in module so it would assert every iteration of the loop. 
    Process.sleep(100)
    if retry_count > 0 do 
      retry_count = retry_count - 1
      compare_key_to_result(retry_count)   
  end
end
end

  
  
