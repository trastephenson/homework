defmodule Img_search do
    use Hound.Helpers
    import ExUnit.Assertions

    def find_broken_img_url do
        broken_url = find_all_elements(:tag, "img")
            |> Enum.map( fn x ->    #converts uuid's string into img source links
               attribute_value(x,"currentSrc")
               end)
            |> Enum.filter( fn url ->     
               Process.sleep(500)
               navigate_to(url)        #navigates to all img url's
               Process.sleep(500)
               String.contains?(visible_page_text(), "Not Found")    #filters all url's that have "not found" into string    
               end)
        assert Enum.empty?(broken_url),"This test fails if any img links are found broken!:
                                       \n The number of broken URL's is: #{Enum.count(broken_url)}
                                       \n Img URL's that need to be fixed: 
                                       \n #{broken_url} 
                                       \n screenshot has been saved to: 
                                       \n #{take_screenshot()}"   #empty string = working links otherwise test fails and gives you list of all broken links to fix.       
    end


# ***DEPRECIATED*** due to error_log_img_check accomplishing same result  
#   def find_broken_img_url_alt do  
#       broken_img_urls = find_all_elements(:tag, "img")
#          |> Enum.map( fn x ->    #converts uuid's string into img source links
#             attribute_value(x,"currentSrc")
#             end)
#          |> Enum.filter( fn x ->    #used the same function to see if any of the img_links were contained in the broken_img, returned (2 broken links) 
#             String.contains?(x, error_log)
#             end)
#       assert broken_img_urls != error_log,"This test fails if img url's are found in the log: \n These are the broken links so they can be fixed: \n #{broken_img_urls} \n screenshot has been saved to: \n #{take_screenshot()}" 
#     end

    @img_types [".jpg", ".png", ".gif", ".svg", "webp", ".jpeg", ".bmp", ".tiff"] # defined what img file types needed to be checked in error_log

    def error_log_img_check do  
    log = fetch_log()
         |> String.split
         |> Enum.filter( fn x ->    
            String.contains?(x, @img_types)  # searches error log for img file extensions if present they are broken.  Test fails and it gives img url's to be fixed.
            end)    
    assert Enum.empty?(log),"The error log was checked for img urls and unfortunately found some!:
                            \n The number of broken URL's is: #{Enum.count(log)}
                            \n Img URL's that need to be fixed:
                            \n #{log}\n screenshot has been saved to: 
                            \n #{take_screenshot()}" #empty log = img links working otherwise test fails and gives you list of all broken links to fix.
    end
end  