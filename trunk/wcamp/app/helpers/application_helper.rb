# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	def show_time date
		[nil,""].include?(date) ? "-" : date.strftime("%Y-%m-%d %H:%M")
	end

	def show_date date
		[nil,""].include?(date) ? "-" : date.strftime("%Y-%m-%d")
	end

	def link_menu_to(name, options = {}, html_options ={})
		html_options = {:class => 'active'}.merge(html_options) if current_page?(options)
		link_to name, options, html_options
	end
end
