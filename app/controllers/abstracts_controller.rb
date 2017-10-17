class AbstractsController < SiteController
  before_action :set_event
  before_action :ensure_accept_abstract, only: [:edit, :request_token,
                                                :send_token, :update]
  before_action :set_abstract, only: [:edit, :update]
  before_action :ensure_abstract_exists, only: [:edit, :update]
  before_action :ensure_token_is_valid, only: [:edit, :update]
  before_action :set_locale
  decorates_assigned :event

  def download_template
    if event.abstract_template.present?
      redirect_to event.abstract_template.url
    else
      flash[:alert] = I18n.t 'controllers.alerts.abstracts.no_template'
      redirect_to_event
    end
  end

  def edit; end

  def request_token
    @token_request = TokenRequest.new
  end

  def send_token
    @token_request = TokenRequest.new token_request_params
    if @token_request.valid?
      generate_and_send_token_for @token_request
      flash[:success] = I18n.t 'controllers.success.abstracts.token_sent',
                               email: @token_request.attendee.email
      redirect_to event_abstracts_url(event, request.query_parameters)
    else
      render action: :request_token
    end
  end

  def update
    @abstract.assign_attributes abstract_params
    @abstract.reset_token!
    should_notify = !@abstract.submitted? # only the first time
    @abstract.submitted_at = DateTime.now

    if @abstract.save
      AbstractMailer.submission_confirmation(@abstract).deliver_now if should_notify
      flash[:success] = I18n.t 'controllers.success.abstracts.submitted'
      redirect_to_event
    else
      render action: :edit
    end
  end

  private

  def abstract_params
    params.require(:abstract).permit :title, :document
  end

  def ensure_abstract_exists
    return if @abstract.present?
    flash[:alert] = I18n.t 'controllers.alerts.abstracts.invalid_token'
    redirect_to_event
  end

  def ensure_accept_abstract
    return if event.accepts_abstract?
    flash[:alert] = I18n.t 'controllers.alerts.abstracts.submission_disabled'
    redirect_to event_abstracts_url(event, request.query_parameters)
  end

  def ensure_token_is_valid
    return unless @abstract.token_expired?
    flash[:alert] = I18n.t 'controllers.alerts.abstracts.token_expired'
    redirect_to_event
  end

  def generate_and_send_token_for(token_request)
    abstract = Abstract.find_by event: event, author: token_request.attendee
    abstract ||= Abstract.new event: event, author: token_request.attendee
    abstract.randomize_token!
    abstract.save! validate: false
    AbstractMailer.submission_token(abstract).deliver_now
  end

  def redirect_to_event
    redirect_to event_url(event, request.query_parameters.merge(token: nil))
  end

  def set_abstract
    @abstract = Abstract.includes(:author, :event).find_by token: params[:token]
  end

  def set_event
    @event = Event.friendly.find params[:event_id].downcase
  end

  def set_locale
    locale = params[:lang]
    locale ||= @abstract.author.locale if defined?(@abstract)
    locale ||= I18n.default_locale
    I18n.locale = locale
  end

  def token_request_params
    params.require(:token_request).permit(:attendee_email).merge event: event
  end
end
