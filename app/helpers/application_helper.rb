module ApplicationHelper
	
	def full_title(last)
		if last.empty?
			title
		else
			"#{title} | #{Spree.t(last.downcase)}"
		end
	end
	
	def wrap(content)
		sanitize(raw(content.split.map{ |s| wrap_long_string(s) }.join(' ')))
	end

	private

		def wrap_long_string(text, max_width = 142)
			zero_width_space = "&#8203;"
			regex = /.{1,#{max_width}}/
					(text.length < max_width) ? text : 
					text.scan(regex).join(zero_width_space)
		end

end