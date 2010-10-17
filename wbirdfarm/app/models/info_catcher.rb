class InfoCatcher
	require 'rss'
	require 'uri'
	attr_accessor :item_title, :description, :link, :published_at
	
	def initialize
		@title = nil
		@description = nil
		@link = nil
		@published_at = nil
	end

	def self.get_rss(rss_url)
		begin
			ary = []
			unless rss_url.nil?
				url = URI.parse(rss_url).normalize
				open(url) do |http|
					response = http.read
					rss_result = RSS::Parser.parse(response, false)
					rss_result.items.each do |item|
						obj = self.new
						obj.item_title = item.title
						obj.description = item.content
						obj.link = item.link
						obj.published_at = item.date
						ary << obj
					end
				end
			end
			return ary
		rescue => e
			raise e
		end
	end
end
