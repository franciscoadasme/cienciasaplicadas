module Mailgun
	def self.client
		@mailgun ||= Mailgun(
			api_key: ENV['MAILGUN_API_KEY'],
			domain: ENV['MAILGUN_DOMAIN'])
	end
end