module ApplicationHelper

	def full_title(last)
		first = "Apotecharie"
		if last.empty?
			first
		else
			"#{first} | #{last}"
		end
	end

end
