defmodule Help do
  use Hound.Helpers


  def msg_string do
    element = visible_text({:id, "flash"})
     # %Help.Notice_msg{message: element}
  end

  def msg_gen_click do
    click({:link_text, "Click here"})
  end  

  def notice_msg_get(retry_count \\ 10) do
    #get_msg_link = find_element(:link_text, "Click here")
    msg_gen_click
    Process.sleep(300)
    msg_string
   if retry_count > 0 do
      retry_count = retry_count - 1
      notice_msg_get(retry_count)
    end 
  end

  # def has_duplicates?.%Help.Notice_msg do
  #  %Help.Notice_msg
  #  |> Enum.reduce_while(%MapSet{}, fn x, acc ->
  #     if MapSet.member?(acc, x), do: {:halt, false}, else: {:cont, MapSet.put(acc, x)}
  #     end)
  #  |> is_boolean()
  # end
  # def notice_msg_get when has_duplicates?(false)  do
  #  retry_count = 1 
  # end
end   
 
 
 