class ApplicationController < ActionController::Base
	def hello
		render html: "Haha"
	end
end
