defmodule HomeworkTest do
  # Import helpers
  use Hound.Helpers
  use ExUnit.Case

  alias Help
  alias Keymaster
  alias Img_search
  
  hound_session()

  test "key presses" do
    navigate_to("https://the-internet.herokuapp.com/key_presses")
    Keymaster.compare_key_to_result   #generates random keystroke and inputs it with an assert to compare it with result output.   
  end

  test "Notice Msg" do
    navigate_to("https://the-internet.herokuapp.com/notification_message_rendered")
    Process.sleep(1000)   #page load wait
    Help.notice_msg_get
    assert element_displayed?({:id, "flash"}), "The notice message is not displaying properly. Test Failed"
  end

  test "entry ad working" do
    navigate_to ("https://the-internet.herokuapp.com/entry_ad") 
    Process.sleep(500)    #letting page load 
    ad = find_element(:id, "modal")   #locate entry ad
    close_button = find_within_element(ad, :class, "modal-footer")    #locate close link
    assert element_displayed?(ad) == true   #assert that ad is displayed
    :timer.sleep(500) 
    click(close_button)   #clicks close link (really any click will close the ad) 
    :timer.sleep(500)
    if element_displayed?(ad) == true do    #assert that ad has closed 
      click(close_button)
      :timer.sleep(500) 
      assert element_displayed?(ad) == false 
    end
  end   

  test "image_links_working" do # Test designed to fail if images are broken so they can be fixed
    navigate_to ("https://the-internet.herokuapp.com/broken_images")
    Img_search.find_broken_img_url # Finds all img links, asserts broken_url string is empty, failure lists broken URL's for fixing.
  end

  test "error_log_check for img links" do # Test designed to fail if images are broken so they can be fixed
    navigate_to ("https://the-internet.herokuapp.com/broken_images")
    Img_search.error_log_img_check  #Checks error log for img file extentions, if present the test will fail giving the Img url's found in the log which are not working. 
  end
end


