class EmailInterceptor
  def self.delivering_email(message)
    message.subject = "#{message.to} #{message.subject}"
    message.to = [ 'y.couvant@cc-paysriberacois.fr' ]
  end
end
