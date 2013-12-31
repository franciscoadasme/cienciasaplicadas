class InvitationMailer < DefaultMailer
  def invite_message(user)
    @user = user
    @inviter = @user.invited_by
    @group = Group.first
    @from = @inviter.email
    @subject = t 'devise.mailer.invitation_instructions.subject', invited_by: @user.invited_by.full_name, group: @group.abbr

    @token = user.raw_invitation_token
    invitation_link = accept_user_invitation_url(invitation_token: @token)

    mail(to: @user.email,
         subject: @subject,
         template_path: 'devise/mailer',
         template_name: 'invitation_instructions')
  end
end