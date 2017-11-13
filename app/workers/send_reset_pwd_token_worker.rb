class SendResetPwdTokenWorker
  include Sidekiq::Worker

  def perform(user_id)
    @user = User[user_id]
    mail(@user)
  end

  private

  def mail(user)
    tmpl_path = File.expand_path('../views/mailers/forgot_pwd.erb', File.dirname(__FILE__))
    Mail.deliver do
      from 'timgialinhkien@gmail.com'
      to user.email
      subject '[timgialinhkien] Khôi phục mật khẩu'
      body ERB.new(File.read(tmpl_path)).result(binding)
    end
  end
end
