class PageDecorator < ContentDecorator
  delegate_all
  decorates_association :owner
end
