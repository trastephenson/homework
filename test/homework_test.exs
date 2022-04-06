defmodule HomeworkTest do
  # Import helpers
  use Hound.Helpers
  use ExUnit.Case

  import Helpers
  import Keymaster

  hound_session()

  
  test "key presses" do
    navigate_to("https://the-internet.herokuapp.com/key_presses")
 
    Keymaster.tap_key   #runs from keymaster module  
  
  end





  test "Notice Msg" do
    navigate_to("https://the-internet.herokuapp.com/notification_message_rendered")
    Process.sleep(1000)   #page load wait
    Helpers.msg_gen   #generates 1st notice msg
    element = find_element(:id, "flash")
    original_msg = visible_text(element)    #need to capture 1st msg to use it as comparison to stop loop
    
    if Helpers.msg_gen != original_msg do   #loop until messages repeat
       Helpers.msg_gen
    else 
      IO.puts "Stop once messages repeat!"
    end
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
      IO.puts("Test Successful")
    
    else   
      Process.sleep(500)    #wait a bit more
      assert element_displayed?(ad) == false    #continue x amount of times need to write in a how many times look for that. 
    end
  end   




  test "broken images" do
    navigate_to ("https://the-internet.herokuapp.com/broken_images")
    Process.sleep(1000)   #gives page time to load
    elements = find_all_elements(:tag, "img")   #gets all img uuid's on page

    img_url_links = Enum.map(elements, fn x ->    #converts uuid's string into img source links
      link = attribute_value(x,"currentSrc")
      end)

    broken_img_urls = Enum.filter(img_url_links, fn url ->     
      Process.sleep(500)
      navigate_to(url)        #navigates to all img url's
      Process.sleep(500)
      String.contains?(visible_page_text(), "Not Found")    #filters all url's that have "not found" into string    
      end) 

    assert Enum.empty?(broken_img_urls), 
    "expected result is empty [] all links working, but if broken img(s) present the links are: #{broken_img_urls} #{take_screenshot()}"   #empty string = working links
        
    IO.puts("All Images are working!")
    
    end 

  
  
  
  
  test "broken images2" do
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
      IO.puts("All Images are working!")
    
    end
  end
end