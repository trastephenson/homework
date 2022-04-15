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
        assert Enum.empty?(broken_url),"This test fails if any img links are broken! Here are the broken links so they can be fixed: \n #{broken_url} \n screenshot has been saved to: \n #{take_screenshot()}"   #empty string = working links       
    end


   # def find_broken_img_url_alt do
   #    broken_img_urls = find_all_elements(:tag, "img")
   #       |> Enum.map( fn x ->    #converts uuid's string into img source links
   #          attribute_value(x,"currentSrc")
   #          end)
   #       |> Enum.filter( fn x ->    #used the same function to see if any of the img_links were contained in the broken_img, returned (2 broken links) 
   #          String.contains?(x, log)
   #    end)
      
   #    fetch_log()
   #       |> String.split(fetch_log())
   #       |> Enum.filter( fn x ->    #using this function let me filter out the broken links into a string (2 links were broken)
   #          String.contains?(x, ".jpg")
   #          end) 
   #    assert fetch_log() != broken_img_urls, "This test fails if img links from log exist and are matchedHere are the broken links so they can be fixed: \n #{broken_img_urls} \n screenshot has been saved to: \n #{take_screenshot()}" 

   # end
end  