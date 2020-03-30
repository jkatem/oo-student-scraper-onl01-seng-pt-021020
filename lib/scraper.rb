require 'open-uri'
require 'pry'

require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
   doc = Nokogiri::HTML(open(index_url))
   students = [ ]

   doc.css("div.roster-cards-container").each do |card|
     card.css(".student-card a").each do |student|
       link = "#{student.attr("href")}"
       location = student.css('.student-location').text
       name = student.css('.student-name').text
       students << { name:name, location:location, profile_url:link }
     end
   end
   students
 end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    socials = {}

    socials[:profile_quote] = doc.css(".profile-quote").text if doc.css(".profile-quote")

    socials[:bio] = doc.css("div.bio-content.content-holder div.description-holder p").text if doc.css("div.bio-content.content-holder div.description-holder")

    urls = doc.css(".social-icon-container").css("a").collect{ |icon| icon.attribute("href").value }
    urls.each do |url|
      if url.include?("linkedin")
        socials[:linkedin] = url
      elsif url.include?("github")
        socials[:github] = url
      elsif url.include?("twitter")
        socials[:twitter] = url
      else
        socials[:blog] = url
      end
    end

    socials
  end


end

