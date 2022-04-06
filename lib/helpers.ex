defmodule Helpers do
  use Hound.Helpers
 
  def msg_gen do
    button = find_element(:link_text, "Click here")
    
    new_msg = attribute_value(button, "text")
    
    click(button)
    
    Process.sleep(1000)
    
    element = find_element(:id, "flash")
    
    notice_msg = visible_text(element)
    
    
    IO.inspect(notice_msg)

  end
    

  
  
end