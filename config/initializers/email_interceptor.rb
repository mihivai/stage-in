if Rails.env.production?
  require "email_interceptor"
  ActionMailer::Base.register_interceptor(EmailInterceptor)
end
