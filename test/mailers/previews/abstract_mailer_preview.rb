class AbstractMailerPreview < ActionMailer::Preview
  def submission_token
    AbstractMailer.submission_token(Abstract.first)
  end
end
