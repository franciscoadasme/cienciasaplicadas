class Admin::MailerController < AdminController
  layout 'default_mailer'

  def preview_invitation_instructions
    @user = User.invitation_not_accepted.last
    @group = Group.first
    @from = @user.invited_by.email
    @subject = t 'devise.mailer.invitation_instructions.subject', invited_by: @user.invited_by.full_name, group: @group.abbr

    @token = @user.raw_invitation_token
    render 'devise/mailer/invitation_instructions'
  end
end