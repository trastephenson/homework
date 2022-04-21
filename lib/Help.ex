defmodule Help do
  use Hound.Helpers

  def msg_string do
    element = visible_text({:id, "flash"})
  end
  def msg_gen_click do
    click({:link_text, "Click here"})
  end  
  def notice_msg_get(retry_count \\ 10) do
    msg_gen_click()
    Process.sleep(300)
    msg_string()
   if retry_count > 0 do
      retry_count = retry_count - 1
      notice_msg_get(retry_count)
    end 
  end
end