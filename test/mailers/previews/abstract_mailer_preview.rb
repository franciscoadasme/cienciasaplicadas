class AbstractMailerPreview < ActionMailer::Preview
  def submission_token
    AbstractMailer.submission_token(Abstract.first)
  end

  def submission_confirmation
    AbstractMailer.submission_confirmation(Abstract.first)
  end
end
