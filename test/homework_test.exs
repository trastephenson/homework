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

  test "entry ad" do
    navigate_to ("https://the-internet.herokuapp.com/entry_ad") 
    Process.sleep(500)    #letting page load 
    ad = find_element(:id, "modal")   #locate entry ad
    close_button = find_within_element(ad, :class, "modal-footer")    #locate close link
    assert element_displayed?(ad) == true   #assert that ad is displayed
    :timer.sleep(500) 
    click(close_button)   #clicks close link (really any click will close the ad) 
    :timer.sleep(500)
    
    if assert element_displayed?(ad) == false do    #assert that ad has closed 
    
    else   
      Process.sleep(500)    #wait a bit more
      assert element_displayed?(ad) == false    #continue x amount of times need to write in a how many times look for that. 
    end
  end   

  test "image_links_working" do
    navigate_to ("https://the-internet.herokuapp.com/broken_images")
    Img_search.find_broken_img_url # Finds all img links, asserts broken_url string is empty, failure lists broken URL's for fixing.
  end

  test "image_links_working_alt" do
    navigate_to ("https://the-internet.herokuapp.com/broken_images")
      Process.sleep(1000)   #gives page time to load
      elements = find_all_elements(:tag, "img")   #gets all img uuid's on page

      img_links = Enum.map(elements, fn x ->    #converts uuid's string into img source links
        link = attribute_value(x,"currentSrc")
        end)

      log = fetch_log()   #found fetch log after hitting wall on 1st iteration above.  Got stale element error and couldn't get it to navigate to each link.
      
      split_log = String.split(log)   #my work around was to use the log to look for any img links.  I split it cause the string was big

      broken_img =Enum.filter(split_log, fn x ->    #using this function let me filter out the broken links into a string (2 links were broken)
        String.contains?(x, ".jpg")
      end)
    
      img_compare = Enum.filter(img_links, fn x ->    #used the same function to see if any of the img_links were contained in the broken_img, returned (2 broken links) 
      String.contains?(x, broken_img)
      end)    

      refute broken_img === img_compare, 
      "expected result is false all links working, but if broken img(s) present the links are: #{broken_img} #{take_screenshot()}"   #a match would mean there are broken links present
     
    if broken_img != img_compare do
    end
  end
end