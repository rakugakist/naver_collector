# coding: utf-8

require "open-uri"

class ImageSite
  REGEX = /"(http:\/\/(.*?)\.(jpg|jpeg|png|gif|bmp))"/

  def initialize(url)
    @url = url
  end

  def download
    image_buff = open(@url).each.map {|line|
      if line =~ REGEX then $1 end
    }.compact

    if image_buff != []
      image = image_buff.first
      puts image
      begin 
        open(File.basename(image), "wb") {|file|
          file << open(image).read
        }
      rescue => ex
        puts ex.message
      end
    else
      puts "ImageSite: no image url"
    end
  end
end

class ListSite
  REGEX = /http:\/\/matome\.naver\.jp\/odai\/(\d+)\/(\d+)/

  def initialize(url)
    @url = url
  end
  
  def download_all
    open(@url).each.map {|line|
      if line =~ REGEX then $& end
    }.compact.uniq.map {|iu|
      ImageSite.new(iu)
    }.each {|is|
      is.download
    }
  end
end

url = gets.chomp
ListSite.new(url).download_all

