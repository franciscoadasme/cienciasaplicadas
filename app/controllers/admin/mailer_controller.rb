class Admin::MailerController < AdminController
  layout 'default_mailer'

  def preview_invitation_instructions
    @user = User.new first_name: 'Sergio', last_name: 'Valenzuela', nickname: 'svalenzuela', email: 'svalenzuela@utalca.cl'
    @user.invited_by ||= User.find_by nickname: 'fadasme'
    @group = Group.first
    @from = @user.invited_by.email
    @subject = t 'devise.mailer.invitation_instructions.subject', invited_by: @user.invited_by.full_name, group: @group.abbr

    @token = @user.raw_invitation_token
    render 'devise/mailer/invitation_instructions'
  end

  def preview_contact_message
    @sender = 'Francisco Adasme'
    @email = 'francisco.adasme@gmail.com'
    @content = 'Ut rhoncus accumsan hendrerit. Donec porta dui in ultricies auctor. In pulvinar ultricies sem, in scelerisque ante varius a. Etiam luctus molestie dui, a suscipit lacus ullamcorper vel. Aliquam erat volutpat. In dolor odio, luctus at egestas eget, egestas nec lorem. Cras in egestas enim.'
    @as_student = true

    @group = Group.first
    render 'mailer/send_contact_message'
  end

  def preview_journal_notification
    @journals = Journal.all
    # @journals = Journal.limit(1)
    render 'mailer/send_journal_notification'
  end
end