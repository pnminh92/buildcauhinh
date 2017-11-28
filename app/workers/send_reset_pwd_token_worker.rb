# frozen_string_literal: true

class SendResetPwdTokenWorker
  include Sidekiq::Worker

  sidekiq_options queue: :mailers

  def perform(user_id)
    @user = User[user_id]
    mail(@user)
  end

  private

  def mail(user)
    tmpl_path = File.expand_path('../views/mailers/forgot_pwd.erb', File.dirname(__FILE__))
    Mail.deliver do
      from 'buildcauhinh <no-reply@buildcauhinh.com>'
      to user.email
      subject '[buildcauhinh] Khôi phục mật khẩu'
      body ERB.new(File.read(tmpl_path)).result(binding)
    end
  end
end
