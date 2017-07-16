class ContactMailerPreview < ActionMailer::Preview
  def contact_message
    ContactMailer.contact_message create_message
  end

  def contact_message_as_student
    ContactMailer.contact_message create_message(as_student: true)
  end

  private

  def create_message(data = {})
    ContactMessage.new fake_message_data.merge(data)
  end

  def fake_message_data
    {
      sender_name: 'Francisco Adasme Carreño',
      sender_email: 'francisco.adasme@gmail.com',
      body: \
        'Menandri iracuñdia referréntur no hás. Ut has prima dólor,' \
        "eu ómñis tritani nónumes est. Animal ocurreret éu eos, timeam\n\n" \
        "an cúm. Ad omnís sentéñtiae sit, sit ei quót vídit.\n" \
        'Omniúm appetere né, munere oportere ei nám, et solet regione nam.',
      as_student: false
    }
  end
end
